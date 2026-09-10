-- Toplu Ulaşım Yönetim Sistemi - Örnek Select Sorguları

-- ========================================
-- 1. TEMEL SORGULAR
-- ========================================

-- 1.1 Tüm aktif hatları listele
SELECT hat_id, hat_kodu, hat_adi, hat_turu 
FROM hatlar 
WHERE aktif = TRUE 
ORDER BY hat_kodu;

-- 1.2 Belirli bir hattın güzergahını sıralı olarak
-- listele (H-101)
SELECT 
    h.hat_kodu,
    h.hat_adi,
    d.durak_adi,
    g.sira_no,
    g.yon,
    g.onceki_durak_mesafe,
    g.tahmini_varis_suresi
FROM guzergahlar g
INNER JOIN hatlar h ON g.hat_id = h.hat_id
INNER JOIN duraklar d ON g.durak_id = d.durak_id
WHERE h.hat_kodu = 'H-101'
ORDER BY g.yon, g.sira_no;

-- 1.3 Bir hattın günlük çalışma saatlerini listele (H-101)
SELECT 
    h.hat_kodu,
    gt.gun_tipi_adi,
    hs.saat_araligi,
    hs.baslangic_saati,
    hs.bitis_saati,
    hs.sefer_araligi,
    hs.calisma_durumu
FROM hat_saatleri hs
INNER JOIN hatlar h ON hs.hat_id = h.hat_id
INNER JOIN gun_tipleri gt ON hs.gun_tipi_id = gt.gun_tipi_id
WHERE h.hat_kodu = 'H-101'
ORDER BY gt.gun_tipi_id, hs.baslangic_saati;

-- ========================================
-- 2. OTOBÜS VE SÜRÜCÜ SORGULARI
-- ========================================

-- 2.1 Tüm otobüsleri durumlarına göre listele
SELECT 
    plaka,
    marka,
    model,
    yil,
    kapasite,
    yakit_turu,
    durum,
    kilometre,
    son_bakim_tarihi
FROM otobusler
ORDER BY durum, plaka;

-- 2.2 Aktif sürücüleri listele
SELECT 
    ad,
    soyad,
    tc_kimlik,
    telefon,
    email,
    ise_baslama_tarihi,
    durum
FROM suruculer
WHERE durum = 'aktif'
ORDER BY soyad, ad;

-- 2.3 Bakımdaki otobüsler ve bakım detayları
SELECT 
    o.plaka,
    o.marka,
    o.model,
    bk.baslangic_tarihi,
    bk.bitis_tarihi,
    bk.bakim_turu,
    bk.aciklama,
    bk.maliyet
FROM otobusler o
INNER JOIN bakim_kayitlari bk ON o.otobus_id = bk.otobus_id
WHERE o.durum = 'bakimda'
ORDER BY bk.baslangic_tarihi DESC
;

-- ========================================
-- 3. ÇALIŞMA PLANI SORGULARI
-- ========================================

-- 3.1 Belirli bir tarihteki tüm çalışma planlarını listele
SELECT 
    h.hat_kodu,
    h.hat_adi,
    o.plaka,
    CONCAT(s.ad, ' ', s.soyad) AS surucu_adi,
    cp.baslangic_saati,
    cp.bitis_saati,
    cp.vardiya_turu,
    cp.durum
FROM calisma_planlari cp
INNER JOIN hatlar h ON cp.hat_id = h.hat_id
INNER JOIN otobusler o ON cp.otobus_id = o.otobus_id
INNER JOIN suruculer s ON cp.surucu_id = s.surucu_id
WHERE cp.calisma_tarihi = '2026-09-09'
ORDER BY cp.baslangic_saati;

-- 3.2 Sürücü bazında haftalık plan (örnek sürücü: Mehmet Yılmaz)
SELECT 
    cp.calisma_tarihi,
    h.hat_kodu,
    o.plaka,
    cp.baslangic_saati,
    cp.bitis_saati,
    cp.vardiya_turu,
    cp.durum
FROM calisma_planlari cp
INNER JOIN suruculer s ON cp.surucu_id = s.surucu_id
INNER JOIN hatlar h ON cp.hat_id = h.hat_id
INNER JOIN otobusler o ON cp.otobus_id = o.otobus_id
WHERE s.ad = 'Mehmet' AND s.soyad = 'Yılmaz'
AND cp.calisma_tarihi BETWEEN '2026-09-07' AND '2026-09-13'
ORDER BY cp.calisma_tarihi, cp.baslangic_saati;

