 Seviye 1: Başlangıç (Temel Filtreleme ve Sıralama)
Bu bölümde: SELECT, WHERE, ORDER BY, LIMIT ve LIKE kavramlarını pekiştireceğiz.

1. Tüm ürünlerin listesini, isim ve fiyatlarıyla birlikte getir.

SELECT product_name, price FROM products;
2. Fiyatı 1000 TL'den fazla olan ürünleri, en pahalıdan en ucuza doğru sıralayarak getir.

SELECT * FROM products 
WHERE price > 1000 
ORDER BY price DESC;
3. İsmi "Laptop" ile başlayan ürünleri getir.

SELECT * FROM products 
WHERE product_name LIKE 'Laptop%';
4. Stok miktarı 20'den az olan ilk 3 ürünü getir.

SELECT * FROM products 
WHERE stock_quantity < 20 
LIMIT 3;
🟡 Seviye 2: Orta (Tablo Birleştirme ve Gruplama)
Bu bölümde: INNER JOIN, LEFT JOIN, COUNT, SUM, GROUP BY ve HAVING kavramlarını pekiştireceğiz.

5. Ürünlerin isimlerini ve yanına ait oldukları kategori isimlerini getir. (İki tabloyu birleştirme)

SELECT p.product_name, c.category_name 
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;
6. Her kategoride kaç tane ürün olduğunu bul. (Gruplama ve Sayma)

SELECT c.category_name, COUNT(p.product_id) as urun_sayisi 
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;
7. Toplam sipariş tutarı 2000 TL üzerinde olan siparişleri ve bu siparişleri veren kullanıcıların isimlerini getir.

SELECT u.first_name, u.last_name, o.total_amount 
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.total_amount > 2000;
8. Hangi kategorideki ürünlerin toplam stok değeri (fiyat * stok) en yüksek?

SELECT c.category_name, SUM(p.price * p.stock_quantity) as toplam_deger
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY toplam_deger DESC;
🔴 Seviye 3: İleri (Alt Sorgular ve Karmaşık Mantık)
Bu bölümde: Subqueries, CASE WHEN, HAVING ve karmaşık Join yapılarını pekiştireceğiz.

9. Hiç sipariş vermemiş kullanıcıları listele. (LEFT JOIN ve NULL kontrolü)

SELECT u.first_name, u.last_name 
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;
10. Ortalama ürün fiyatının üzerinde olan ürünleri listele. (Alt Sorgu - Subquery)

SELECT product_name, price 
FROM products 
WHERE price > (SELECT AVG(price) FROM products);
11. Siparişlerin durumuna göre bir rapor oluştur: "Teslim Edildi" olanlara 'Tamamlandı', diğerlerine 'Süreç Devam Ediyor' yaz. (CASE WHEN kullanımı)

SELECT order_id, 
       CASE 
           WHEN status = 'Teslim Edildi' THEN 'Tamamlandı'
           ELSE 'Süreç Devam Ediyor'
       END as siparis_durumu
FROM orders;
12. En çok harcama yapan ilk 3 müşterinin adını ve toplam harcamasını getir.

SELECT u.first_name, u.last_name, SUM(o.total_amount) as toplam_harcama
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY toplam_harcama DESC
LIMIT 3;
13. Her kategorinin en pahalı ürününü ve fiyatını getir. (İleri düzey alt sorgu)

SELECT p.product_name, p.price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.price = (
    SELECT MAX(price) 
    FROM products p2 
    WHERE p2.category_id = p.category_id
);