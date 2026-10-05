"""Emoji hesap makinesi.

Normal matematik ifadelerini hesaplar ve yazılan karakterleri emojilere çevirir.
"""

import ast
import operator
import re
import tkinter as tk
from tkinter import messagebox


# Tüm karakter, özel ifade ve özel sayı eşleşmeleri tek sözlükte tutulur.
EMOJI_MAP = {
    # Sayılar
    "0": "0️⃣", "1": "1️⃣", "2": "2️⃣", "3": "3️⃣", "4": "4️⃣",
    "5": "5️⃣", "6": "6️⃣", "7": "7️⃣", "8": "8️⃣", "9": "9️⃣",
    "42": "🌌", "100": "💯", "356": "🍃", "404": "🤷",
    # İşlemler ve semboller
    "+": "➕", "-": "➖", "*": "✖️", "/": "➗", "=": "🟰",
    "(": "🟠", ")": "🟠", ".": "🔵", "%": "💯",
    # Özel ifadeler
    ":)": "🙂", ":(": "🙁", ":D": "😄", ";)": "😉", "<3": "❤️",
    ":/": "😕", ":|": "😐", ":P": "😛", ";P": "😜", ":o": "😮",
    ":*": "😘", "-_-": "😑", "^_^": "😊", "<3<3": "💖", ":X": "❌",
    "??": "❓",
}


def karakter_to_emoji(karakter):
    """Tek bir karakteri veya ifadeyi emojiye çevirir."""
    return EMOJI_MAP.get(karakter.lower(), karakter)


def emojiye_cevir(metin):
    """Metindeki özel ifadeleri, sayıları ve sembolleri emojiye çevirir."""
    # Uzun ifadeler önce işlenir: <3<3, <3 ifadesinden önce ele alınmalıdır.
    ifadeler = [anahtar for anahtar in EMOJI_MAP if len(anahtar) > 1 and not anahtar.isdigit()]
    for ifade in sorted(ifadeler, key=len, reverse=True):
        metin = metin.replace(ifade, EMOJI_MAP[ifade])

    def sayiyi_cevir(eslesme):
        sayi = eslesme.group()
        if sayi in EMOJI_MAP:
            return EMOJI_MAP[sayi]
        return " ".join(karakter_to_emoji(rakam) for rakam in sayi)

    metin = re.sub(r"\d+", sayiyi_cevir, metin)
    return " ".join(karakter_to_emoji(karakter) for karakter in metin if karakter != " ")


def matematik_ifadesini_hesapla(ifade):
    """Yalnızca sayı ve temel aritmetik işlemlerini güvenli şekilde hesaplar."""
    if not re.fullmatch(r"[0-9+\-*/%.() ]+", ifade):
        raise ValueError("Geçersiz karakter")

    agac = ast.parse(ifade, mode="eval")
    islemler = {
        ast.Add: operator.add,
        ast.Sub: operator.sub,
        ast.Mult: operator.mul,
        ast.Div: operator.truediv,
        ast.Mod: operator.mod,
        ast.UAdd: operator.pos,
        ast.USub: operator.neg,
    }

    def degerlendir(dal):
        if isinstance(dal, ast.Expression):
            return degerlendir(dal.body)
        if isinstance(dal, ast.Constant) and isinstance(dal.value, (int, float)):
            return dal.value
        if isinstance(dal, ast.UnaryOp) and type(dal.op) in islemler:
            return islemler[type(dal.op)](degerlendir(dal.operand))
        if isinstance(dal, ast.BinOp) and type(dal.op) in islemler:
            return islemler[type(dal.op)](degerlendir(dal.left), degerlendir(dal.right))
        raise ValueError("Geçersiz matematik ifadesi")

    return degerlendir(agac)