-- 3.3 Otobüs bazında kullanım durumu
SELECT 
    o.plaka,
    COUNT(cp.calisma_plani_id) AS toplam_vardiya,
    DATE(cp.calisma_tarihi) AS tarih
FROM otobusler o
LEFT JOIN calisma_planlari cp ON o.otobus_id = cp.otobus_id
WHERE cp.calisma_tarihi BETWEEN '2026-09-01' AND '2026-09-10'
GROUP BY o.otobus_id, DATE(cp.calisma_tarihi)
ORDER BY o.plaka, tarih;

-- ========================================
-- 4. SEFER ANALİZ SORGULARI
-- ========================================

-- 4.1 Belirli bir gündeki seferleri listele
SELECT 
    s.sefer_id,
    h.hat_kodu,
    d1.durak_adi AS baslangic_duraki,
    d2.durak_adi AS bitis_duraki,
    s.baslangic_zamani,
    s.bitis_zamani,
    s.yolcu_sayisi,
    s.gecikme_dakika,
    s.durum
FROM seferler s
INNER JOIN calisma_planlari cp ON s.calisma_plani_id = cp.calisma_plani_id
INNER JOIN hatlar h ON cp.hat_id = h.hat_id
INNER JOIN duraklar d1 ON s.baslangic_durak_id = d1.durak_id
INNER JOIN duraklar d2 ON s.bitis_durak_id = d2.durak_id
WHERE DATE(s.baslangic_zamani) = '2026-09-09'
ORDER BY s.baslangic_zamani;

-- 4.2 En çok yolcu taşıyan seferler
SELECT 
    h.hat_kodu,
    d1.durak_adi AS baslangic_duraki,
    d2.durak_adi AS bitis_duraki,
    s.baslangic_zamani,
    s.yolcu_sayisi,
    s.gecikme_dakika
FROM seferler s
INNER JOIN calisma_planlari cp ON s.calisma_plani_id = cp.calisma_plani_id
INNER JOIN hatlar h ON cp.hat_id = h.hat_id
INNER JOIN duraklar d1 ON s.baslangic_durak_id = d1.durak_id
INNER JOIN duraklar d2 ON s.bitis_durak_id = d2.durak_id
ORDER BY s.yolcu_sayisi DESC
LIMIT 10;

-- 4.3 Ortalama gecikme analizi (hat bazında)
SELECT 
    h.hat_kodu,
    h.hat_adi,
    COUNT(s.sefer_id) AS sefer_sayisi,
    AVG(s.yolcu_sayisi) AS ortalama_yolcu,
    AVG(s.gecikme_dakika) AS ortalama_gecikme,
    MAX(s.gecikme_dakika) AS max_gecikme,
    MIN(s.gecikme_dakika) AS min_gecikme
FROM seferler s
INNER JOIN calisma_planlari cp ON s.calisma_plani_id = cp.calisma_plani_id
INNER JOIN hatlar h ON cp.hat_id = h.hat_id
WHERE s.durum = 'tamamlandi'
GROUP BY h.hat_id
ORDER BY ortalama_gecikme DESC;

-- ========================================
-- 5. DURAK ANALİZ SORGULARI
-- ========================================

-- 5.1 En çok kullanılan duraklar (iniş-biniş istatistikleri)
SELECT 
    d.durak_adi,
    COUNT(dg.gecis_id) AS toplam_gecis,
    SUM(dg.inen_yolcu) AS toplam_inen,
    SUM(dg.binen_yolcu) AS toplam_binen,
    SUM(dg.inen_yolcu + dg.binen_yolcu) AS toplam_yolcu_trafigi
FROM durak_gecisleri dg
INNER JOIN duraklar d ON dg.durak_id = d.durak_id
GROUP BY d.durak_id
ORDER BY toplam_yolcu_trafigi DESC
LIMIT 10;

-- 5.2 Durak bazında ortalama bekleme süresi analizi
SELECT 
    d.durak_adi,
    AVG(TIMESTAMPDIFF(MINUTE, dg.varis_zamani, dg.kalkis_zamani)) AS ortalama_bekleme_suresi,
    COUNT(dg.gecis_id) AS geciş_sayisi
