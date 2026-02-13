@echo off
set POD_NAME=store-1770995242928-wordpress-78bf565449-t4n8b
set NAMESPACE=store-1770995242928

echo ========================================
echo 🚀 COMPLETE WOOCOMMERCE STORE SETUP
echo ========================================
echo.

:: STEP 1: ENSURE WOOCOMMERCE IS ACTIVE
echo 1. Activating WooCommerce...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp plugin activate woocommerce
echo ✅ WooCommerce activated
echo.

:: STEP 2: INSTALL AND ACTIVATE STOREFRONT THEME
echo 2. Installing Storefront theme...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp theme install storefront --activate
echo ✅ Storefront theme installed
echo.

:: STEP 3: CREATE PRODUCT CATEGORIES
echo 3. Creating product categories...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Electronics" --description="Electronic gadgets and devices" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Clothing" --description="Fashion and apparel" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Books" --description="Books and publications" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Home & Kitchen" --description="Home decor and kitchen items" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat create --name="Sports" --description="Sports and outdoor equipment" --user=admin
echo ✅ Categories created
echo.

:: STEP 4: GET CATEGORY IDS
echo 4. Getting category IDs...
for /f "tokens=*" %%i in ('kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product_cat list --fields=id,name --user=admin --format=json ^| findstr "id"') do set CATS=%%i
echo ✅ Category IDs retrieved
echo.

:: STEP 5: CREATE PRODUCTS
echo 5. Creating products...

:: Electronics Products
echo   - Adding Electronics products...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Sony Wireless Headphones" \
  --type="simple" \
  --regular_price="89.99" \
  --sale_price="69.99" \
  --description="Premium wireless headphones with noise cancellation technology. 30-hour battery life, comfortable over-ear design, and fast charging capability." \
  --short_description="Noise cancelling wireless headphones" \
  --categories='[{"id":23}]' \
  --stock_quantity=45 \
  --manage_stock=true \
  --featured=true \
  --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Apple AirPods Pro" \
  --type="simple" \
  --regular_price="249.99" \
  --sale_price="199.99" \
  --description="Active noise cancellation, transparency mode, adaptive EQ, and wireless charging case." \
  --short_description="Premium wireless earbuds" \
  --categories='[{"id":23}]' \
  --stock_quantity=30 \
  --manage_stock=true \
  --featured=true \
  --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Samsung 4K Smart TV" \
  --type="simple" \
  --regular_price="599.99" \
  --sale_price="499.99" \
  --description="55-inch 4K Ultra HD Smart TV with HDR, built-in streaming apps, and voice control." \
  --short_description="55-inch 4K Smart TV" \
  --categories='[{"id":23}]' \
  --stock_quantity=15 \
  --manage_stock=true \
  --featured=true \
  --user=admin

:: Clothing Products
echo   - Adding Clothing products...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Premium Cotton T-Shirt" \
  --type="variable" \
  --description="100% organic cotton t-shirt, super soft and comfortable. Available in multiple colors and sizes." \
  --short_description="Organic cotton t-shirt" \
  --categories='[{"id":24}]' \
  --attributes='[{"name":"Color","options":["Black","White","Navy","Gray","Red"]},{"name":"Size","options":["S","M","L","XL","XXL"]}]' \
  --stock_quantity=120 \
  --manage_stock=true \
  --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Slim Fit Jeans" \
  --type="variable" \
  --regular_price="59.99" \
  --sale_price="49.99" \
  --description="Premium stretch denim jeans with slim fit design. Perfect for casual and semi-formal occasions." \
  --short_description="Stretch denim jeans" \
  --categories='[{"id":24}]' \
  --attributes='[{"name":"Size","options":["30","32","34","36","38"]},{"name":"Color","options":["Blue","Black","Gray"]}]' \
  --stock_quantity=80 \
  --manage_stock=true \
  --featured=true \
  --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Winter Hoodie" \
  --type="variable" \
  --regular_price="49.99" \
  --description="Warm and comfortable hoodie with fleece lining. Perfect for cold weather." \
  --short_description="Warm winter hoodie" \
  --categories='[{"id":24}]' \
  --attributes='[{"name":"Color","options":["Black","Gray","Navy","Red"]},{"name":"Size","options":["S","M","L","XL"]}]' \
  --stock_quantity=65 \
  --manage_stock=true \
  --user=admin

