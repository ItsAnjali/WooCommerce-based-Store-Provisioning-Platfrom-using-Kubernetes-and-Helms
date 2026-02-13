import { useEffect, useState } from "react";
import { BASE_URL } from "./baseApiUrl";

function App() {
  const [stores, setStores] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedStore, setSelectedStore] = useState(null);
  const [customizationData, setCustomizationData] = useState({
    siteTitle: "",
    tagline: "",
    theme: "storefront",
    plugins: ["woocommerce"],
    products: [{ name: "", price: "" }],
    pages: [{ title: "", content: "" }]
  });
  const [showCustomizeModal, setShowCustomizeModal] = useState(false);
  const [productCount, setProductCount] = useState(10);

  const loadStores = async () => {
    try {
      setLoading(true);
      const res = await fetch(`${BASE_URL}/stores`);
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      const data = await res.json();
      setStores(data);
    } catch (err) {
      console.error("Error loading stores", err);
      alert("Failed to load stores: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  const createStore = async () => {
    try {
      const res = await fetch(`${BASE_URL}/stores`, {
        method: "POST",
        headers: { "Content-Type": "application/json" }
      });
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      loadStores();
    } catch (err) {
      console.error("Error creating store", err);
      alert("Failed to create store: " + err.message);
    }
  };

  const deleteStore = async (id) => {
    if (!window.confirm("Are you sure you want to delete this store?")) return;
    
    try {
      const res = await fetch(`${BASE_URL}/stores/${id}`, {
        method: "DELETE"
      });
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      loadStores();
    } catch (err) {
      console.error("Error deleting store", err);
      alert("Failed to delete store: " + err.message);
    }
  };
  
  const customizeStore = async () => {
    if (!selectedStore) return;
    
    try {
      setLoading(true);
      const res = await fetch(`${BASE_URL}/stores/${selectedStore._id}/customize`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(customizationData)
      });
      
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      
      const result = await res.json();
      alert("Store customized successfully! Check console for details.");
      console.log("Customization result:", result);
      setShowCustomizeModal(false);
    } catch (err) {
      console.error("Error customizing store", err);
      alert("Failed to customize store: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  const createSampleProducts = async (storeId) => {
    try {
      setLoading(true);
      const res = await fetch(`${BASE_URL}/stores/${storeId}/products/bulk`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ count: productCount })
      });
      
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      
      alert(`Successfully created ${productCount} sample products!`);
    } catch (err) {
      console.error("Error creating sample products", err);
      alert("Failed to create sample products: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  const checkStoreStatus = async (storeId) => {
    try {
      const res = await fetch(`${BASE_URL}/stores/${storeId}/status`);
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      const data = await res.json();
      
      if (data.accessible) {
        alert(`Store is accessible at ${data.url}`);
      } else {
        alert(`Store status: ${data.status}\nMessage: ${data.message || "Not accessible yet"}`);
      }
    } catch (err) {
      console.error("Error checking status", err);
      alert("Failed to check store status");
    }
  };

  const openCustomizeModal = (store) => {
    setSelectedStore(store);
    setCustomizationData({
      siteTitle: `Store ${new Date().toLocaleDateString()}`,
      tagline: "Your Awesome Store",
      theme: "storefront",
      plugins: ["woocommerce", "elementor"],
      products: [
        { name: "Sample Product 1", price: "19.99" },
        { name: "Sample Product 2", price: "29.99" }
      ],
      pages: [
        { title: "About Us", content: "Welcome to our store! We sell amazing products." },
        { title: "Contact", content: "Get in touch with us at contact@example.com" }
      ]
    });
    setShowCustomizeModal(true);
  };

  useEffect(() => {
    loadStores();
  }, []);

  return (
    <div style={{ padding: 30, fontFamily: 'Arial, sans-serif' }}>
      <h1 style={{ color: '#333', borderBottom: '2px solid #007bff', paddingBottom: 10 }}>
        🚀 Store Provisioning Platform
      </h1>

      <div style={{ marginBottom: 20, display: 'flex', gap: 10 }}>
        <button 
          onClick={createStore} 
          style={{
            padding: '10px 20px',
            backgroundColor: '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: 5,
            cursor: 'pointer',
            fontSize: 16
          }}
        >
          + Create New Store
        </button>
      </div>

      {loading && <p style={{ color: '#666' }}>Loading...</p>}

      <div style={{ overflowX: 'auto' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', boxShadow: '0 2px 5px rgba(0,0,0,0.1)' }}>
          <thead>
            <tr style={{ backgroundColor: '#f8f9fa' }}>
              <th style={{ padding: 12, textAlign: 'left', borderBottom: '2px solid #dee2e6' }}>Name</th>
              <th style={{ padding: 12, textAlign: 'left', borderBottom: '2px solid #dee2e6' }}>Engine</th>
              <th style={{ padding: 12, textAlign: 'left', borderBottom: '2px solid #dee2e6' }}>Status</th>
              <th style={{ padding: 12, textAlign: 'left', borderBottom: '2px solid #dee2e6' }}>URL</th>
              <th style={{ padding: 12, textAlign: 'left', borderBottom: '2px solid #dee2e6' }}>Admin</th>
              <th style={{ padding: 12, textAlign: 'left', borderBottom: '2px solid #dee2e6' }}>Created</th>
              <th style={{ padding: 12, textAlign: 'left', borderBottom: '2px solid #dee2e6' }}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {stores.length === 0 ? (
              <tr>
                <td colSpan="7" style={{ padding: 20, textAlign: 'center', color: '#666' }}>
                  No stores found. Click "Create New Store" to get started!
                </td>
              </tr>
            ) : (
              stores.map(store => (
                <tr key={store._id} style={{ borderBottom: '1px solid #dee2e6' }}>
                  <td style={{ padding: 12 }}>{store.name}</td>
                  <td style={{ padding: 12 }}>{store.engine}</td>
                  <td style={{ padding: 12 }}>
                    <span style={{
                      padding: '4px 8px',
                      borderRadius: 4,
                      backgroundColor: store.status === 'Ready' ? '#d4edda' : '#fff3cd',
                      color: store.status === 'Ready' ? '#155724' : '#856404'
                    }}>
                      {store.status}
                    </span>
                  </td>
                  <td style={{ padding: 12 }}>
                    {store.url ? (
                      <a href={store.url} target="_blank" rel="noopener noreferrer" style={{ color: '#007bff' }}>
                        Open Store
                      </a>
                    ) : '-'}
                  </td>
                  <td style={{ padding: 12 }}>
                    {store.adminUrl ? (
                      <a href={store.adminUrl} target="_blank" rel="noopener noreferrer" style={{ color: '#28a745' }}>
                        Admin Login
                      </a>
                    ) : '-'}
                  </td>
                  <td style={{ padding: 12 }}>{new Date(store.createdAt).toLocaleString()}</td>
                  <td style={{ padding: 12 }}>
                    <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                      <button 
                        onClick={() => openCustomizeModal(store)}
                        style={{
                          padding: '5px 10px',
                          backgroundColor: '#17a2b8',
                          color: 'white',
                          border: 'none',
                          borderRadius: 3,
                          cursor: 'pointer',
                          fontSize: 12
                        }}
                      >
                        Customize
                      </button>
                      <button 
                        onClick={() => createSampleProducts(store._id)}
                        style={{
                          padding: '5px 10px',
                          backgroundColor: '#28a745',
                          color: 'white',
                          border: 'none',
                          borderRadius: 3,
                          cursor: 'pointer',
                          fontSize: 12
                        }}
                      >
                        Add Products
                      </button>
                      <button 
                        onClick={() => checkStoreStatus(store._id)}
                        style={{
                          padding: '5px 10px',
                          backgroundColor: '#ffc107',
                          color: 'black',
                          border: 'none',
                          borderRadius: 3,
                          cursor: 'pointer',
                          fontSize: 12
                        }}
                      >
                        Check Status
                      </button>
                      <button 
                        onClick={() => deleteStore(store._id)}
                        style={{
                          padding: '5px 10px',
                          backgroundColor: '#dc3545',
                          color: 'white',
                          border: 'none',
                          borderRadius: 3,
                          cursor: 'pointer',
                          fontSize: 12
                        }}
                      >
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Customization Modal */}
      {showCustomizeModal && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: 'rgba(0,0,0,0.5)',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          zIndex: 1000
        }}>
          <div style={{
            backgroundColor: 'white',
            padding: 30,
            borderRadius: 10,
            maxWidth: 600,
            maxHeight: '80vh',
            overflowY: 'auto'
          }}>
            <h2 style={{ marginTop: 0 }}>Customize Store: {selectedStore?.name}</h2>
            
            <div style={{ marginBottom: 20 }}>
              <label style={{ display: 'block', marginBottom: 5, fontWeight: 'bold' }}>
                Site Title:
              </label>
              <input
                type="text"
                value={customizationData.siteTitle}
                onChange={(e) => setCustomizationData({
                  ...customizationData,
                  siteTitle: e.target.value
                })}
                style={{ width: '100%', padding: 8, borderRadius: 4, border: '1px solid #ced4da' }}
              />
            </div>

            <div style={{ marginBottom: 20 }}>
              <label style={{ display: 'block', marginBottom: 5, fontWeight: 'bold' }}>
                Tagline:
              </label>
              <input
                type="text"
                value={customizationData.tagline}
                onChange={(e) => setCustomizationData({
                  ...customizationData,
                  tagline: e.target.value
                })}
                style={{ width: '100%', padding: 8, borderRadius: 4, border: '1px solid #ced4da' }}
              />
            </div>

            <div style={{ marginBottom: 20 }}>
              <label style={{ display: 'block', marginBottom: 5, fontWeight: 'bold' }}>
                Theme:
              </label>
              <select
                value={customizationData.theme}
                onChange={(e) => setCustomizationData({
                  ...customizationData,
                  theme: e.target.value
                })}
                style={{ width: '100%', padding: 8, borderRadius: 4, border: '1px solid #ced4da' }}
              >
                <option value="storefront">Storefront (WooCommerce)</option>
                <option value="twentytwentyfour">Twenty Twenty-Four</option>
                <option value="astra">Astra</option>
                <option value="oceanwp">OceanWP</option>
              </select>
            </div>

            <div style={{ marginBottom: 20 }}>
              <label style={{ display: 'block', marginBottom: 5, fontWeight: 'bold' }}>
                Plugins (comma separated):
              </label>
              <input
                type="text"
                value={customizationData.plugins.join(', ')}
                onChange={(e) => setCustomizationData({
                  ...customizationData,
                  plugins: e.targetValue.split(',').map(p => p.trim())
                })}
                style={{ width: '100%', padding: 8, borderRadius: 4, border: '1px solid #ced4da' }}
              />
              <small style={{ color: '#666' }}>e.g., woocommerce, elementor, yoast-seo</small>
            </div>

            <div style={{ marginBottom: 20 }}>
              <label style={{ display: 'block', marginBottom: 5, fontWeight: 'bold' }}>
                Sample Products Count:
              </label>
              <input
                type="number"
                value={productCount}
                onChange={(e) => setProductCount(parseInt(e.target.value))}
                min="1"
                max="100"
                style={{ width: '100px', padding: 8, borderRadius: 4, border: '1px solid #ced4da' }}
              />
            </div>

            <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end' }}>
              <button
                onClick={() => setShowCustomizeModal(false)}
                style={{
                  padding: '10px 20px',
                  backgroundColor: '#6c757d',
                  color: 'white',
                  border: 'none',
                  borderRadius: 5,
                  cursor: 'pointer'
                }}
              >
                Cancel
              </button>
              <button
                onClick={customizeStore}
                disabled={loading}
                style={{
                  padding: '10px 20px',
                  backgroundColor: '#007bff',
                  color: 'white',
                  border: 'none',
                  borderRadius: 5,
                  cursor: 'pointer',
                  opacity: loading ? 0.5 : 1
                }}
              >
                {loading ? 'Customizing...' : 'Apply Customizations'}
              </button>
            </div>

            <div style={{ marginTop: 20, padding: 15, backgroundColor: '#f8f9fa', borderRadius: 5 }}>
              <h4>Store Credentials:</h4>
              <p><strong>Username:</strong> {selectedStore?.username || 'admin'}</p>
              <p><strong>Password:</strong> {selectedStore?.password || 'Check store details'}</p>
              <p><strong>Admin URL:</strong> {selectedStore?.adminUrl || 'Pending'}</p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default App;