FROM durak_gecisleri dg
INNER JOIN duraklar d ON dg.durak_id = d.durak_id
WHERE dg.kalkis_zamani IS NOT NULL
GROUP BY d.durak_id
HAVING COUNT(dg.gecis_id) > 5
ORDER BY ortalama_bekleme_suresi DESC;

-- ========================================
-- 6. PERFORMANS VE RAPORLAMA SORGULARI
-- ========================================

-- 6.1 Hat performans raporu (günlük)
SELECT 
    h.hat_kodu,
    h.hat_adi,
    DATE(s.baslangic_zamani) AS tarih,
    COUNT(s.sefer_id) AS sefer_sayisi,
    AVG(s.yolcu_sayisi) AS ortalama_yolcu,
    SUM(s.yolcu_sayisi) AS toplam_yolcu,
    AVG(s.gecikme_dakika) AS ortalama_gecikme,
    SUM(CASE WHEN s.durum = 'tamamlandi' THEN 1 ELSE 0 END) AS tamamlanan_sefer,
    SUM(CASE WHEN s.durum = 'iptal' THEN 1 ELSE 0 END) AS iptal_edilen_sefer
FROM seferler s
INNER JOIN calisma_planlari cp ON s.calisma_plani_id = cp.calisma_plani_id
INNER JOIN hatlar h ON cp.hat_id = h.hat_id
WHERE s.durum IN ('tamamlandi', 'iptal')
GROUP BY h.hat_id, DATE(s.baslangic_zamani)
ORDER BY tarih DESC, toplam_yolcu DESC;

-- 6.2 Sürücü performans raporu
SELECT 
    CONCAT(s.ad, ' ', s.soyad) AS surucu_adi,
    s.tc_kimlik,
    COUNT(cp.calisma_plani_id) AS toplam_vardiya,
    COUNT(DISTINCT DATE(cp.calisma_tarihi)) AS calisilan_gun,
    COUNT(sf.sefer_id) AS toplam_sefer,
    AVG(sf.yolcu_sayisi) AS ortalama_yolcu,
    AVG(sf.gecikme_dakika) AS ortalama_gecikme
FROM suruculer s
LEFT JOIN calisma_planlari cp ON s.surucu_id = cp.surucu_id
LEFT JOIN seferler sf ON cp.calisma_plani_id = sf.calisma_plani_id
WHERE s.durum = 'aktif'
GROUP BY s.surucu_id
ORDER BY toplam_sefer DESC;

-- 6.3 Otobüs performans ve bakım raporu
SELECT 
    o.plaka,
    o.marka,
    o.model,
    o.kapasite,
    o.kilometre,
    COUNT(DISTINCT cp.calisma_plani_id) AS toplam_vardiya,
    COUNT(sf.sefer_id) AS toplam_sefer,
    AVG(sf.yolcu_sayisi) AS ortalama_yolcu,
    COUNT(bk.bakim_id) AS bakim_sayisi,
    SUM(bk.maliyet) AS toplam_bakim_maliyeti
FROM otobusler o
LEFT JOIN calisma_planlari cp ON o.otobus_id = cp.otobus_id
LEFT JOIN seferler sf ON cp.calisma_plani_id = sf.calisma_plani_id
LEFT JOIN bakim_kayitlari bk ON o.otobus_id = bk.otobus_id
GROUP BY o.otobus_id
ORDER BY toplam_sefer DESC;

-- ========================================
-- 7. ZAMANSAL ANALİZ SORGULARI
-- ========================================

-- 7.1 Saat bazında yolcu yoğunluğu analizi
SELECT 
    HOUR(s.baslangic_zamani) AS saat,
    COUNT(s.sefer_id) AS sefer_sayisi,
    AVG(s.yolcu_sayisi) AS ortalama_yolcu,
    SUM(s.yolcu_sayisi) AS toplam_yolcu
FROM seferler s
WHERE s.durum = 'tamamlandi'
GROUP BY HOUR(s.baslangic_zamani)
ORDER BY saat;