:: Books Products
echo   - Adding Books products...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="The Complete Web Development Bootcamp" \
  --type="simple" \
  --regular_price="49.99" \
  --sale_price="39.99" \
  --description="Comprehensive guide to modern web development covering HTML, CSS, JavaScript, React, Node.js, and more. Includes projects and exercises." \
  --short_description="Learn web development" \
  --categories='[{"id":25}]' \
  --stock_quantity=50 \
  --manage_stock=true \
  --featured=true \
  --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Atomic Habits" \
  --type="simple" \
  --regular_price="24.99" \
  --description="The #1 bestselling book on building good habits and breaking bad ones. Transform your life with small changes." \
  --short_description="Build better habits" \
  --categories='[{"id":25}]' \
  --stock_quantity=75 \
  --manage_stock=true \
  --featured=true \
  --user=admin

:: Home & Kitchen Products
echo   - Adding Home & Kitchen products...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Non-Stick Cookware Set" \
  --type="simple" \
  --regular_price="149.99" \
  --sale_price="119.99" \
  --description="12-piece non-stick cookware set including frying pans, saucepans, and cooking utensils. Dishwasher safe and induction compatible." \
  --short_description="12-piece cookware set" \
  --categories='[{"id":26}]' \
  --stock_quantity=25 \
  --manage_stock=true \
  --featured=true \
  --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Coffee Maker Machine" \
  --type="simple" \
  --regular_price="89.99" \
  --description="Programmable coffee maker with 12-cup capacity, built-in grinder, thermal carafe, and auto shut-off." \
  --short_description="Programmable coffee maker" \
  --categories='[{"id":26}]' \
  --stock_quantity=35 \
  --manage_stock=true \
  --user=admin

:: Sports Products
echo   - Adding Sports products...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Premium Yoga Mat" \
  --type="simple" \
  --regular_price="39.99" \
  --sale_price="29.99" \
  --description="Non-slip exercise yoga mat with carrying strap. Perfect for yoga, pilates, and floor exercises. Eco-friendly material." \
  --short_description="Non-slip yoga mat" \
  --categories='[{"id":27}]' \
  --stock_quantity=60 \
  --manage_stock=true \
  --featured=true \
  --user=admin

kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc product create \
  --name="Adjustable Dumbbell Set" \
  --type="simple" \
  --regular_price="199.99" \
  --sale_price="159.99" \
  --description="20kg adjustable dumbbell set with storage rack. Perfect for home workouts. Replaces multiple dumbbells." \
  --short_description="Adjustable dumbbells" \
  --categories='[{"id":27}]' \
  --stock_quantity=20 \
  --manage_stock=true \
  --featured=true \
  --user=admin

echo ✅ All products created
echo.

:: STEP 6: CONFIGURE PAYMENT METHODS
echo 6. Configuring payment methods...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc payment_gateway update cod --enabled=true --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc payment_gateway update bacs --enabled=true --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp option update woocommerce_enable_guest_checkout "yes"
echo ✅ Payment methods configured
echo.

:: STEP 7: CONFIGURE SHIPPING
echo 7. Configuring shipping methods...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc shipping_zone create --name="United States" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc shipping_zone_method create 0 --method_id="flat_rate" --user=admin
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp option update woocommerce_enable_shipping_calc "yes"
echo ✅ Shipping configured
echo.

:: STEP 8: UPDATE SHOP PAGE WITH BETTER CONTENT
echo 8. Enhancing Shop page...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp post update 6 --post_content="
<!-- wp:heading {level:1} --><h1>Our Products</h1><!-- /wp:heading -->
<!-- wp:paragraph --><p>Browse our collection of high-quality products</p><!-- /wp:paragraph -->
<!-- wp:woocommerce/all-products /-->
<!-- wp:shortcode -->[products limit=24 columns=3 orderby=popularity]<!-- /wp:shortcode -->
"
echo ✅ Shop page updated
echo.

:: STEP 9: CREATE ORDER CONFIRMATION PAGE
echo 9. Creating Order Confirmation page...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp post create \
  --post_type=page \
  --post_title="Order Confirmation" \
  --post_content="
