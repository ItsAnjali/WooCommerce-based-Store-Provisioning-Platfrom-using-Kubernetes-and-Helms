@echo off
set POD_NAME=store-1770995242928-wordpress-78bf565449-t4n8b
set NAMESPACE=store-1770995242928

color 0A
echo ========================================
echo 🚀 ADDING PRODUCTS AND ALL FEATURES
echo ========================================
echo.

:: STEP 1: CREATE PRODUCT CATEGORIES
echo 📁 Creating product categories...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Electronics" --description="Electronic gadgets and devices" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Clothing" --description="Fashion and apparel" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Books" --description="Books and publications" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Home & Kitchen" --description="Home decor and kitchen items" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Sports" --description="Sports and outdoor equipment" --user=admin
echo ✅ Categories created
echo.

:: STEP 2: ADD PRODUCTS - ALL ON SINGLE LINES
echo 📦 Adding products...

echo   - Adding Electronics...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Sony Wireless Headphones" --type="simple" --regular_price="89.99" --sale_price="69.99" --description="Premium wireless headphones with noise cancellation. 30-hour battery life." --short_description="Noise cancelling headphones" --stock_quantity=50 --manage_stock=true --featured=true --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Apple AirPods Pro" --type="simple" --regular_price="249.99" --sale_price="199.99" --description="Active noise cancellation, transparency mode, wireless charging." --short_description="Premium wireless earbuds" --stock_quantity=30 --manage_stock=true --featured=true --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Samsung 4K Smart TV" --type="simple" --regular_price="599.99" --sale_price="499.99" --description="55-inch 4K Ultra HD Smart TV with HDR and built-in streaming." --short_description="55-inch 4K TV" --stock_quantity=15 --manage_stock=true --featured=true --user=admin

echo   - Adding Clothing...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Premium Cotton T-Shirt" --type="simple" --regular_price="24.99" --description="100% organic cotton t-shirt, super soft and comfortable." --short_description="Organic cotton t-shirt" --stock_quantity=100 --manage_stock=true --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Slim Fit Jeans" --type="simple" --regular_price="59.99" --sale_price="49.99" --description="Premium stretch denim jeans with slim fit design." --short_description="Stretch denim jeans" --stock_quantity=80 --manage_stock=true --featured=true --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Winter Hoodie" --type="simple" --regular_price="49.99" --description="Warm and comfortable hoodie with fleece lining." --short_description="Warm winter hoodie" --stock_quantity=65 --manage_stock=true --user=admin

echo   - Adding Books...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Web Development Guide" --type="simple" --regular_price="39.99" --description="Complete guide to modern web development." --short_description="Learn web development" --stock_quantity=40 --manage_stock=true --featured=true --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Atomic Habits" --type="simple" --regular_price="24.99" --description="Build good habits and break bad ones." --short_description="Habits book" --stock_quantity=75 --manage_stock=true --user=admin

echo   - Adding Home & Kitchen...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Cookware Set" --type="simple" --regular_price="149.99" --sale_price="119.99" --description="12-piece non-stick cookware set." --short_description="12-piece cookware set" --stock_quantity=25 --manage_stock=true --featured=true --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Coffee Maker" --type="simple" --regular_price="89.99" --description="Programmable coffee maker with 12-cup capacity." --short_description="Coffee maker" --stock_quantity=35 --manage_stock=true --user=admin

echo   - Adding Sports...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Yoga Mat" --type="simple" --regular_price="39.99" --sale_price="29.99" --description="Non-slip exercise yoga mat with carrying strap." --short_description="Non-slip yoga mat" --stock_quantity=60 --manage_stock=true --featured=true --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create --name="Dumbbell Set" --type="simple" --regular_price="199.99" --sale_price="159.99" --description="20kg adjustable dumbbell set with storage rack." --short_description="Adjustable dumbbells" --stock_quantity=20 --manage_stock=true --featured=true --user=admin

echo ✅ All products added
echo.

:: STEP 3: CONFIGURE PAYMENT METHODS
echo 💳 Configuring payment methods...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc payment_gateway update cod --enabled=true --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc payment_gateway update bacs --enabled=true --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp option update woocommerce_enable_guest_checkout "yes"
echo ✅ Payment methods enabled
echo.

:: STEP 4: CONFIGURE SHIPPING
echo 🚚 Configuring shipping...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc shipping_zone create --name="United States" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc shipping_zone_method create 0 --method_id="flat_rate" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp option update woocommerce_enable_shipping_calc "yes"
echo ✅ Shipping configured
echo.

:: STEP 5: CREATE ORDER CONFIRMATION PAGE
echo ✅ Creating order confirmation page...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp post create --post_type=page --post_title="Order Confirmation" --post_content="<h1>Thank You for Your Order!</h1><p>Your order has been received.</p>" --post_status=publish --post_name="order-confirmation"
echo ✅ Order confirmation page created
echo.

:: STEP 6: GET PAGE IDS AND UPDATE MENU
echo 📋 Updating menu...
for /f "tokens=*" %%i in ('kubectl exec -n %NAMESPACE% %POD_NAME% -- wp post list --post_type=page --post_name=shop --format=ids') do set SHOP_ID=%%i
for /f "tokens=*" %%i in ('kubectl exec -n %NAMESPACE% %POD_NAME% -- wp post list --post_type=page --post_name=order-confirmation --format=ids') do set CONFIRM_ID=%%i
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu %CONFIRM_ID%
echo ✅ Menu updated
echo.

:: STEP 7: CREATE SAMPLE ORDER
echo 📝 Creating sample order...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc order create --status="processing" --payment_method="cod" --billing="{\"first_name\":\"John\",\"last_name\":\"Doe\",\"address_1\":\"123 Main St\",\"city\":\"New York\",\"postcode\":\"10001\",\"email\":\"john@example.com\"}" --line_items="[{\"product_id\":16,\"quantity\":2},{\"product_id\":13,\"quantity\":1}]" --user=admin
echo ✅ Sample order created
echo.

:: STEP 8: CLEAR CACHE
echo 🧹 Clearing cache...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp cache flush
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp transient delete-all
echo ✅ Cache cleared
echo.

:: STEP 9: SHOW PRODUCT COUNT
echo ========================================
echo 📊 VERIFYING PRODUCTS:
echo ========================================
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product list --user=admin --fields=id,name,price --format=table

echo.
echo ========================================
echo ✅✅✅ STORE READY! ✅✅✅
echo ========================================
echo.
echo 🌐 VISIT YOUR STORE: http://localhost:9090/shop
echo 🔑 ADMIN: http://localhost:9090/wp-admin
echo.
echo ========================================
pause
start http://localhost:9090/shop