#!/bin/bash
# 大灣炸雞 LINE 點餐系統 - 數據庫安裝腳本

echo "📱 大灣炸雞 LINE 點餐系統 - 數據庫安裝"
echo "======================================"

# 棄置变量
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-root}
MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_PORT=${MYSQL_PORT:-3306}
MYSQL_DATABASE="line_food_ordering"

echo "\n✓ 數據庫配置"
echo "主機: $MYSQL_HOST"
echo "端口: $MYSQL_PORT"
echo "用戶: $MYSQL_USER"
echo "數據庫: $MYSQL_DATABASE"

echo "\n✓ 正在耣接MySQL..."

mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "❌ 耣接丢贗，請檢查MySQL是否正常運行"
    echo "提示：需要提供正確的用戶名、密碼、主機和端口"
    exit 1
fi

echo "✓ 數據庫已創建（或已存在）"

echo "\n✓ 正在執行schema.sql..."

mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < src/main/resources/schema.sql 2>/dev/null

if [ $? -ne 0 ]; then
    echo "❌ 执行schema.sql失敗"
    exit 1
fi

echo "✓ schema.sql執行成功"

echo "\n✓ 正在插入菜單數據..."

mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE << 'EOF' 2>/dev/null
-- 插入菜單分類
INSERT IGNORE INTO menu_categories (category_name, display_order, is_active) VALUES 
('招牌雞排·特色主餐', 1, TRUE),
('超值套餐·家家分享', 2, TRUE),
('單點炸雞、炸物', 3, TRUE),
('小物', 4, TRUE),
('飲料', 5, TRUE);

-- 插入招牌雞排菜單項目
INSERT IGNORE INTO menu_items (category_id, item_name, price, description, has_size, is_active, display_order) VALUES 
(1, '起司雞排', 100, '新鮮起司雞排，起司牽絲好吃', FALSE, TRUE, 1),
(1, '脆皮雞排', 75, '香脆多汁的脆皮雞排', FALSE, TRUE, 2),
(1, '古早味香雞排', 75, '傳統古早味香雞排', FALSE, TRUE, 3),
(1, '脆皮大雞腿', 65, '現炸20分鐘新鮮大雞腿', FALSE, TRUE, 4),
(1, '紹漢無骨雞腿排', 85, '紹漢無骨雞腿排', FALSE, TRUE, 5);

-- 插入單點炸物（含大小份）
INSERT IGNORE INTO menu_items (category_id, item_name, price, description, has_size, size_small_price, size_large_price, is_active, display_order) VALUES 
(3, '雞腿', 45, '新鮮雞腿', TRUE, 45, NULL, TRUE, 1),
(3, '雞塊', 40, '香脆雞塊', TRUE, 40, NULL, TRUE, 2),
(3, '雞翅', 30, '多汁雞翅', TRUE, 30, NULL, TRUE, 3),
(3, '無骨腿肉', 45, '嫩滑無骨腿肉', TRUE, 45, NULL, TRUE, 4);

-- 插入小物
INSERT IGNORE INTO menu_items (category_id, item_name, price, description, has_size, size_small_price, size_large_price, is_active, display_order) VALUES 
(4, '招牌肋骨', 60, '招牌肋骨', TRUE, 60, 110, TRUE, 1),
(4, '甘梅地瓜', 30, '甘梅地瓜', TRUE, 30, 50, TRUE, 2),
(4, '香鹹菇', 30, '香鹹菇', TRUE, 30, 50, TRUE, 3);

-- 插入飲料
INSERT IGNORE INTO menu_items (category_id, item_name, price, description, has_size, is_active, display_order) VALUES 
(5, '可樂', 25, '冰涼可樂', FALSE, TRUE, 1),
(5, '雪碧', 25, '清爽雪碧', FALSE, TRUE, 2),
(5, '蒲果汁', 25, '新鮮蒲果汁', FALSE, TRUE, 3);

-- 插入套餐
INSERT IGNORE INTO combo_meals (category_id, combo_name, base_price, description, is_active, display_order) VALUES 
(2, '1號餐', 70, '麥克小雞塊+雞塊1', TRUE, 1),
(2, '2號餐', 100, '雞腿1+雞塊1+25元炸物1份', TRUE, 2),
(2, '3號餐', 150, '雞塊3+25元炸物2份', TRUE, 3),
(2, '4號餐', 220, '雞塊4+25元炸物2份', TRUE, 4),
(2, '全家餐', 290, '雞塊2+雞塊2+雞翅2+25元炸物3份', TRUE, 5);
EOF

if [ $? -ne 0 ]; then
    echo "❌ 插入菜單數據失敗"
    exit 1
fi

echo "✓ 菜單數據插入成功"

echo "\n✅ 數據庫安裝完成！"
echo "提示：你現在可以運行應用了。"
echo "
運行命令: mvn spring-boot:run
或: java -jar target/line-food-ordering-1.0.0.jar
"