<!-- wp:heading {textAlign:center,level:1} --><h1 class=has-text-align-center>✅ Thank You for Your Order!</h1><!-- /wp:heading -->
<!-- wp:paragraph {align:center} --><p class=has-text-align-center>Your order has been received and is being processed.</p><!-- /wp:paragraph -->
<!-- wp:woocommerce/order-confirmation-status /-->
<!-- wp:woocommerce/order-confirmation-summary /-->
<!-- wp:woocommerce/order-confirmation-totals /-->
<!-- wp:woocommerce/order-confirmation-shipping-address /-->
<!-- wp:buttons {layout:{type:flex,justifyContent:center}} -->
<div class=wp-block-buttons>
  <!-- wp:button --><div class=wp-block-button><a class=wp-block-button__link href=/shop>Continue Shopping</a></div><!-- /wp:button -->
</div>
<!-- /wp:buttons -->
" \
  --post_status=publish \
  --post_name="order-confirmation" 2>nul

:: Get new order confirmation page ID
for /f "tokens=*" %%i in ('kubectl exec -n %NAMESPACE% %POD_NAME% -- wp post list --post_type=page --post_name=order-confirmation --format=ids') do set CONFIRM_ID=%%i
echo ✅ Order Confirmation page created
echo.

:: STEP 10: RESET MENU
echo 10. Setting up menu...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu delete $(kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu list --format=ids) 2>nul
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu create "Main Menu"
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 6
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 7
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 8
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 9
if defined CONFIRM_ID kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu %CONFIRM_ID%
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu location assign main-menu primary
echo ✅ Menu configured
echo.

:: STEP 11: CREATE SAMPLE ORDER
echo 11. Creating sample order for demo...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp wc order create \
  --status="processing" \
  --payment_method="cod" \
  --payment_method_title="Cash on Delivery" \
  --billing='{"first_name":"John","last_name":"Doe","address_1":"123 Main St","city":"New York","postcode":"10001","email":"john@example.com","phone":"555-123-4567"}' \
  --shipping='{"first_name":"John","last_name":"Doe","address_1":"123 Main St","city":"New York","postcode":"10001"}' \
  --line_items='[{"product_id":28,"quantity":2},{"product_id":29,"quantity":1}]' \
  --shipping_lines='[{"method_id":"flat_rate","method_title":"Flat Rate","total":"10.00"}]' \
  --user=admin 2>nul
echo ✅ Sample order created
echo.

:: STEP 12: CLEAR ALL CACHES
echo 12. Clearing caches...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp transient delete-all
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp cache flush
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp rewrite flush
echo ✅ Caches cleared
echo.

:: STEP 13: SHOW COMPLETION
echo ========================================
echo ✅✅ COMPLETE STORE SETUP FINISHED! ✅✅
echo ========================================
echo.
echo 📊 STORE SUMMARY:
echo ========================================
echo 🏷️  Products Added: 12 products across 5 categories
echo   - Electronics: 3 products
echo   - Clothing: 3 products
echo   - Books: 2 products
echo   - Home & Kitchen: 2 products
echo   - Sports: 2 products
echo.
echo 📄 Pages:
echo   - Shop (ID 6) - Browse products
echo   - Cart (ID 7) - Shopping cart
echo   - Checkout (ID 8) - Payment page
echo   - My Account (ID 9) - User account
echo   - Order Confirmation (ID %CONFIRM_ID%) - Thank you page
echo.
echo 💳 Payment Methods:
echo   - Cash on Delivery (Enabled)
echo   - Bank Transfer (Enabled)
echo   - Guest Checkout (Enabled)
echo.
echo 🚚 Shipping:
echo   - Flat Rate Shipping (Enabled)
echo.
echo ========================================
echo 🌐 ACCESS YOUR STORE:
echo ========================================
echo 🏠 Home:      http://localhost:9090
echo 🛍️ Shop:      http://localhost:9090/shop
echo 🛒 Cart:      http://localhost:9090/cart
echo 💳 Checkout:  http://localhost:9090/checkout
echo 👤 My Account: http://localhost:9090/my-account
echo ✅ Order Confirmation: http://localhost:9090/order-confirmation
echo 🔑 Admin:     http://localhost:9090/wp-admin
echo.
echo 👤 Admin Login:
echo   Username: admin
echo   Password: [check your terminal where store was created]
echo.
echo ========================================
echo 🎉 YOUR STORE IS READY FOR BUSINESS!
echo ========================================
pause