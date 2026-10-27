"""Derleme sonrası (Quarto post-render) düzeltmeleri. Quarto, derlenen dosyaları
QUARTO_PROJECT_OUTPUT_FILES ortam değişkeninde verir; yalnızca .html dosyaları işlenir.

1. Gece teması stillerini başlangıçta yükletme (hız).
   Quarto açık ve gece temasının stil dosyalarını <head> içinde ikisi de etkin (rel="stylesheet")
   yazar; ikisi de sayfa görünmeden önce indirilir. Gece teması isteğe bağlı olduğu için alternatif
   dosyaları rel="disabled-stylesheet" yaparız: tarayıcı onları indirmez. Ziyaretçi gece temasını
   seçince Quarto'nun kendi betiği (toggleColorMode → enableStylesheet) rel'i yeniden "stylesheet"
   yapar ve dosya o anda iner.

2. Boş listelerde konsol hatası.
   Quarto her liste için `new List(...)` (list.js) kurar; hiç kaydı olmayan listede list.js
   "The list needs to have at least one item on init" hatası verir. Boş listelerin kurulum satırı
   kaldırılır (filtre/sıralama zaten gerekmez; "henüz kayıt yok." metni CSS ile gösterilir).
"""
import os
import re

ALTERNATIF = re.compile(r'<link\b[^>]*\bquarto-color-alternate\b[^>]*>')
BOS_LISTE = re.compile(r'<div id="(listing-[^"]+)" class="quarto-listing[^"]*">\s*<div class="list[^"]*">\s*</div>')


def gece_ertele(html):
    return ALTERNATIF.sub(lambda m: m.group(0).replace('rel="stylesheet"', 'rel="disabled-stylesheet"'), html)


def bos_listeler(html):
    for kimlik in BOS_LISTE.findall(html):
        satir = "window['quarto-listings']['%s'] = new List('%s', options);" % (kimlik, kimlik)
        html = html.replace(satir, "// %s: kayıt yok, list.js kurulmadı" % kimlik)
    return html


dosyalar = [f for f in os.environ.get("QUARTO_PROJECT_OUTPUT_FILES", "").splitlines() if f.endswith(".html")]
degisen = 0
for yol in dosyalar:
    if not os.path.exists(yol):
        continue
    with open(yol, encoding="utf-8") as f:
        eski = f.read()
    yeni = bos_listeler(gece_ertele(eski))
    if yeni != eski:
        with open(yol, "w", encoding="utf-8") as f:
            f.write(yeni)
        degisen += 1
print(f"derleme-sonrasi: {degisen}/{len(dosyalar)} sayfa düzenlendi")
