CREATE DATABASE IF NOT EXISTS `solution_b` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `solution_b`;


-- Bảng users
CREATE TABLE users (
    user_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    user_email VARCHAR(55) NOT NULL,
    user_pass VARCHAR(255) NOT NULL,
    updated_at DATETIME,
    created_at DATETIME
);

-- Bảng products
CREATE TABLE products (
    product_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_price DOUBLE NOT NULL,
    product_description TEXT NOT NULL,
    updated_at DATETIME,
    created_at DATETIME
);

-- Bảng orders
CREATE TABLE orders (
    order_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    user_id INT(11) NOT NULL,
    updated_at DATETIME,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng order_details
CREATE TABLE order_details (
    order_detail_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    order_id INT(11) NOT NULL,
    product_id INT(11) NOT NULL,
    updated_at DATETIME,
    created_at DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


USE laptrinhweb_tuan2;

-- Câu 1: Liệt kê hóa đơn (mã user, tên user, mã hóa đơn)
SELECT u.user_id, u.user_name, o.order_id FROM users u JOIN orders o ON u.user_id = o.user_id;

-- Câu 2: Số lượng hóa đơn mỗi khách hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_don_hang FROM users u LEFT JOIN orders o ON u.user_id = o.user_id GROUP BY u.user_id;

-- Câu 3: Thông tin hóa đơn (mã đơn hàng, số sản phẩm)
SELECT order_id, COUNT(product_id) AS so_san_pham FROM order_details GROUP BY order_id;

-- Câu 4: Thông tin mua hàng (Gom nhóm theo đơn hàng)
SELECT u.user_id, u.user_name, o.order_id, p.product_name FROM users u 
JOIN orders o ON u.user_id = o.user_id 
JOIN order_details od ON o.order_id = od.order_id 
JOIN products p ON od.product_id = p.product_id 
ORDER BY o.order_id;

-- Câu 5: 7 người dùng có nhiều đơn hàng nhất
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_luong FROM users u 
JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id ORDER BY so_luong DESC LIMIT 7;

-- Câu 6: 7 người mua sản phẩm Samsung hoặc Apple
SELECT DISTINCT u.user_id, u.user_name, o.order_id, p.product_name FROM users u 
JOIN orders o ON u.user_id = o.user_id 
JOIN order_details od ON o.order_id = od.order_id 
JOIN products p ON od.product_id = p.product_id 
WHERE p.product_name LIKE '%Samsung%' OR p.product_name LIKE '%Apple%' LIMIT 7;

-- Câu 7: Tổng tiền mỗi đơn hàng
SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien FROM users u 
JOIN orders o ON u.user_id = o.user_id 
JOIN order_details od ON o.order_id = od.order_id 
JOIN products p ON od.product_id = p.product_id 
GROUP BY o.order_id;

-- Câu 8: Mỗi user lấy 1 đơn hàng có tổng tiền lớn nhất
SELECT *
FROM (
    SELECT 
        u.id AS user_id,
        u.name,
        o.id AS order_id,
        SUM(oi.quantity * oi.price) AS total_price,
        ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY SUM(oi.quantity * oi.price) DESC) AS rn
    FROM users u
    JOIN orders o ON u.id = o.user_id
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY u.id, o.id
) t
WHERE rn = 1;

-- Câu 9: Mỗi user lấy đơn hàng có tổng tiền nhỏ nhất (+ số sản phẩm)
SELECT *
FROM (
    SELECT 
        u.id AS user_id,
        u.name,
        o.id AS order_id,
        SUM(oi.quantity * oi.price) AS total_price,
        SUM(oi.quantity) AS total_products,
        ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY SUM(oi.quantity * oi.price) ASC) AS rn
    FROM users u
    JOIN orders o ON u.id = o.user_id
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY u.id, o.id
) t
WHERE rn = 1;

-- Câu 10: Mỗi user lấy đơn hàng có số sản phẩm nhiều nhất
SELECT *
FROM (
    SELECT 
        u.id AS user_id,
        u.name,
        o.id AS order_id,
        SUM(oi.quantity * oi.price) AS total_price,
        SUM(oi.quantity) AS total_products,
        ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY SUM(oi.quantity) DESC) AS rn
    FROM users u
    JOIN orders o ON u.id = o.user_id
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY u.id, o.id
) t
WHERE rn = 1;