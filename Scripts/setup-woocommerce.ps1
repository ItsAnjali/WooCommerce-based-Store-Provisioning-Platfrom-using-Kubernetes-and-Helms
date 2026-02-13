$POD_NAME="store-1770995242928-wordpress-78bf565449-t4n8b"
$NAMESPACE="store-1770995242928"

# Activate WooCommerce
kubectl exec -n $NAMESPACE $POD_NAME -- wp plugin activate woocommerce

# Install WooCommerce pages
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc tool run install_pages --user=admin

# Checkout settings
kubectl exec -n $NAMESPACE $POD_NAME -- wp option update woocommerce_enable_guest_checkout "yes"
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc payment_gateway update cod --enabled=true --user=admin
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc payment_gateway update bacs --enabled=true --user=admin

# Shipping
kubectl exec -n $NAMESPACE $POD_NAME -- wp option update woocommerce_enable_shipping_calc "yes"
kubectl exec -n $NAMESPACE $POD_NAME -- wp option update woocommerce_ship_to_countries "all"

# Categories
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product_cat create --name="Electronics" --user=admin
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product_cat create --name="Clothing" --user=admin
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product_cat create --name="Books" --user=admin

# List categories
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product_cat list --fields=id,name --user=admin

# Products
kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product create --name="Wireless Headphones" --type="simple" --regular_price="79.99" --sale_price="59.99" --description="High-quality wireless headphones with noise cancellation" --short_description="Premium wireless headphones" --stock_quantity=50 --manage_stock=true --user=admin

kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product create --name="Classic T-Shirt" --type="simple" --regular_price="24.99" --description="Comfortable cotton t-shirt" --stock_quantity=100 --manage_stock=true --user=admin

kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product create --name="The Complete Web Development Guide" --type="simple" --regular_price="39.99" --description="Learn web development from scratch" --stock_quantity=30 --manage_stock=true --user=admin

kubectl exec -n $NAMESPACE $POD_NAME -- wp wc product create --name="Smart Watch" --type="simple" --regular_price="199.99" --sale_price="149.99" --description="Feature-rich smartwatch with health tracking" --featured=true --stock_quantity=25 --manage_stock=true --user=admin
