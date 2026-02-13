

🚀 Store Provisioning Platform (WooCommerce Multi-Tenant Engine)

This project is a Kubernetes-based Store Provisioning Engine that automatically creates isolated WooCommerce (WordPress) stores on demand using Helm.

It simulates how SaaS platforms dynamically provision customer environments with proper isolation, orchestration, and lifecycle management.


---

🧠 System Architecture

Frontend (React)

Dashboard to create & delete stores

Displays status (Provisioning → Ready)

Shows store URL dynamically


Backend (Node.js + Express)

Acts as provisioning engine

Generates unique store names

Creates Kubernetes namespaces

Runs Helm install/uninstall commands

Manages store lifecycle

Handles port-forwarding for local access


Database (MongoDB)

Stores store metadata

Tracks provisioning status

Maintains URLs and credentials


Infrastructure (Kubernetes + Helm)

Each store runs in its own namespace

WordPress + MariaDB deployed via Helm

Complete resource isolation per store



---

⚙️ End-to-End Flow

1. User clicks Create Store


2. Backend:

Generates unique namespace

Saves store entry (Provisioning)

Installs WordPress via Helm



3. Kubernetes creates:

Namespace

WordPress pod

MariaDB pod

Services & PVC



4. Backend waits for pods to become Ready


5. Port-forward is started automatically


6. Store status updated to Ready


7. Store URL becomes accessible


8. Store can be deleted → Helm uninstall + namespace cleanup




---

🔒 Isolation & Multi-Tenancy

Dedicated namespace per store

Separate database per store

Separate services & pods

PVC-backed persistent storage

No shared runtime resources


This ensures strong tenant isolation.


---

🛠 Tech Stack

React.js

Node.js + Express

MongoDB + Mongoose

Kubernetes (Minikube)

Helm (Bitnami WordPress Chart)

WooCommerce (via WordPress)



---

🚧 Key Features Implemented

Dynamic Helm provisioning

Namespace-based isolation

Automatic port-forward per store

Store lifecycle management

WooCommerce customization support

Product creation using WP-CLI

Clean uninstall & namespace deletion

Status tracking (Provisioning / Ready / Failed)



---

📦 Running Locally

1. Start Minikube


2. Install Helm


3. Run backend


4. Run frontend


5. Create stores from dashboard



Stores are accessible via dynamic localhost ports.


---

🌍 Production Deployment Plan

For production:

Replace port-forward with Ingress

Use LoadBalancer / NGINX Ingress Controller

Configure domains per store

Add TLS via cert-manager

Deploy on AWS/GCP free tier or VPS (k3s)

Store secrets securely

Add ResourceQuota & LimitRange per namespace

