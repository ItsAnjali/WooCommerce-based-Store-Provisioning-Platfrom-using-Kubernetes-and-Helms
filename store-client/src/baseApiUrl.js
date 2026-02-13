// Determine backend URL based on environment
// Local: connect directly to port 5000
// Kubernetes: use service with port-forward 7000:7000
const isKubernetes = window.location.hostname !== "localhost" && window.location.hostname !== "127.0.0.1";
export const BASE_URL = isKubernetes 
  ? "http://store-platform-backend-service:7000" 
  : "http://localhost:5000";
