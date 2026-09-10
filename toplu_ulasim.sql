-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Anamakine: mariadb
-- Üretim Zamanı: 10 Eyl 2026, 07:14:59
-- Sunucu sürümü: 12.3.2-MariaDB-ubu2404
-- PHP Sürümü: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `toplu_ulasim`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `bakim_kayitlari`
--

CREATE TABLE `bakim_kayitlari` (
  `bakim_id` int(11) NOT NULL,
  `otobus_id` int(11) NOT NULL,
  `baslangic_tarihi` date NOT NULL,
  `bitis_tarihi` date DEFAULT NULL,
  `bakim_turu` enum('periyodik','arıza','kazıma','yag_degisimi') NOT NULL,
  `aciklama` text DEFAULT NULL,
  `maliyet` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `bakim_kayitlari`
--

INSERT INTO `bakim_kayitlari` (`bakim_id`, `otobus_id`, `baslangic_tarihi`, `bitis_tarihi`, `bakim_turu`, `aciklama`, `maliyet`) VALUES
(1, 5, '2026-08-25', '2026-08-30', 'periyodik', '30.000 km bakımı, yağ değişimi ve fren kontrolü', 2750.50),
(2, 5, '2026-09-01', '2026-09-05', 'arıza', 'Motor arızası, enjektör değişimi', 4350.00),
(3, 1, '2026-08-10', '2026-08-12', 'yag_degisimi', 'Motor yağı ve filtre değişimi', 950.75),
(4, 3, '2026-08-20', '2026-08-22', 'periyodik', '45.000 km bakımı', 3200.00),
(5, 7, '2026-09-01', '2026-09-03', 'kazıma', 'Fren balatası değişimi', 1500.00),
(6, 9, '2026-08-28', NULL, 'arıza', 'Akü arızası, inceleniyor', 0.00);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `calisma_planlari`
--

CREATE TABLE `calisma_planlari` (
  `calisma_plani_id` int(11) NOT NULL,
  `hat_id` int(11) NOT NULL,
  `otobus_id` int(11) NOT NULL,
  `surucu_id` int(11) NOT NULL,
  `gun_tipi_id` int(11) NOT NULL,
  `baslangic_saati` time NOT NULL,
  `bitis_saati` time NOT NULL,
  `calisma_tarihi` date NOT NULL,
  `vardiya_turu` enum('sabah','oge','aksam','gece') DEFAULT 'sabah',
  `durum` enum('planlandi','devam_ediyor','tamamlandi','iptal') DEFAULT 'planlandi',
  `aciklama` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `calisma_planlari`
--

INSERT INTO `calisma_planlari` (`calisma_plani_id`, `hat_id`, `otobus_id`, `surucu_id`, `gun_tipi_id`, `baslangic_saati`, `bitis_saati`, `calisma_tarihi`, `vardiya_turu`, `durum`, `aciklama`) VALUES
(1, 1, 1, 1, 1, '06:00:00', '14:00:00', '2026-09-09', 'sabah', 'planlandi', NULL),
(2, 1, 2, 2, 1, '14:00:00', '22:00:00', '2026-09-09', 'aksam', 'planlandi', NULL),
(3, 2, 3, 3, 1, '06:30:00', '14:30:00', '2026-09-09', 'sabah', 'planlandi', NULL),
(4, 2, 4, 4, 1, '14:30:00', '21:00:00', '2026-09-09', 'aksam', 'planlandi', NULL),
(5, 3, 5, 5, 1, '06:00:00', '14:00:00', '2026-09-09', 'sabah', 'planlandi', NULL),
(6, 3, 6, 6, 1, '14:00:00', '21:00:00', '2026-09-09', 'aksam', 'planlandi', NULL),
(7, 4, 7, 8, 1, '07:00:00', '15:00:00', '2026-09-09', 'sabah', 'planlandi', NULL),
(8, 4, 8, 10, 1, '15:00:00', '22:00:00', '2026-09-09', 'aksam', 'planlandi', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `duraklar`
--

CREATE TABLE `duraklar` (
  `durak_id` int(11) NOT NULL,
  `durak_kodu` varchar(20) NOT NULL,
  `durak_adi` varchar(100) NOT NULL,
  `enlem` decimal(10,8) DEFAULT NULL,
  `boylam` decimal(11,8) DEFAULT NULL,
  `adres` varchar(200) DEFAULT NULL,
  `aktif` tinyint(1) DEFAULT 1,
  `olusturma_tarihi` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `duraklar`
--

INSERT INTO `duraklar` (`durak_id`, `durak_kodu`, `durak_adi`, `enlem`, `boylam`, `adres`, `aktif`, `olusturma_tarihi`) VALUES
(1, 'D-001', 'Kadıköy İskele', 40.99225000, 29.02360000, 'Kadıköy Meydanı No:1', 1, '2026-09-09 08:08:07'),
(2, 'D-002', 'Söğütlüçeşme', 40.99583000, 29.02347000, 'Söğütlüçeşme Caddesi No:15', 1, '2026-09-09 08:08:07'),
(3, 'D-003', 'Acıbadem', 40.99867000, 29.03267000, 'Acıbadem Caddesi No:45', 1, '2026-09-09 08:08:07'),
(4, 'D-004', 'Ünalan', 41.00185000, 29.03587000, 'Ünalan Mahallesi No:78', 1, '2026-09-09 08:08:07'),
(5, 'D-005', 'Beşiktaş İskele', 41.04228000, 29.00467000, 'Beşiktaş Meydanı No:2', 1, '2026-09-09 08:08:07'),
(6, 'D-006', 'Zincirlikuyu', 41.06628000, 29.01167000, 'Zincirlikuyu Köprüsü No:5', 1, '2026-09-09 08:08:07'),
(7, 'D-007', 'Mecidiyeköy', 41.06789000, 28.99489000, 'Mecidiyeköy Meydanı No:10', 1, '2026-09-09 08:08:07'),
(8, 'D-008', 'Şişli', 41.06189000, 28.98767000, 'Şişli Meydanı No:25', 1, '2026-09-09 08:08:07'),
(9, 'D-009', 'Bakırköy İDO', 40.97789000, 28.87489000, 'Bakırköy İskelesi No:1', 1, '2026-09-09 08:08:07'),
(10, 'D-010', 'Ataköy', 40.97867000, 28.86445000, 'Ataköy Sahil No:12', 1, '2026-09-09 08:08:07'),
(11, 'D-011', 'Üsküdar İskele', 41.02467000, 29.01545000, 'Üsküdar Meydanı No:3', 1, '2026-09-09 08:08:07'),
(12, 'D-012', 'Altunizade', 41.01867000, 29.04567000, 'Altunizade Caddesi No:8', 1, '2026-09-09 08:08:07'),
(13, 'D-013', 'Çekmeköy Merkez', 41.03567000, 29.05678000, 'Çekmeköy Merkez No:5', 1, '2026-09-09 08:08:07'),
(14, 'D-014', 'Eminönü İskele', 41.01767000, 28.97156000, 'Eminönü Meydanı No:1', 1, '2026-09-09 08:08:07'),
(15, 'D-015', 'Eyüp Merkez', 41.05067000, 28.93567000, 'Eyüp Meydanı No:3', 1, '2026-09-09 08:08:07');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `durak_gecisleri`
--

CREATE TABLE `durak_gecisleri` (
  `gecis_id` int(11) NOT NULL,
  `sefer_id` int(11) NOT NULL,
  `durak_id` int(11) NOT NULL,
  `varis_zamani` datetime NOT NULL,
  `kalkis_zamani` datetime DEFAULT NULL,
  `inen_yolcu` int(11) DEFAULT 0,
  `binen_yolcu` int(11) DEFAULT 0,
  `gecikme_dakika` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `durak_gecisleri`
--

INSERT INTO `durak_gecisleri` (`gecis_id`, `sefer_id`, `durak_id`, `varis_zamani`, `kalkis_zamani`, `inen_yolcu`, `binen_yolcu`, `gecikme_dakika`) VALUES
(1, 1, 1, '2026-09-09 06:00:00', '2026-09-09 06:00:00', 0, 35, 0),
(2, 1, 2, '2026-09-09 06:03:00', '2026-09-09 06:04:00', 5, 12, 2),
(3, 1, 3, '2026-09-09 06:09:00', '2026-09-09 06:10:00', 8, 10, 2),
(4, 1, 4, '2026-09-09 06:14:00', '2026-09-09 06:15:00', 10, 8, 1),
(5, 1, 5, '2026-09-09 06:24:00', '2026-09-09 06:25:00', 15, 5, 3),
(6, 1, 6, '2026-09-09 06:30:00', '2026-09-09 06:30:00', 42, 0, 2),
(7, 2, 1, '2026-09-09 06:10:00', '2026-09-09 06:10:00', 0, 42, 0),
(8, 2, 2, '2026-09-09 06:14:00', '2026-09-09 06:15:00', 6, 15, 3),
(9, 2, 3, '2026-09-09 06:20:00', '2026-09-09 06:21:00', 10, 12, 2),
(10, 2, 4, '2026-09-09 06:26:00', '2026-09-09 06:27:00', 8, 10, 1),
(11, 2, 5, '2026-09-09 06:36:00', '2026-09-09 06:37:00', 12, 8, 5),
(12, 2, 6, '2026-09-09 06:40:00', '2026-09-09 06:40:00', 43, 0, 5),
(13, 7, 5, '2026-09-09 06:30:00', '2026-09-09 06:30:00', 0, 25, 0),
(14, 7, 6, '2026-09-09 06:45:00', '2026-09-09 06:46:00', 25, 0, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `gun_tipleri`
--

CREATE TABLE `gun_tipleri` (
  `gun_tipi_id` int(11) NOT NULL,
  `gun_tipi_adi` varchar(20) NOT NULL,
  `aciklama` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `gun_tipleri`
--

INSERT INTO `gun_tipleri` (`gun_tipi_id`, `gun_tipi_adi`, `aciklama`) VALUES
(1, 'hafta_ici', 'Pazartesi - Cuma'),
(2, 'cumartesi', 'Cumartesi günü'),
(3, 'pazar', 'Pazar günü');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `guzergahlar`
--

CREATE TABLE `guzergahlar` (
  `guzergah_id` int(11) NOT NULL,
  `hat_id` int(11) NOT NULL,
  `durak_id` int(11) NOT NULL,
  `sira_no` int(11) NOT NULL,
  `yon` enum('gidis','donus') DEFAULT 'gidis',
  `onceki_durak_mesafe` int(11) DEFAULT NULL,
  `tahmini_varis_suresi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `guzergahlar`
--

INSERT INTO `guzergahlar` (`guzergah_id`, `hat_id`, `durak_id`, `sira_no`, `yon`, `onceki_durak_mesafe`, `tahmini_varis_suresi`) VALUES
(1, 1, 1, 1, 'gidis', 0, 0),
(2, 1, 2, 2, 'gidis', 450, 3),
(3, 1, 3, 3, 'gidis', 800, 5),
(4, 1, 4, 4, 'gidis', 600, 4),
(5, 1, 5, 5, 'gidis', 3000, 10),
(6, 1, 6, 6, 'gidis', 2500, 8),
(7, 1, 6, 1, 'donus', 0, 0),
(8, 1, 5, 2, 'donus', 2500, 8),
(9, 1, 4, 3, 'donus', 3000, 10),
(10, 1, 3, 4, 'donus', 600, 4),
(11, 1, 2, 5, 'donus', 800, 5),
(12, 1, 1, 6, 'donus', 450, 3),
(13, 2, 5, 1, 'gidis', 0, 0),
(14, 2, 6, 2, 'gidis', 2500, 8),
(15, 2, 6, 1, 'donus', 0, 0),
(16, 2, 5, 2, 'donus', 2500, 8),
(17, 3, 7, 1, 'gidis', 0, 0),
(18, 3, 8, 2, 'gidis', 1200, 5),
(19, 3, 9, 3, 'gidis', 8000, 20),
(20, 3, 9, 1, 'donus', 0, 0),
(21, 3, 8, 2, 'donus', 8000, 20),
(22, 3, 7, 3, 'donus', 1200, 5),
(23, 4, 11, 1, 'gidis', 0, 0),
(24, 4, 12, 2, 'gidis', 2800, 8),
(25, 4, 13, 3, 'gidis', 3500, 10),
(26, 4, 13, 1, 'donus', 0, 0),
(27, 4, 12, 2, 'donus', 3500, 10),
(28, 4, 11, 3, 'donus', 2800, 8);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `hatlar`
--

CREATE TABLE `hatlar` (
  `hat_id` int(11) NOT NULL,
  `hat_kodu` varchar(20) NOT NULL,
  `hat_adi` varchar(100) NOT NULL,
  `hat_turu` enum('otobus','tramvay','metrobus','metro') DEFAULT 'otobus',
  `aktif` tinyint(1) DEFAULT 1,
  `olusturma_tarihi` timestamp NULL DEFAULT current_timestamp(),
  `guncelleme_tarihi` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `hatlar`
--

INSERT INTO `hatlar` (`hat_id`, `hat_kodu`, `hat_adi`, `hat_turu`, `aktif`, `olusturma_tarihi`, `guncelleme_tarihi`) VALUES
(1, 'H-101', 'Kadıköy - Taksim', 'otobus', 1, '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(2, 'H-102', 'Beşiktaş - Zincirlikuyu', 'otobus', 1, '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(3, 'H-103', 'Mecidiyeköy - Bakırköy', 'otobus', 1, '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(4, 'H-104', 'Üsküdar - Çekmeköy', 'otobus', 1, '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(5, 'H-105', 'Eminönü - Eyüp', 'otobus', 0, '2026-09-09 08:08:07', '2026-09-09 08:08:07');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `hat_saatleri`
--

CREATE TABLE `hat_saatleri` (
  `hat_saati_id` int(11) NOT NULL,
  `hat_id` int(11) NOT NULL,
  `gun_tipi_id` int(11) NOT NULL,
  `saat_araligi` varchar(50) NOT NULL,
  `baslangic_saati` time NOT NULL,
  `bitis_saati` time NOT NULL,
  `sefer_araligi` int(11) NOT NULL,
  `calisma_durumu` enum('aktif','pasif','bakim') DEFAULT 'aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `hat_saatleri`
--

INSERT INTO `hat_saatleri` (`hat_saati_id`, `hat_id`, `gun_tipi_id`, `saat_araligi`, `baslangic_saati`, `bitis_saati`, `sefer_araligi`, `calisma_durumu`) VALUES
(1, 1, 1, 'Sabah', '06:00:00', '09:00:00', 10, 'aktif'),
(2, 1, 1, 'Gündüz', '09:00:00', '17:00:00', 15, 'aktif'),
(3, 1, 1, 'Akşam', '17:00:00', '22:00:00', 12, 'aktif'),
(4, 1, 2, 'Cumartesi', '07:00:00', '22:00:00', 20, 'aktif'),
(5, 1, 3, 'Pazar', '08:00:00', '20:00:00', 25, 'aktif'),
(6, 2, 1, 'Sabah', '06:30:00', '09:30:00', 15, 'aktif'),
(7, 2, 1, 'Gündüz', '09:30:00', '16:30:00', 20, 'aktif'),
(8, 2, 1, 'Akşam', '16:30:00', '21:00:00', 15, 'aktif'),
(9, 2, 2, 'Cumartesi', '08:00:00', '20:00:00', 25, 'aktif'),
(10, 2, 3, 'Pazar', '09:00:00', '19:00:00', 30, 'aktif'),
(11, 3, 1, 'Sabah', '06:00:00', '10:00:00', 12, 'aktif'),
(12, 3, 1, 'Gündüz', '10:00:00', '16:00:00', 18, 'aktif'),
(13, 3, 1, 'Akşam', '16:00:00', '21:00:00', 14, 'aktif'),
(14, 3, 2, 'Cumartesi', '07:00:00', '21:00:00', 22, 'aktif'),
(15, 3, 3, 'Pazar', '08:00:00', '20:00:00', 28, 'aktif');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `otobusler`
--

CREATE TABLE `otobusler` (
  `otobus_id` int(11) NOT NULL,
  `plaka` varchar(15) NOT NULL,
  `marka` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `yil` int(11) DEFAULT NULL,
  `kapasite` int(11) NOT NULL,
  `yakit_turu` enum('dizel','benzin','elektrik','hibrit','cng') DEFAULT 'dizel',
  `durum` enum('aktif','bakimda','arızalı','yedek') DEFAULT 'aktif',
  `kilometre` int(11) DEFAULT 0,
  `son_bakim_tarihi` date DEFAULT NULL,
  `olusturma_tarihi` timestamp NULL DEFAULT current_timestamp(),
  `guncelleme_tarihi` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `otobusler`
--

INSERT INTO `otobusler` (`otobus_id`, `plaka`, `marka`, `model`, `yil`, `kapasite`, `yakit_turu`, `durum`, `kilometre`, `son_bakim_tarihi`, `olusturma_tarihi`, `guncelleme_tarihi`) VALUES
(1, '34 ABC 123', 'Mercedes', 'Travego', 2022, 45, 'dizel', 'aktif', 45780, '2026-08-15', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(2, '34 DEF 456', 'MAN', 'Lion\'s City', 2023, 40, 'dizel', 'aktif', 23450, '2026-09-01', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(3, '34 GHI 789', 'Volvo', '9700', 2022, 48, 'dizel', 'aktif', 67890, '2026-07-20', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(4, '34 JKL 012', 'Scania', 'Citywide', 2023, 42, 'hibrit', 'aktif', 18900, '2026-09-10', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(5, '34 MNO 345', 'Mercedes', 'Conecto', 2021, 38, 'dizel', 'bakimda', 89120, '2026-08-05', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(6, '34 PQR 678', 'MAN', 'Lion\'s City', 2022, 40, 'dizel', 'yedek', 34560, '2026-06-15', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(7, '34 STU 901', 'Volvo', '9900', 2023, 50, 'elektrik', 'aktif', 12340, '2026-09-05', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(8, '34 VWX 234', 'Mercedes', 'Travego', 2021, 44, 'dizel', 'aktif', 56780, '2026-07-10', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(9, '34 YZA 567', 'Scania', 'Citywide', 2022, 41, 'hibrit', 'arızalı', 23450, '2026-08-25', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(10, '34 BCD 890', 'MAN', 'Lion\'s City', 2023, 39, 'dizel', 'aktif', 7890, '2026-09-12', '2026-09-09 08:08:07', '2026-09-09 08:08:07');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `seferler`
--

CREATE TABLE `seferler` (
  `sefer_id` int(11) NOT NULL,
  `calisma_plani_id` int(11) NOT NULL,
  `baslangic_durak_id` int(11) NOT NULL,
  `bitis_durak_id` int(11) NOT NULL,
  `baslangic_zamani` datetime NOT NULL,
  `bitis_zamani` datetime DEFAULT NULL,
  `yolcu_sayisi` int(11) DEFAULT 0,
  `gecikme_dakika` int(11) DEFAULT 0,
  `durum` enum('beklemede','devam_ediyor','tamamlandi','iptal') DEFAULT 'beklemede',
  `notlar` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `seferler`
--

INSERT INTO `seferler` (`sefer_id`, `calisma_plani_id`, `baslangic_durak_id`, `bitis_durak_id`, `baslangic_zamani`, `bitis_zamani`, `yolcu_sayisi`, `gecikme_dakika`, `durum`, `notlar`) VALUES
(1, 1, 1, 6, '2026-09-09 06:00:00', '2026-09-09 06:30:00', 35, 2, 'tamamlandi', NULL),
(2, 1, 1, 6, '2026-09-09 06:10:00', '2026-09-09 06:40:00', 42, 5, 'tamamlandi', NULL),
(3, 1, 1, 6, '2026-09-09 06:20:00', '2026-09-09 06:50:00', 38, 0, 'tamamlandi', NULL),
(4, 1, 6, 1, '2026-09-09 06:35:00', '2026-09-09 07:05:00', 45, 3, 'tamamlandi', NULL),
(5, 1, 6, 1, '2026-09-09 06:45:00', '2026-09-09 07:15:00', 50, 1, 'tamamlandi', NULL),
(6, 1, 1, 6, '2026-09-09 06:55:00', '2026-09-09 07:25:00', 48, 0, 'tamamlandi', NULL),
(7, 3, 5, 6, '2026-09-09 06:30:00', '2026-09-09 06:46:00', 25, 1, 'tamamlandi', NULL),
(8, 3, 5, 6, '2026-09-09 06:45:00', '2026-09-09 07:01:00', 30, 0, 'tamamlandi', NULL),
(9, 3, 6, 5, '2026-09-09 06:55:00', '2026-09-09 07:11:00', 28, 2, 'tamamlandi', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `suruculer`
--

CREATE TABLE `suruculer` (
  `surucu_id` int(11) NOT NULL,
  `tc_kimlik` varchar(11) NOT NULL,
  `ad` varchar(50) NOT NULL,
  `soyad` varchar(50) NOT NULL,
  `dogum_tarihi` date DEFAULT NULL,
  `ehliyet_no` varchar(20) DEFAULT NULL,
  `ehliyet_sinifi` varchar(10) DEFAULT NULL,
  `telefon` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `adres` varchar(200) DEFAULT NULL,
  `ise_baslama_tarihi` date NOT NULL,
  `durum` enum('aktif','izinde','raporlu','istifa') DEFAULT 'aktif',
  `olusturma_tarihi` timestamp NULL DEFAULT current_timestamp(),
  `guncelleme_tarihi` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `suruculer`
--

INSERT INTO `suruculer` (`surucu_id`, `tc_kimlik`, `ad`, `soyad`, `dogum_tarihi`, `ehliyet_no`, `ehliyet_sinifi`, `telefon`, `email`, `adres`, `ise_baslama_tarihi`, `durum`, `olusturma_tarihi`, `guncelleme_tarihi`) VALUES
(1, '12345678901', 'Mehmet', 'Yılmaz', '1985-03-15', 'E123456', 'D', '555-123-4567', 'mehmet.yilmaz@example.com', 'Kadıköy, İstanbul', '2020-01-15', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(2, '23456789012', 'Ayşe', 'Kaya', '1990-07-22', 'E234567', 'D', '555-234-5678', 'ayse.kaya@example.com', 'Üsküdar, İstanbul', '2021-03-01', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(3, '34567890123', 'Ali', 'Demir', '1988-11-10', 'E345678', 'D', '555-345-6789', 'ali.demir@example.com', 'Beşiktaş, İstanbul', '2019-06-15', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(4, '45678901234', 'Fatma', 'Şahin', '1992-05-05', 'E456789', 'D', '555-456-7890', 'fatma.sahin@example.com', 'Şişli, İstanbul', '2022-09-01', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(5, '56789012345', 'Mustafa', 'Çelik', '1986-09-30', 'E567890', 'D', '555-567-8901', 'mustafa.celik@example.com', 'Bakırköy, İstanbul', '2020-11-20', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(6, '67890123456', 'Emine', 'Aydın', '1993-02-18', 'E678901', 'D', '555-678-9012', 'emine.aydin@example.com', 'Zincirlikuyu, İstanbul', '2021-07-15', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(7, '78901234567', 'Ahmet', 'Öztürk', '1984-08-12', 'E789012', 'D', '555-789-0123', 'ahmet.ozturk@example.com', 'Mecidiyeköy, İstanbul', '2018-05-10', 'izinde', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(8, '89012345678', 'Zeynep', 'Koç', '1991-12-25', 'E890123', 'D', '555-890-1234', 'zeynep.koc@example.com', 'Çekmeköy, İstanbul', '2022-01-10', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(9, '90123456789', 'Hüseyin', 'Yıldız', '1987-06-08', 'E901234', 'D', '555-901-2345', 'huseyin.yildiz@example.com', 'Eyüp, İstanbul', '2020-08-15', 'raporlu', '2026-09-09 08:08:07', '2026-09-09 08:08:07'),
(10, '01234567890', 'Selin', 'Çakır', '1994-04-03', 'E012345', 'D', '555-012-3456', 'selin.cakir@example.com', 'Ataköy, İstanbul', '2023-02-01', 'aktif', '2026-09-09 08:08:07', '2026-09-09 08:08:07');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `bakim_kayitlari`
--
ALTER TABLE `bakim_kayitlari`
  ADD PRIMARY KEY (`bakim_id`),
  ADD KEY `idx_bakim_kayitlari_otobus` (`otobus_id`),
  ADD KEY `idx_bakim_kayitlari_tarih` (`baslangic_tarihi`);

--
-- Tablo için indeksler `calisma_planlari`
--
ALTER TABLE `calisma_planlari`
  ADD PRIMARY KEY (`calisma_plani_id`),
  ADD UNIQUE KEY `unique_plan_otobus_tarih_saat` (`otobus_id`,`calisma_tarihi`,`baslangic_saati`),
  ADD UNIQUE KEY `unique_plan_surucu_tarih_saat` (`surucu_id`,`calisma_tarihi`,`baslangic_saati`),
  ADD KEY `gun_tipi_id` (`gun_tipi_id`),
  ADD KEY `idx_calisma_planlari_tarih` (`calisma_tarihi`),
  ADD KEY `idx_calisma_planlari_hat_gun` (`hat_id`,`gun_tipi_id`),
  ADD KEY `idx_calisma_planlari_otobus` (`otobus_id`),
  ADD KEY `idx_calisma_planlari_surucu` (`surucu_id`),
  ADD KEY `idx_calisma_planlari_durum` (`durum`),
  ADD KEY `idx_calisma_planlari_tarih_durum` (`calisma_tarihi`,`durum`);

--
-- Tablo için indeksler `duraklar`
--
ALTER TABLE `duraklar`
  ADD PRIMARY KEY (`durak_id`),
  ADD UNIQUE KEY `durak_kodu` (`durak_kodu`),
  ADD KEY `idx_duraklar_aktif` (`aktif`);

--
-- Tablo için indeksler `durak_gecisleri`
--
ALTER TABLE `durak_gecisleri`
  ADD PRIMARY KEY (`gecis_id`),
  ADD KEY `idx_durak_gecisleri_sefer` (`sefer_id`),
  ADD KEY `idx_durak_gecisleri_durak` (`durak_id`),
  ADD KEY `idx_durak_gecisleri_varis_zamani` (`varis_zamani`);

--
-- Tablo için indeksler `gun_tipleri`
--
ALTER TABLE `gun_tipleri`
  ADD PRIMARY KEY (`gun_tipi_id`),
  ADD UNIQUE KEY `gun_tipi_adi` (`gun_tipi_adi`);

--
-- Tablo için indeksler `guzergahlar`
--
ALTER TABLE `guzergahlar`
  ADD PRIMARY KEY (`guzergah_id`),
  ADD UNIQUE KEY `unique_hat_durak_sira` (`hat_id`,`durak_id`,`sira_no`,`yon`),
  ADD KEY `durak_id` (`durak_id`),
  ADD KEY `idx_guzergahlar_hat_sira` (`hat_id`,`sira_no`),
  ADD KEY `idx_guzergahlar_hat_durak` (`hat_id`,`durak_id`),
  ADD KEY `idx_guzergahlar_hat_yon_sira` (`hat_id`,`yon`,`sira_no`);

--
-- Tablo için indeksler `hatlar`
--
ALTER TABLE `hatlar`
  ADD PRIMARY KEY (`hat_id`),
  ADD UNIQUE KEY `hat_kodu` (`hat_kodu`),
  ADD KEY `idx_hatlar_aktif` (`aktif`);

--
-- Tablo için indeksler `hat_saatleri`
--
ALTER TABLE `hat_saatleri`
  ADD PRIMARY KEY (`hat_saati_id`),
  ADD UNIQUE KEY `unique_hat_gun_saat` (`hat_id`,`gun_tipi_id`,`baslangic_saati`,`bitis_saati`),
  ADD KEY `gun_tipi_id` (`gun_tipi_id`),
  ADD KEY `idx_hat_saatleri_hat_gun` (`hat_id`,`gun_tipi_id`),
  ADD KEY `idx_hat_saatleri_calisma_durumu` (`calisma_durumu`);

--
-- Tablo için indeksler `otobusler`
--
ALTER TABLE `otobusler`
  ADD PRIMARY KEY (`otobus_id`),
  ADD UNIQUE KEY `plaka` (`plaka`),
  ADD KEY `idx_otobusler_durum` (`durum`),
  ADD KEY `idx_otobusler_plaka` (`plaka`);

--
-- Tablo için indeksler `seferler`
--
ALTER TABLE `seferler`
  ADD PRIMARY KEY (`sefer_id`),
  ADD KEY `baslangic_durak_id` (`baslangic_durak_id`),
  ADD KEY `bitis_durak_id` (`bitis_durak_id`),
  ADD KEY `idx_seferler_calisma_plani` (`calisma_plani_id`),
  ADD KEY `idx_seferler_baslangic_zamani` (`baslangic_zamani`),
  ADD KEY `idx_seferler_durum` (`durum`),
  ADD KEY `idx_seferler_plani_durum` (`calisma_plani_id`,`durum`);

--
-- Tablo için indeksler `suruculer`
--
ALTER TABLE `suruculer`
  ADD PRIMARY KEY (`surucu_id`),
  ADD UNIQUE KEY `tc_kimlik` (`tc_kimlik`),
  ADD UNIQUE KEY `ehliyet_no` (`ehliyet_no`),
  ADD KEY `idx_suruculer_durum` (`durum`),
  ADD KEY `idx_suruculer_tc_kimlik` (`tc_kimlik`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `bakim_kayitlari`
--
ALTER TABLE `bakim_kayitlari`
  MODIFY `bakim_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `calisma_planlari`
--
ALTER TABLE `calisma_planlari`
  MODIFY `calisma_plani_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tablo için AUTO_INCREMENT değeri `duraklar`
--
ALTER TABLE `duraklar`
  MODIFY `durak_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Tablo için AUTO_INCREMENT değeri `durak_gecisleri`
--
ALTER TABLE `durak_gecisleri`
  MODIFY `gecis_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Tablo için AUTO_INCREMENT değeri `gun_tipleri`
--
ALTER TABLE `gun_tipleri`
  MODIFY `gun_tipi_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `guzergahlar`
--
ALTER TABLE `guzergahlar`
  MODIFY `guzergah_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Tablo için AUTO_INCREMENT değeri `hatlar`
--
ALTER TABLE `hatlar`
  MODIFY `hat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `hat_saatleri`
--
ALTER TABLE `hat_saatleri`
  MODIFY `hat_saati_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Tablo için AUTO_INCREMENT değeri `otobusler`
--
ALTER TABLE `otobusler`
  MODIFY `otobus_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Tablo için AUTO_INCREMENT değeri `seferler`
--
ALTER TABLE `seferler`
  MODIFY `sefer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Tablo için AUTO_INCREMENT değeri `suruculer`
--
ALTER TABLE `suruculer`
  MODIFY `surucu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `bakim_kayitlari`
--
ALTER TABLE `bakim_kayitlari`
  ADD CONSTRAINT `1` FOREIGN KEY (`otobus_id`) REFERENCES `otobusler` (`otobus_id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `calisma_planlari`
--
ALTER TABLE `calisma_planlari`
  ADD CONSTRAINT `1` FOREIGN KEY (`hat_id`) REFERENCES `hatlar` (`hat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `2` FOREIGN KEY (`otobus_id`) REFERENCES `otobusler` (`otobus_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `3` FOREIGN KEY (`surucu_id`) REFERENCES `suruculer` (`surucu_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `4` FOREIGN KEY (`gun_tipi_id`) REFERENCES `gun_tipleri` (`gun_tipi_id`);

--
-- Tablo kısıtlamaları `durak_gecisleri`
--
ALTER TABLE `durak_gecisleri`
  ADD CONSTRAINT `1` FOREIGN KEY (`sefer_id`) REFERENCES `seferler` (`sefer_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `2` FOREIGN KEY (`durak_id`) REFERENCES `duraklar` (`durak_id`);

--
-- Tablo kısıtlamaları `guzergahlar`
--
ALTER TABLE `guzergahlar`
  ADD CONSTRAINT `1` FOREIGN KEY (`hat_id`) REFERENCES `hatlar` (`hat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `2` FOREIGN KEY (`durak_id`) REFERENCES `duraklar` (`durak_id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `hat_saatleri`
--
ALTER TABLE `hat_saatleri`
  ADD CONSTRAINT `1` FOREIGN KEY (`hat_id`) REFERENCES `hatlar` (`hat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `2` FOREIGN KEY (`gun_tipi_id`) REFERENCES `gun_tipleri` (`gun_tipi_id`);

--
-- Tablo kısıtlamaları `seferler`
--
ALTER TABLE `seferler`
  ADD CONSTRAINT `1` FOREIGN KEY (`calisma_plani_id`) REFERENCES `calisma_planlari` (`calisma_plani_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `2` FOREIGN KEY (`baslangic_durak_id`) REFERENCES `duraklar` (`durak_id`),
  ADD CONSTRAINT `3` FOREIGN KEY (`bitis_durak_id`) REFERENCES `duraklar` (`durak_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
