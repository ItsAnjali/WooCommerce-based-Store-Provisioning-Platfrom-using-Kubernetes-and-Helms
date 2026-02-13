const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
const { exec, spawn } = require("child_process");
const util = require("util");
const net = require("net");

const execPromise = util.promisify(exec);

const app = express();
app.use(cors());
app.use(express.json());

/* ===============================
   MongoDB
================================ */
mongoose
  .connect(process.env.MONGODB_URI || "mongodb://localhost:27017/store-db")
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log("Mongo error:", err));

/* ===============================
   Store Schema
================================ */
const StoreSchema = new mongoose.Schema(
  {
    name: String,
    engine: String,
    status: { type: String, default: "Provisioning" },
    url: String,
    namespace: String,
    localPort: Number,
    username: String,
    password: String
  },
  { timestamps: true }
);

const Store = mongoose.model("Store", StoreSchema);

/* ===============================
   PORT FORWARD STORAGE
================================ */
const activePortForwards = new Map();

/* ===============================
   Find Available Port
================================ */
async function findAvailablePort(start = 9000) {
  for (let port = start; port < start + 500; port++) {
    try {
      await new Promise((resolve, reject) => {
        const server = net.createServer();
        server.once("error", reject);
        server.once("listening", () => {
          server.close();
          resolve();
        });
        server.listen(port);
      });
      return port;
    } catch {}
  }
  throw new Error("No free ports");
}

/* ===============================
   Wait for Pods Ready
================================ */
async function waitForPodsReady(namespace, timeout = 180000) {
  const start = Date.now();

  while (Date.now() - start < timeout) {
    try {
      const { stdout } = await execPromise(
        `kubectl get pods -n ${namespace} -o json`
      );

      const pods = JSON.parse(stdout).items;
      if (!pods.length) continue;

      const ready = pods.every(p =>
        p.status.phase === "Running" &&
        (p.status.containerStatuses || []).every(c => c.ready)
      );

      if (ready) return true;

    } catch {}

    await new Promise(r => setTimeout(r, 5000));
  }

  throw new Error("Pods not ready");
}

/* ===============================
   Start Port Forward (FIXED)
================================ */
function startPortForward(namespace, serviceName, localPort) {

  const key = `${namespace}-${serviceName}`;

  if (activePortForwards.has(key)) {
    activePortForwards.get(key).kill();
  }

  const pf = spawn("kubectl", [
    "port-forward",
    "-n",
    namespace,
    `svc/${serviceName}`,
    `${localPort}:8080` // ⭐ FIXED PORT
  ]);

  pf.stdout.on("data", d =>
    console.log(`[${namespace}] ${d.toString()}`)
  );

  pf.stderr.on("data", d =>
    console.log(`[${namespace}] ${d.toString()}`)
  );

  pf.on("close", () => {
    activePortForwards.delete(key);
  });

  activePortForwards.set(key, pf);
}

/* ===============================
   GET STORES
================================ */
app.get("/stores", async (req, res) => {
  const stores = await Store.find().sort({ createdAt: -1 });
  res.json(stores);
});

/* ===============================
   CREATE STORE
================================ */
app.post("/stores", async (req, res) => {
  try {

    const storeName = `store-${Date.now()}`;
    const namespace = storeName;

    const username = "admin";
    const password = `pass${Math.random().toString(36).slice(2,8)}`;

    const localPort = await findAvailablePort();

    const newStore = await Store.create({
      name: storeName,
      engine: "WooCommerce",
      status: "Provisioning",
      namespace,
      localPort,
      username,
      password
    });

    const cmd =
      `helm install ${storeName} bitnami/wordpress ` +
      `--namespace ${namespace} --create-namespace ` +
      `--set service.type=ClusterIP ` +
      `--set wordpressUsername=${username} ` +
      `--set wordpressPassword=${password}`;

    console.log("Running:", cmd);

    exec(cmd, async (err, stdout, stderr) => {

      if (err) {
        console.log(stderr);
        await Store.findByIdAndUpdate(newStore._id, {
          status: "Failed"
        });
        return;
      }

      try {

        await waitForPodsReady(namespace);

        startPortForward(
          namespace,
          `${storeName}-wordpress`,
          localPort
        );

        const url = `http://localhost:${localPort}`;

        await Store.findByIdAndUpdate(newStore._id, {
          status: "Ready",
          url
        });

        console.log("Store Ready:", url);

      } catch (e) {
        console.log(e);
        await Store.findByIdAndUpdate(newStore._id, {
          status: "Failed"
        });
      }
    });

    res.json(newStore);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* ===============================
   DELETE STORE
================================ */
app.delete("/stores/:id", async (req, res) => {

  const store = await Store.findById(req.params.id);
  if (!store) return res.status(404).json({});

  const key = `${store.namespace}-${store.name}-wordpress`;

  if (activePortForwards.has(key)) {
    activePortForwards.get(key).kill();
    activePortForwards.delete(key);
  }

  exec(`helm uninstall ${store.name} -n ${store.namespace}`);
  exec(`kubectl delete namespace ${store.namespace}`);

  await Store.findByIdAndDelete(req.params.id);

  res.json({ message: "Deleted" });
});

/* ===============================
   START SERVER
================================ */
app.listen(5000, () => {
  console.log("Backend running on 5000");
});

/* ===============================
   Cleanup on Exit
================================ */
process.on("SIGINT", () => {
  for (const pf of activePortForwards.values()) {
    pf.kill();
  }
  process.exit();
});
