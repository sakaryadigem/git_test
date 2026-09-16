-- Veritabanı Oluşturma
CREATE DATABASE IF NOT EXISTS e_kutuphane_sistemi CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;
USE e_kutuphane_sistemi;

-- 1. Kategoriler Tablosu
CREATE TABLE kategoriler (
    kategori_id INT AUTO_INCREMENT PRIMARY KEY,
    kategori_adi VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 2. Yazarlar Tablosu
CREATE TABLE yazarlar (
    yazar_id INT AUTO_INCREMENT PRIMARY KEY,
    ad_soyad VARCHAR(150) NOT NULL,
    biyografi TEXT,
    dogum_tarihi DATE
) ENGINE=InnoDB;

-- 3. Kullanıcılar Tablosu
CREATE TABLE kullanicilar (
    kullanici_id INT AUTO_INCREMENT PRIMARY KEY,
    ad_soyad VARCHAR(150) NOT NULL,
    eposta VARCHAR(100) NOT NULL UNIQUE,
    sifre VARCHAR(255) NOT NULL,
    rol ENUM('uye', 'admin') DEFAULT 'uye',
    kayit_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_eposta (eposta)
) ENGINE=InnoDB;

-- 4. Kitaplar Tablosu (Genel Kitap Bilgisi)
CREATE TABLE kitaplar (
    kitap_id INT AUTO_INCREMENT PRIMARY KEY,
    baslik VARCHAR(255) NOT NULL,
    yazar_id INT,
    kategori_id INT,
    isbn VARCHAR(20) UNIQUE,
    yayin_yili INT,
    aciklama TEXT,
    kitap_turu ENUM('fiziksel', 'e-kitap', 'her_ikisi') DEFAULT 'fiziksel',
    dosya_yolu VARCHAR(255), -- E-kitap ise PDF/EPUB yolu
    INDEX idx_baslik (baslik),
    CONSTRAINT fk_kitap_yazar FOREIGN KEY (yazar_id) REFERENCES yazarlar(yazar_id) ON DELETE SET NULL,
    CONSTRAINT fk_kitap_kategori FOREIGN KEY (kategori_id) REFERENCES kategoriler(kategori_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 5. Kitap Kopyaları Tablosu (Fiziksel kitaplar için)
CREATE TABLE kitap_kopyalari (
    kopya_id INT AUTO_INCREMENT PRIMARY KEY,
    kitap_id INT NOT NULL,
    barkod VARCHAR(50) UNIQUE NOT NULL,
    durum ENUM('musait', 'odunc_verildi', 'kayip', 'bakimda') DEFAULT 'musait',
    CONSTRAINT fk_kopya_kitap FOREIGN KEY (kitap_id) REFERENCES kitaplar(kitap_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Ödünç İşlemleri Tablosu (Fiziksel kitaplar için)
CREATE TABLE odunc_islemleri (
    islem_id INT AUTO_INCREMENT PRIMARY KEY,
    kopya_id INT NOT NULL,
    kullanici_id INT NOT NULL,
    odunc_tarihi DATE NOT NULL,
    teslim_tarihi DATE,
    son_teslim_tarihi DATE NOT NULL,
    geciken_gun INT DEFAULT 0,
    CONSTRAINT fk_odunc_kopya FOREIGN KEY (kopya_id) REFERENCES kitap_kopyalari(kopya_id),
    CONSTRAINT fk_odunc_kullanici FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(kullanici_id),
    INDEX idx_odunc_tarihi (odunc_tarihi)
) ENGINE=InnoDB;

-- 7. Okuma İlerlemesi Tablosu (E-kitaplar için)
CREATE TABLE okuma_ilerlemesi (
    ilerleme_id INT AUTO_INCREMENT PRIMARY KEY,
    kullanici_id INT NOT NULL,
    kitap_id INT NOT NULL,
    son_sayfa INT DEFAULT 0,
    okuma_yuzdesi DECIMAL(5,2) DEFAULT 0.00,
    son_okuma_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_ilerleme_kullanici FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(kullanici_id) ON DELETE CASCADE,
    CONSTRAINT fk_ilerleme_kitap FOREIGN KEY (kitap_id) REFERENCES kitaplar(kitap_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_book (kullanici_id, kitap_id) -- Bir kullanıcı bir kitaba tek bir ilerleme kaydı tutar
) ENGINE=InnoDB;

-- ==========================================================
-- ÖRNEK VERİLER (En az 20 satır)
-- ==========================================================

-- Kategoriler (5 satır)
INSERT INTO kategoriler (kategori_adi) VALUES 
('Roman'), ('Bilim Kurgu'), ('Tarih'), ('Felsefe'), ('Yazılım');

-- Yazarlar (5 satır)
INSERT INTO yazarlar (ad_soyad, biyografi, dogum_tarihi) VALUES 
('Sabahattin Ali', 'Türk yazar ve şair.', '1907-01-01'),
('George Orwell', 'İngiliz romancı ve gazeteci.', '1903-06-25'),
('Isaac Asimov', 'Amerikalı bilim kurgu yazarı.', '1920-01-02'),
('Platon', 'Antik Yunan filozofu.', '-0427-01-01'),
('Robert C. Martin', 'Yazılım mimarı ve yazarı.', '1952-01-01');

-- Kullanıcılar (5 satır)
INSERT INTO kullanicilar (ad_soyad, eposta, sifre, rol) VALUES 
('Admin Ahmet', 'admin@kutuphane.com', 'hash_sifre1', 'admin'),
('Can Yılmaz', 'can@email.com', 'hash_sifre2', 'uye'),
('Ayşe Demir', 'ayse@email.com', 'hash_sifre3', 'uye'),
('Mehmet Kaya', 'mehmet@email.com', 'hash_sifre4', 'uye'),
('Zeynep Arslan', 'zeynep@email.com', 'hash_sifre5', 'uye');

-- Kitaplar (8 satır)
INSERT INTO kitaplar (baslik, yazar_id, kategori_id, isbn, yayin_yili, kitap_turu, dosya_yolu) VALUES 
('Kürk Mantolu Madonna', 1, 1, '978-123-01', 1943, 'her_ikisi', 'pdfs/kurk_mantolu.pdf'),
('1984', 2, 2, '978-123-02', 1949, 'her_ikisi', 'pdfs/1984.pdf'),
('Vakıf', 3, 2, '978-123-03', 1951, 'fiziksel', NULL),
('Devlet', 4, 4, '978-123-04', -380, 'e-kitap', 'pdfs/devlet.pdf'),
('Clean Code', 5, 5, '978-123-05', 2008, 'her_ikisi', 'pdfs/clean_code.pdf'),
('İçimizdeki Şeytan', 1, 1, '978-123-06', 1940, 'fiziksel', NULL),
('Hayvan Çiftliği', 2, 2, '978-123-07', 1945, 'e-kitap', 'pdfs/hayvan_ciftligi.pdf'),
('Sapiens', NULL, 3, '978-123-08', 2011, 'fiziksel', NULL);

-- Kitap Kopyaları (10 satır)
INSERT INTO kitap_kopyalari (kitap_id, barkod, durum) VALUES 
(1, 'B001', 'musait'), (1, 'B002', 'odunc_verildi'),
(2, 'B003', 'musait'), (2, 'B004', 'odunc_verildi'),
(3, 'B005', 'musait'), (3, 'B006', 'musait'),
(5, 'B007', 'musait'), (5, 'B008', 'odunc_verildi'),
(6, 'B009', 'musait'), (8, 'B010', 'musait');

-- Ödünç İşlemleri (5 satır)
INSERT INTO odunc_islemleri (kopya_id, kullanici_id, odunc_tarihi, son_teslim_tarihi, teslim_tarihi) VALUES 
(2, 2, '2023-10-01', '2023-10-15', '2023-10-14'),
(4, 3, '2023-11-01', '2023-11-15', NULL), -- Hala ödünçte
(8, 4, '2023-11-05', '2023-11-19', NULL), -- Hala ödünçte
(2, 5, '2023-10-20', '2023-11-03', '2023-11-05'), -- Geç teslim edilmiş
(4, 2, '2023-11-20', '2023-12-04', NULL);

-- Okuma İlerlemesi (5 satır)
INSERT INTO okuma_ilerlemesi (kullanici_id, kitap_id, son_sayfa, okuma_yuzdesi) VALUES 
(2, 1, 45, 22.5),
(3, 2, 120, 60.0),
(4, 4, 12, 5.0),
(5, 5, 210, 85.0),
(2, 7, 30, 15.0);
