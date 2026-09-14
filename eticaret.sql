-- 1. Veritabanı Oluşturma
CREATE DATABASE IF NOT EXISTS eticaret_sistemi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eticaret_sistemi;

-- 2. Tabloların Oluşturulması

-- KATEGORİLER TABLOSU
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- KULLANICILAR TABLOSU
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ÜRÜNLER TABLOSU
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    product_name VARCHAR(200) NOT NULL,
    product_description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) 
        REFERENCES categories(category_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- SİPARİŞLER TABLOSU
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('Hazırlanıyor', 'Kargoya Verildi', 'Teslim Edildi', 'İptal Edildi') DEFAULT 'Hazırlanıyor',
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) 
        REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- SİPARİŞ DETAYLARI TABLOSU (Ara Tablo)
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_item_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. İNDEKSLERİN OLUŞTURULMASI
-- Sık aranan alanlar için indeks ekleyerek performansı artırıyoruz.

CREATE INDEX idx_product_name ON products(product_name);
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_order_date ON orders(order_date);
CREATE INDEX idx_product_category ON products(category_id);

-- 4. ÖRNEK VERİLERİN EKLEMESİ (Toplam 20+ satır)

-- Kategoriler
INSERT INTO categories (category_name, description) VALUES 
('Elektronik', 'Bilgisayar, telefon ve aksesuarlar'),
('Moda', 'Kıyafet, ayakkabı ve aksesuar'),
('Ev & Yaşam', 'Mobilya ve dekorasyon ürünleri');

-- Kullanıcılar
INSERT INTO users (first_name, last_name, email, password, address, phone) VALUES 
('Ahmet', 'Yılmaz', 'ahmet@email.com', 'hash_pw_1', 'İstanbul, Beşiktaş', '05321112233'),
('Ayşe', 'Kaya', 'ayse@email.com', 'hash_pw_2', 'Ankara, Çankaya', '05422223344'),
('Mehmet', 'Demir', 'mehmet@email.com', 'hash_pw_3', 'İzmir, Bornova', '05053334455'),
('Selin', 'Yıldız', 'selin@email.com', 'hash_pw_4', 'Bursa, Nilüfer', '05554445566'),
('Can', 'Öztürk', 'can@email.com', 'hash_pw_5', 'Antalya, Muratpaşa', '05335556677');

-- Ürünler
INSERT INTO products (category_id, product_name, product_description, price, stock_quantity) VALUES 
(1, 'Laptop Pro X', '16GB RAM, 512GB SSD', 25000.00, 10),
(1, 'Akıllı Telefon S21', '128GB Hafıza, 5G', 15000.00, 20),
(1, 'Kablosuz Kulaklık', 'Gürültü engelleme özellikli', 2000.00, 50),
(2, 'Pamuklu T-Shirt', 'Siyah, L Beden', 350.00, 100),
(2, 'Kot Pantolon', 'Mavi, 32 Beden', 850.00, 60),
(2, 'Kışlık Mont', 'Su geçirmez, Termal', 2200.00, 30),
(3, 'Ortopedik Yastık', 'Visco malzeme', 750.00, 40),
(3, 'Seramik Vazo', 'El yapımı dekoratif', 400.00, 15),
(3, 'Çalışma Masası', '120x60 cm Ahşap', 1800.00, 5),
(1, 'Gaming Mouse', '12000 DPI Optik', 1200.00, 25);

-- Siparişler
INSERT INTO orders (user_id, total_amount, status) VALUES 
(1, 27000.00, 'Teslim Edildi'),
(2, 1200.00, 'Hazırlanıyor'),
(3, 3050.00, 'Kargoya Verildi'),
(4, 400.00, 'İptal Edildi');

-- Sipariş Detayları
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 25000.00), -- Ahmet Laptop aldı
(1, 3, 1, 2000.00),   -- Ahmet Kulaklık aldı
(2, 10, 1, 1200.00),  -- Ayşe Mouse aldı
(3, 6, 1, 2200.00),   -- Mehmet Mont aldı
(3, 4, 1, 350.00),    -- Mehmet T-shirt aldı
(3, 3, 1, 500.00),    -- (Hatalı fiyat örneği veya indirimli)
(4, 8, 1, 400.00);    -- Selin Vazo aldı