class EmojiHesapMakinesi:
    """Hesaplama, emoji önizleme ve emoji tuşlarını tek arayüzde birleştirir."""

    def __init__(self, root):
        self.root = root
        self.ifade = ""
        self.root.title("🧮 Emoji Hesap Makinesi")
        self.root.geometry("560x760")
        self.root.configure(bg="#1e1e2e")
        self.root.resizable(False, False)
        self.arayuzu_olustur()
        self.root.bind_all("<Key>", self.klavye_tusuna_bas)

    def arayuzu_olustur(self):
        tk.Label(
            self.root, text="🧮 Emoji Hesap Makinesi",
            font=("Segoe UI Emoji", 18, "bold"), bg="#1e1e2e", fg="#f5c2e7",
        ).pack(pady=10)

        self.ifade_var = tk.StringVar(value="0")
        tk.Label(
            self.root, textvariable=self.ifade_var, font=("Consolas", 20, "bold"),
            bg="#313244", fg="#cdd6f4", anchor="e", padx=10,
        ).pack(fill="x", padx=15, pady=4)

        self.emoji_var = tk.StringVar(value="0️⃣")
        tk.Label(
            self.root, textvariable=self.emoji_var, font=("Segoe UI Emoji", 22),
            bg="#45475a", fg="#f9e2af", anchor="e", padx=10, wraplength=520,
        ).pack(fill="x", padx=15, pady=(0, 8))

        self.hesap_tuslarini_olustur()

    def hesap_tuslarini_olustur(self):
        tuslar = (("C", "(", ")", "/"), ("7", "8", "9", "*"),
                  ("4", "5", "6", "-"), ("1", "2", "3", "+"),
                  ("0", ".", "%", "="))
        cerceve = tk.Frame(self.root, bg="#1e1e2e")
        cerceve.pack()

        for satir in tuslar:
            satir_cercevesi = tk.Frame(cerceve, bg="#1e1e2e")
            satir_cercevesi.pack()
            for tus in satir:
                self.hesap_tusu_olustur(satir_cercevesi, tus)

        ifade_cercevesi = tk.Frame(self.root, bg="#1e1e2e")
        ifade_cercevesi.pack()
        ozel_ifadeler = [k for k in EMOJI_MAP if len(k) > 1 and not k.isdigit()]
        for sira, ifade in enumerate(ozel_ifadeler):
            self.hesap_tusu_olustur(
                ifade_cercevesi, ifade, ozel=True,
                konum=(sira // 4, sira % 4),
            )


    def hesap_tusu_olustur(self, parent, tus, ozel=False, konum=None):
        if tus == "??":
            arka_plan, yazi = "#a6e3a1", "#1e1e2e"
        elif ozel:
            arka_plan, yazi = "#585b70", "#cdd6f4"
        elif tus == "=":
            arka_plan, yazi = "#a6e3a1", "#1e1e2e"
        elif tus == "C":
            arka_plan, yazi = "#f38ba8", "#1e1e2e"
        elif tus in "+-*/%":
            arka_plan, yazi = "#fab387", "#1e1e2e"
        else:
            arka_plan, yazi = "#585b70", "#cdd6f4"

        buton = tk.Button(
            parent, text=f"{tus}\n{karakter_to_emoji(tus)}",
            font=("Segoe UI Emoji", 12, "bold"), bg=arka_plan, fg=yazi,
            width=7, height=2, relief="flat",
            command=lambda: self.harita_goster() if tus == "??" else (
                self.ifade_ekle(tus) if ozel else self.hesap_tusuna_bas(tus)
            ),
        )
        if ozel and konum is not None:
            buton.grid(row=konum[0], column=konum[1], padx=3, pady=3)
        else:
            buton.pack(side="left", padx=4, pady=4)

    def ifade_ekle(self, parca):
        self.ifade += parca
        self.ekrani_guncelle()

    def klavye_tusuna_bas(self, olay):
        """Klavyeden gelen tuşları hesap makinesiyle aynı akışa yönlendirir."""
        if olay.keysym in ("Return", "KP_Enter"):
            self.hesapla()
        elif olay.keysym == "BackSpace":
            self.ifade = self.ifade[:-1]
            self.ekrani_guncelle()
        elif olay.keysym == "Escape":
            self.ifade = ""
            self.ekrani_guncelle()
        elif olay.char in "0123456789+-*/%.():;<>|^_DPXx":
            self.hesap_tusuna_bas(olay.char)
        elif olay.char == "?":
            if self.ifade.endswith("?"):
                self.ifade = self.ifade[:-1]
                self.harita_goster()
            else:
                self.ifade += "?"
                self.ekrani_guncelle()

        return "break"

    def hesap_tusuna_bas(self, tus):
        if tus == "C":
            self.ifade = ""
        elif tus == "=":
            self.hesapla()
            return
        else:
            self.ifade += tus
        self.ekrani_guncelle()

    def ekrani_guncelle(self):
        self.ifade_var.set(self.ifade or "0")
        self.emoji_var.set(emojiye_cevir(self.ifade or "0"))

    def hesapla(self):
        if not self.ifade:
            return
        try:
            self.ifade = str(matematik_ifadesini_hesapla(self.ifade))
            self.ekrani_guncelle()
        except ZeroDivisionError:
            messagebox.showerror("Hata", "Sıfıra bölme yapılamaz!")
        except (SyntaxError, ValueError):
            messagebox.showerror("Hata", "Geçersiz matematik ifadesi!")

    def harita_goster(self):
        satirlar = [f"{anahtar:>5}  →  {emoji}" for anahtar, emoji in EMOJI_MAP.items()]
        messagebox.showinfo("Emoji Haritası", "\n".join(satirlar))


if __name__ == "__main__":
    pencere = tk.Tk()
    EmojiHesapMakinesi(pencere)
    pencere.mainloop()
