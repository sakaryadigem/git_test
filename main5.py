#Konular: Mantıksal operatörler (and, or, not), len(), in operatörü
#Görev: Aşağıda hazır verilmiş kullanici_adi ve sifre değişkenlerini kullanarak şifrenin geçerli olup olmadığını kontrol eden bir program yazın.
# iki değer alın : kullanici, sifre
# * kullanici 8 karakterden fazla 11 karakterden az olmalı
# * kullanici_listesi = ["aliveli", "mehmet1453"] //bu kullanıcı zaten kayıtlı
# * bunların dışında kullanıcı geçerli
#Şifre geçerli olma koşulları:
#* En az 8 karakter uzunluğunda olmalı
#* "1234" veya "password" içermemeli
# içinde a harfi geçmemeli
# kullaniciadi ile şifre aynı olmamamlı

#Kullanıcı adı ile aynı olmamalı
#Geçerliyse "Şifre kabul edildi", değilse hangi kuralın ihlal edildiğini yazdırın.

#Başlangıç Kodu:
#kullanici_adi = "mehmet1453"
#sifre = "12345678"

# Buradan sonrasını sen yaz
# her yeni kullanıcı için kullanıcı listesine ekleme yapsın ve sonraki kontrolde onay vermesin
# kullanıcı veya şifre geçersiz olduğunda tekrar geçerli kulalnıcı adı ve şifre istesin


kullanici_adi     = input("Kullanıcı: ")
sifre             = input("Şifre: ")

kullanici_listesi = ["aliveli", "mehmet1453"]

#if len(kullanici_adi) <= 8 or len(kullanici_adi) >= 11: 
#    print("kullanici 8 karakterden fazla 11 karakterden az olmalı")
#elif kullanici_adi in kullanici_listesi:
#    print("Bu kullanıcı zaten kayıtlı")
#else:
#    print("Kullanıcı geçerli")
    
#if len(sifre) < 8:
#    print("Şifre 8 karakterden az olamaz")
#elif "1234" in sifre or "password" in sifre or "a" in sifre:
#    print('"1234" veya "password" içermemeli"')
#elif kullanici_adi == sifre:
#    print("Kullanıcı adı ve şifre aynı olamaz")
#else:
#    print("Şifre kabul edildi")
    
# Hataları biriktirmek için liste
hatalar = []

# 1) Kullanıcı adı uzunluk kontrolü: 8'den fazla, 11'den az olmalı
if not (len(kullanici_adi) > 8 and len(kullanici_adi) < 11):
    hatalar.append("Kullanıcı adı 8 karakterden fazla ve 11 karakterden az olmalı.")

# 2) Kullanıcı adı zaten kayıtlı mı?
if kullanici_adi in kullanici_listesi:
    hatalar.append("Bu kullanıcı adı zaten kayıtlı.")

# 3) Şifre en az 8 karakter olmalı
if len(sifre) < 8:
    hatalar.append("Şifre en az 8 karakter uzunluğunda olmalı.")

# 4) Şifre '1234' veya 'password' içermemeli
if ("1234" in sifre) or ("password" in sifre):
    hatalar.append("Şifre '1234' veya 'password' içermemeli.")

# 5) Şifre 'a' harfi içermemeli
if "a" in sifre:
    hatalar.append("Şifre 'a' harfi içermemeli.")

# 6) Kullanıcı adı ile şifre aynı olmamalı
if kullanici_adi == sifre:
    hatalar.append("Kullanıcı adı ile şifre aynı olmamalı.")

# Sonuç kontrolü
if not hatalar:
    print("Kullanıcı adı ve Şifre kabul edildi")
else:
    print("Kullanıcı adı veya Şifre reddedildi. İhlal edilen kurallar:")
    for hata in hatalar:
        print("-", hata)    