-- 7.2 Gün tipine göre sefer istatistikleri
SELECT 
    gt.gun_tipi_adi,
    COUNT(s.sefer_id) AS sefer_sayisi,
    AVG(s.yolcu_sayisi) AS ortalama_yolcu,
    SUM(s.yolcu_sayisi) AS toplam_yolcu,
    AVG(s.gecikme_dakika) AS ortalama_gecikme
FROM seferler s
INNER JOIN calisma_planlari cp ON s.calisma_plani_id = cp.calisma_plani_id
INNER JOIN gun_tipleri gt ON cp.gun_tipi_id = gt.gun_tipi_id
WHERE s.durum = 'tamamlandi'
GROUP BY gt.gun_tipi_id
ORDER BY gt.gun_tipi_id;

-- ========================================
-- 8. KARMAŞIK ANALİZ SORGULARI
-- ========================================

-- 8.1 Hattın en yoğun durakları (H-101 için)
WITH hat_seferleri AS (
    SELECT 
        cp.hat_id,
        sf.sefer_id
    FROM calisma_planlari cp
    INNER JOIN seferler sf ON cp.calisma_plani_id = sf.calisma_plani_id
    WHERE cp.hat_id = 1 AND sf.durum = 'tamamlandi'
)
SELECT 
    d.durak_adi,
    COUNT(dg.gecis_id) AS geciş_sayisi,
    SUM(dg.inen_yolcu) AS toplam_inen,
    SUM(dg.binen_yolcu) AS toplam_binen,
    AVG(dg.inen_yolcu + dg.binen_yolcu) AS ortalama_trafik
FROM hat_seferleri hs
INNER JOIN durak_gecisleri dg ON hs.sefer_id = dg.sefer_id
INNER JOIN duraklar d ON dg.durak_id = d.durak_id
GROUP BY d.durak_id
ORDER BY toplam_binen DESC;

-- 8.2 Vardiya bazında performans karşılaştırması
SELECT 
    cp.vardiya_turu,
    COUNT(sf.sefer_id) AS sefer_sayisi,
    AVG(sf.yolcu_sayisi) AS ortalama_yolcu,
    AVG(sf.gecikme_dakika) AS ortalama_gecikme,
    AVG(TIMESTAMPDIFF(MINUTE, sf.baslangic_zamani, sf.bitis_zamani)) AS ortalama_sefer_suresi
FROM seferler sf
INNER JOIN calisma_planlari cp ON sf.calisma_plani_id = cp.calisma_plani_id
WHERE sf.durum = 'tamamlandi'
GROUP BY cp.vardiya_turu
ORDER BY ortalama_yolcu DESC;

-- 8.3 Günlük kapasite kullanım analizi
SELECT 
    DATE(sf.baslangic_zamani) AS tarih,
    COUNT(sf.sefer_id) AS sefer_sayisi,
    AVG(sf.yolcu_sayisi) AS ortalama_yolcu,
    MAX(sf.yolcu_sayisi) AS max_yolcu,
    AVG(sf.yolcu_sayisi / o.kapasite * 100) AS ortalama_doluluk_orani,
    SUM(CASE WHEN sf.yolcu_sayisi > o.kapasite * 0.8 THEN 1 ELSE 0 END) AS yogun_sefer_sayisi
FROM seferler sf
INNER JOIN calisma_planlari cp ON sf.calisma_plani_id = cp.calisma_plani_id
INNER JOIN otobusler o ON cp.otobus_id = o.otobus_id
WHERE sf.durum = 'tamamlandi'
GROUP BY DATE(sf.baslangic_zamani)
ORDER BY tarih DESC;

-- 8.4 Bakım maliyet analizi (otobüs başına)
SELECT 
    o.plaka,
    o.marka,
    o.model,
    o.kilometre,
    COUNT(bk.bakim_id) AS bakim_sayisi,
    ROUND(SUM(bk.maliyet), 2) AS toplam_bakim_maliyeti,
    ROUND(AVG(bk.maliyet), 2) AS ortalama_bakim_maliyeti,
    ROUND(SUM(bk.maliyet) / NULLIF(o.kilometre, 0) * 1000, 2) AS maliyet_bin_km_basi
FROM otobusler o
LEFT JOIN bakim_kayitlari bk ON o.otobus_id = bk.otobus_id
WHERE bk.bakim_id IS NOT NULL
GROUP BY o.otobus_id
ORDER BY toplam_bakim_maliyeti DESC;

