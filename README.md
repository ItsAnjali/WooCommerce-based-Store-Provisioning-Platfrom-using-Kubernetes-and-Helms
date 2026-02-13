
🚀 Store Provisioning Platform (WooCommerce Multi-Tenant Engine)
This project is a Kubernetes-based Store Provisioning Engine that automatically creates isolated WooCommerce (WordPress) stores on demand using Helm.
It simulates how SaaS platforms dynamically provision customer environments with proper isolation, orchestration, and lifecycle management.

📌 Project Overview
The platform allows users to:
-Create stores from a dashboard
-Automatically provision WordPress (WooCommerce-ready) using Helm
-Run each store in an isolated Kubernetes namespace
-Track provisioning state
-Delete stores and clean resources automatically

🏗️ Architecture
Frontend (React)
-Dashboard UI
-Trigger store creation/deletion

Backend (Node.js + Express)
-Provisioning orchestrator
-Runs Helm install/uninstall
-Updates store status

Database (MongoDB)
-Stores metadata and status

Kubernetes + Helm
-Deploys WooCommerce store per namespace

🔄 Flow
Create Store → Helm deploys resources → Store becomes ready → Place order in WooCommerce → Delete Store → Helm uninstall + namespace cleanup.

🔒 Isolation & Reliability

Dedicated namespace per store
Separate pods, services, DB, PVC
Cleanup guaranteed via namespace deletion
Failed provisioning marked in DB

🧪 Local Setup

minikube start
helm repo add bitnami https://charts.bitnami.com/bitnami

Backend:
cd store-api
npm install
npm start

Frontend:
cd store-client
npm install
npm start

🌍 Production-like (VPS / k3s)

curl -sfL https://get.k3s.io | sh -
helm install store-platform ./helm/store-platform

Production changes via Helm values:
-ingress + domain
-storage class
-secrets
-TLS

📦 Helm Charts
helm/store-platform/
Includes local and production values files.

🧠 System Design & Tradeoffs
-Namespace-per-store for isolation
-Helm used for reproducible deployments
-Status tracking for failure handling
-Cleanup via Helm uninstall + namespace delete

Production requires:
-DNS + ingress
-managed storage
-secure secrets handling

Thank you for reading and reviewing my project.
