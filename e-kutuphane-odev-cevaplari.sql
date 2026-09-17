1. VIEW Çözümleri
-- BASİT: Kitap Detayları
CREATE OR REPLACE VIEW vw_kitap_detaylari AS
SELECT k.baslik, y.ad_soyad AS yazar, kat.kategori_adi
FROM kitaplar k
JOIN yazarlar y ON k.yazar_id = y.yazar_id
JOIN kategoriler kat ON k.kategori_id = kat.kategori_id;

-- ORTA: Aktif Ödünç Listesi
CREATE OR REPLACE VIEW vw_odunc_listesi AS
SELECT u.ad_soyad AS kullanici, k.baslik AS kitap, o.son_teslim_tarihi
FROM odunc_islemleri o
JOIN kullanicilar u ON o.kullanici_id = u.kullanici_id
JOIN kitap_kopyalari kk ON o.kopya_id = kk.kopya_id
JOIN kitaplar k ON kk.kitap_id = k.kitap_id
WHERE o.teslim_tarihi IS NULL;

-- ZOR: Popüler Kitaplar ve Müsaitlik Durumu
CREATE OR REPLACE VIEW vw_populer_kitaplar AS
SELECT 
    k.baslik, 
    COUNT(o.islem_id) AS toplam_odunc_sayisi,
    (SELECT COUNT(*) FROM kitap_kopyalari kk WHERE kk.kitap_id = k.kitap_id AND kk.durum = 'musait') AS musait_kopya_sayisi
FROM kitaplar k
LEFT JOIN kitap_kopyalari kk ON k.kitap_id = kk.kitap_id
LEFT JOIN odunc_islemleri o ON kk.kopya_id = o.kopya_id
GROUP BY k.kitap_id
ORDER BY toplam_odunc_sayisi DESC;
2. FUNCTION Çözümleri
DELIMITER //

-- BASİT: Gecikme Gün Sayısı Hesaplama
CREATE FUNCTION fn_gecikme_gunu(p_islem_id INT) 
RETURNS INT 
DETERMINISTIC
BEGIN
    DECLARE v_gecikme INT DEFAULT 0;
    DECLARE v_son_tarih DATE;
    DECLARE v_teslim_tarihi DATE;

    SELECT son_teslim_tarihi, teslim_tarihi INTO v_son_tarih, v_teslim_tarihi 
    FROM odunc_islemleri WHERE islem_id = p_islem_id;

    IF v_teslim_tarihi IS NULL THEN
        SET v_gecikme = DATEDIFF(CURDATE(), v_son_tarih);
    ELSE
        SET v_gecikme = DATEDIFF(v_teslim_tarihi, v_son_tarih);
    END IF;

    IF v_gecikme < 0 THEN SET v_gecikme = 0; END IF;
    RETURN v_gecikme;
END //

-- ORTA: Ceza Hesaplama (Gün başına 5 TL)
CREATE FUNCTION fn_ceza_hesapla(p_islem_id INT) 
RETURNS DECIMAL(10,2) 
DETERMINISTIC
BEGIN
    DECLARE v_gun INT;
    SET v_gun = fn_gecikme_gunu(p_islem_id);
    RETURN v_gun * 5.00;
END //

-- ZOR: Kullanıcı Durumu Belirleme
CREATE FUNCTION fn_kullanici_durumu(p_kullanici_id INT) 
RETURNS VARCHAR(20) 
DETERMINISTIC
BEGIN
    DECLARE v_gecikme_var MI;
    DECLARE v_aktif_kitap INT;

    -- Gecikmiş kitap var mı kontrolü
    SELECT COUNT(*) INTO v_gecikme_var 
    FROM odunc_islemleri 
    WHERE kullanici_id = p_kullanici_id AND (teslim_tarihi IS NULL AND CURDATE() > son_teslim_tarihi);

    -- Şu an elinde kitap var mı kontrolü
    SELECT COUNT(*) INTO v_aktif_kitap 
    FROM odunc_islemleri 
    WHERE kullanici_id = p_kullanici_id AND teslim_tarihi IS NULL;

    IF v_gecikme_var > 0 THEN 
        RETURN 'Borçlu';
    ELSEIF v_aktif_kitap > 0 THEN 
        RETURN 'Aktif';
    ELSE 
        RETURN 'Pasif';
    END IF;
END //

DELIMITER ;
3. STORED PROCEDURE Çözümleri
DELIMITER //

-- BASİT: Kitap Ekleme
CREATE PROCEDURE sp_kitap_ekle(
    IN p_baslik VARCHAR(255), 
    IN p_yazar_id INT, 
    IN p_kategori_id INT, 
    IN p_turu VARCHAR(20)
)
BEGIN
    INSERT INTO kitaplar (baslik, yazar_id, kategori_id, kitap_turu) 
    VALUES (p_baslik, p_yazar_id, p_kategori_id, p_turu);