-- ========================================
-- 9. SUBQUERY VE CTE KULLANIMI
-- ========================================

-- 9.1 En iyi ve en kötü performans gösteren hatlar
WITH hat_performans AS (
    SELECT 
        h.hat_id,
        h.hat_kodu,
        h.hat_adi,
        COUNT(sf.sefer_id) AS sefer_sayisi,
        AVG(sf.yolcu_sayisi) AS ortalama_yolcu,
        AVG(sf.gecikme_dakika) AS ortalama_gecikme
    FROM hatlar h
    INNER JOIN calisma_planlari cp ON h.hat_id = cp.hat_id
    INNER JOIN seferler sf ON cp.calisma_plani_id = sf.calisma_plani_id
    WHERE sf.durum = 'tamamlandi'
    GROUP BY h.hat_id
)
SELECT 
    hat_kodu,
    hat_adi,
    sefer_sayisi,
    ROUND(ortalama_yolcu, 2) AS ortalama_yolcu,
    ROUND(ortalama_gecikme, 2) AS ortalama_gecikme,
    CASE 
        WHEN ortalama_yolcu > (SELECT AVG(ortalama_yolcu) FROM hat_performans) 
        THEN 'Yüksek Performans'
        ELSE 'Düşük Performans'
    END AS performans_durumu
FROM hat_performans
ORDER BY ortalama_yolcu DESC;

-- 9.2 En yoğun saat aralıkları
WITH saat_dilimi AS (
    SELECT 
        HOUR(sf.baslangic_zamani) AS saat,
        COUNT(sf.sefer_id) AS sefer_sayisi,
        SUM(sf.yolcu_sayisi) AS toplam_yolcu,
        AVG(sf.yolcu_sayisi) AS ortalama_yolcu
    FROM seferler sf
    WHERE sf.durum = 'tamamlandi'
    GROUP BY HOUR(sf.baslangic_zamani)
)
SELECT 
    saat,
    sefer_sayisi,
    toplam_yolcu,
    ROUND(ortalama_yolcu, 2) AS ortalama_yolcu,
    ROUND(100.0 * toplam_yolcu / SUM(toplam_yolcu) OVER (), 2) AS yolcu_yuzdesi
FROM saat_dilimi
ORDER BY toplam_yolcu DESC
LIMIT 5;

-- ========================================
-- 10. İZLEME VE DENETİM SORGULARI
-- ========================================

-- 10.1 Hangi otobüslerin son 30 günde bakımı yapılmamış?
SELECT 
    o.plaka,
    o.marka,
    o.model,
    o.kilometre,
    o.son_bakim_tarihi,
    DATEDIFF(CURDATE(), o.son_bakim_tarihi) AS gun_gecikme
FROM otobusler o
WHERE o.son_bakim_tarihi < DATE_SUB(CURDATE(), INTERVAL 30 DAY)
AND o.durum != 'bakimda'
ORDER BY gun_gecikme DESC;

-- 10.2 Çalışma planı ile sefer arasındaki tutarsızlıkları bul
SELECT 
    cp.calisma_plani_id,
    CONCAT(s.ad, ' ', s.soyad) AS surucu,
    o.plaka,
    cp.calisma_tarihi,
    COUNT(sf.sefer_id) AS gerceklesen_sefer,
    CASE 
        WHEN cp.baslangic_saati BETWEEN '06:00:00' AND '14:00:00' THEN 8
        WHEN cp.baslangic_saati BETWEEN '14:00:00' AND '22:00:00' THEN 7
        ELSE 6
    END AS planlanan_sefer
FROM calisma_planlari cp
LEFT JOIN seferler sf ON cp.calisma_plani_id = sf.calisma_plani_id
INNER JOIN suruculer s ON cp.surucu_id = s.surucu_id
INNER JOIN otobusler o ON cp.otobus_id = o.otobus_id
WHERE cp.durum != 'iptal'
GROUP BY cp.calisma_plani_id
HAVING COUNT(sf.sefer_id) < CASE 
        WHEN cp.baslangic_saati BETWEEN '06:00:00' AND '14:00:00' THEN 7
        WHEN cp.baslangic_saati BETWEEN '14:00:00' AND '22:00:00' THEN 6
        ELSE 5
    END;