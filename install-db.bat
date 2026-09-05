@echo off
REM 大灣炸雞 LINE 點餐系統 - 數據庫安裝腳本 (Windows)

echo.
echo 📱 大灣炸雞 LINE 點餐系統 - 數據庫安裝
echo ======================================
echo.

REM 棄置变量
set MYSQL_USER=root
set MYSQL_PASSWORD=root
set MYSQL_HOST=localhost
set MYSQL_PORT=3306
set MYSQL_DATABASE=line_food_ordering

echo.
echo ✓ 數據庫配置
echo 主機: %MYSQL_HOST%
echo 端口: %MYSQL_PORT%
echo 用戶: %MYSQL_USER%
echo 數據庫: %MYSQL_DATABASE%

echo.
echo ✓ 正在耣接MySQL...

mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS %MYSQL_DATABASE% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

if errorlevel 1 (
    echo ❌ 耣接丢贗，請檢查MySQL是否正常運行
    pause
    exit /b 1
)

echo ✓ 數據庫已創建（或已存在）

echo.
echo ✓ 正在執行schema.sql...

mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% < src\main\resources\schema.sql

if errorlevel 1 (
    echo ❌ 执行schema.sql失敗
    pause
    exit /b 1
)

echo ✓ schema.sql執行成功

echo.
echo.
echo ✅ 數據庫安裝完成！
echo.
echo 提示：你現在可以運行應用了。
echo.
echo 運行命令: mvn spring-boot:run
echo 或: java -jar target/line-food-ordering-1.0.0.jar
echo.
pause
