Seviye 1: Başlangıç (Temel Filtreleme ve Sıralama)
Bu bölümde: SELECT, WHERE, ORDER BY, LIMIT ve LIKE kavramlarını pekiştireceğiz.

1. Tüm ürünlerin listesini, isim ve fiyatlarıyla birlikte getir.
2. Fiyatı 1000 TL'den fazla olan ürünleri, en pahalıdan en ucuza doğru sıralayarak getir.
3. İsmi "Laptop" ile başlayan ürünleri getir.
4. Stok miktarı 20'den az olan ilk 3 ürünü getir.

Seviye 2: Orta (Tablo Birleştirme ve Gruplama)
Bu bölümde: INNER JOIN, LEFT JOIN, COUNT, SUM, GROUP BY ve HAVING kavramlarını pekiştireceğiz.

5. Ürünlerin isimlerini ve yanına ait oldukları kategori isimlerini getir. (İki tabloyu birleştirme)
6. Her kategoride kaç tane ürün olduğunu bul. (Gruplama ve Sayma)
7. Toplam sipariş tutarı 2000 TL üzerinde olan siparişleri ve bu siparişleri veren kullanıcıların isimlerini getir.
8. Hangi kategorideki ürünlerin toplam stok değeri (fiyat * stok) en yüksek?

Seviye 3: İleri (Alt Sorgular ve Karmaşık Mantık)
Bu bölümde: Subqueries, CASE WHEN, HAVING ve karmaşık Join yapılarını pekiştireceğiz.

9. Hiç sipariş vermemiş kullanıcıları listele. (LEFT JOIN ve NULL kontrolü)
10. Ortalama ürün fiyatının üzerinde olan ürünleri listele. (Alt Sorgu - Subquery)
11. Siparişlerin durumuna göre bir rapor oluştur: "Teslim Edildi" olanlara 'Tamamlandı', diğerlerine 'Süreç Devam Ediyor' yaz. (CASE WHEN kullanımı)
12. En çok harcama yapan ilk 3 müşterinin adını ve toplam harcamasını getir.
13. Her kategorinin en pahalı ürününü ve fiyatını getir. (İleri düzey alt sorgu)

Özet Çalışma Planı:
*Sadece SELECT ve WHERE ile veriyi süzmeyi öğren.
*JOIN ile farklı tablolar arasındaki ilişkiyi kurmayı çöz.
*GROUP BY ve SUM/COUNT/AVG ile veriden anlamlı raporlar çıkarmayı dene.
*Subqueries (Alt sorgular) ile bir sorgunun sonucunu başka bir sorguda kullanmayı dene.
