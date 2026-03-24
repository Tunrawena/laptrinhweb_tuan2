CREATE DATABASE IF NOT EXISTS `solution_a` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `solution_a`;

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

-- Câu 1: Danh sách người dùng theo Alphabet (A->Z)
SELECT * FROM users ORDER BY user_name ASC;

-- Câu 2: Lấy ra 07 người dùng đầu tiên (A->Z)
SELECT * FROM users ORDER BY user_name ASC LIMIT 7;

-- Câu 3: Tên người dùng có chữ 'a' (A->Z)
SELECT * FROM users WHERE user_name LIKE '%a%' ORDER BY user_name ASC;

-- Câu 4: Tên bắt đầu bằng chữ 'm'
SELECT * FROM users WHERE user_name LIKE 'm%';

-- Câu 5: Tên kết thúc bằng chữ 'i'
SELECT * FROM users WHERE user_name LIKE '%i';

-- Câu 6: Email là Gmail
SELECT * FROM users WHERE user_email LIKE '%@gmail.com';

-- Câu 7: Email Gmail và tên bắt đầu bằng 'm'
SELECT * FROM users WHERE user_email LIKE '%@gmail.com' AND user_name LIKE 'm%';

-- Câu 8: Email Gmail, tên có chữ 'i' và dài > 5
SELECT * FROM users WHERE user_email LIKE '%@gmail.com' AND user_name LIKE '%i%' AND LENGTH(user_name) > 5;

-- Câu 9: Tên có 'a', dài 5-9, Gmail và tên email có chữ 'i'
SELECT * FROM users WHERE user_name LIKE '%a%' AND LENGTH(user_name) BETWEEN 5 AND 9 AND user_email LIKE '%i%@gmail.com';

-- Câu 10: Điều kiện phức hợp (Sử dụng OR)
SELECT * FROM users WHERE (user_name LIKE '%a%' AND LENGTH(user_name) BETWEEN 5 AND 9) 
OR (user_name LIKE '%i%' AND LENGTH(user_name) < 9) 
OR (user_email LIKE '%i%@gmail.com');