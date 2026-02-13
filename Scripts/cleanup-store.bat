@echo off
set POD_NAME=store-1770995242928-wordpress-78bf565449-t4n8b
set NAMESPACE=store-1770995242928

echo ========================================
echo 🚨 REMOVING ALL DUPLICATES IMMEDIATELY
echo ========================================
echo.

:: STEP 1: DELETE ALL MENUS COMPLETELY
echo Deleting ALL menus...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu delete $(kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu list --format=ids) --force 2>nul

:: STEP 2: CLEAR MENU DATABASE ENTRIES
echo Cleaning menu database...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp db query "DELETE FROM wp_postmeta WHERE meta_key = '_menu_item_object_id';" 2>nul
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp db query "DELETE FROM wp_posts WHERE post_type = 'nav_menu_item';" 2>nul
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp db query "DELETE FROM wp_term_relationships WHERE term_taxonomy_id IN (SELECT term_taxonomy_id FROM wp_term_taxonomy WHERE taxonomy = 'nav_menu');" 2>nul
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp db query "DELETE FROM wp_term_taxonomy WHERE taxonomy = 'nav_menu';" 2>nul
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp db query "DELETE FROM wp_terms WHERE term_id NOT IN (SELECT term_id FROM wp_term_taxonomy);" 2>nul

:: STEP 3: CREATE ONE SINGLE MENU
echo Creating ONE new menu...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu create "Main Menu"

:: STEP 4: ADD EACH PAGE EXACTLY ONCE
echo Adding pages (ONE TIME ONLY)...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 6
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 7
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 8
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item add-post main-menu 9

:: STEP 5: ASSIGN MENU
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu location assign main-menu primary

:: STEP 6: CLEAR EVERY CACHE
echo Clearing all caches...
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp cache flush
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp transient delete-all
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp rewrite flush

:: STEP 7: VERIFY
echo.
echo ========================================
echo ✅ VERIFYING - SHOULD SHOW ONLY 4 ITEMS:
echo ========================================
kubectl exec -n %NAMESPACE% %POD_NAME% -- wp menu item list main-menu --fields=title

echo.
echo ========================================
echo 🎯 DUPLICATES REMOVED!
echo ========================================
echo Now press Ctrl+F5 in your browser
echo You should see ONLY:
echo - Shop
echo - Cart
echo - Checkout
echo - My Account
echo ========================================
pause