END //

-- ORTA: Kitap Ödünç Verme (Transaction Kullanımı)
CREATE PROCEDURE sp_kitap_odunc_ver(
    IN p_kullanici_id INT, 
    IN p_kopya_id INT
)
BEGIN
    DECLARE v_durum VARCHAR(20);
    
    SELECT durum INTO v_durum FROM kitap_kopyalari WHERE kopya_id = p_kopya_id;
    
    IF v_durum = 'musait' THEN
        START TRANSACTION;
            INSERT INTO odunc_islemleri (kopya_id, kullanici_id, odunc_tarihi, son_teslim_tarihi) 
            VALUES (p_kopya_id, p_kullanici_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));
            
            UPDATE kitap_kopyalari SET durum = 'odunc_verildi' WHERE kopya_id = p_kopya_id;
        COMMIT;
        SELECT 'Kitap başarıyla ödünç verildi.' AS Mesaj;
    ELSE
        SELECT 'Hata: Kitap şu an müsait değil!' AS Mesaj;
    END IF;
END //

-- ZOR: Kitap İade Etme ve Ceza Bildirimi
CREATE PROCEDURE sp_kitap_iade_et(IN p_islem_id INT)
BEGIN
    DECLARE v_ceza DECIMAL(10,2);
    
    -- Ceza hesapla
    SET v_ceza = fn_ceza_hesapla(p_islem_id);
    
    START TRANSACTION;
        UPDATE odunc_islemleri 
        SET teslim_tarihi = CURDATE() 
        WHERE islem_id = p_islem_id;
        
        UPDATE kitap_kopyalari 
        SET durum = 'musait' 
        WHERE kopya_id = (SELECT kopya_id FROM odunc_islemleri WHERE islem_id = p_islem_id);
    COMMIT;
    
    IF v_ceza > 0 THEN
        SELECT CONCAT('Kitap iade edildi. Gecikme nedeniyle ', v_ceza, ' TL ceza uygulandı.') AS Mesaj;
    ELSE
        SELECT 'Kitap başarıyla ve zamanında iade edildi.' AS Mesaj;
    END IF;
END //

DELIMITER ;
4. TRIGGER Çözümleri
DELIMITER //

-- BASİT: Okuma Tarihini Otomatik Güncelleme
CREATE TRIGGER tr_okuma_güncelleme
BEFORE UPDATE ON okuma_ilerlemesi
FOR EACH ROW
BEGIN
    SET NEW.son_okuma_tarihi = CURRENT_TIMESTAMP;
END //

-- ORTA: Ödünç Limit Kontrolü (Max 3 Kitap)
CREATE TRIGGER tr_odunc_limit_kontrol
BEFORE INSERT ON odunc_islemleri
FOR EACH ROW
BEGIN
    DECLARE v_aktif_kitap_sayisi INT;
    
    SELECT COUNT(*) INTO v_aktif_kitap_sayisi 
    FROM odunc_islemleri 
    WHERE kullanici_id = NEW.kullanici_id AND teslim_tarihi IS NULL;
    
    IF v_aktif_kitap_sayisi >= 3 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Hata: Bir kullanıcı aynı anda en fazla 3 kitap ödünç alabilir!';
    END IF;
END //

-- ZOR: İade Edilen Kitabı Otomatik Müsait Yapma
CREATE TRIGGER tr_kopya_durum_senkronize
AFTER UPDATE ON odunc_islemleri
FOR EACH ROW
BEGIN
    -- Eğer teslim_tarihi önceden NULL idi ve şimdi doldurulduysa
    IF OLD.teslim_tarihi IS NULL AND NEW.teslim_tarihi IS NOT NULL THEN
        UPDATE kitap_kopyalari 
        SET durum = 'musait' 
        WHERE kopya_id = NEW.kopya_id;
    END IF;
END //

DELIMITER ;
Test Etmek İçin Örnek Senaryo:
Öğrencilere şu akışla test etmelerini söyleyebilirsiniz:

sp_kitap_ekle ile yeni bir kitap ekle.
sp_kitap_odunc_ver ile bir kitabı kullanıcıya ata.
tr_odunc_limit_kontrol'ü test etmek için aynı kullanıcıya 4. kitabı vermeye çalış (Hata almalısın).
fn_ceza_hesapla ile bir işlemin cezasını kontrol et.
sp_kitap_iade_et ile kitabı iade et ve tr_kopya_durum_senkronize sayesinde kitabın tekrar 'musait' olduğunu doğrula.
vw_populer_kitaplar üzerinden istatistikleri gör.