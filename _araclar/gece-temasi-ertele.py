"""Derleme sonrası (Quarto post-render): gece teması stillerini başlangıçta yükletme.

Quarto açık ve gece temasının stil dosyalarını <head> içinde ikisi de etkin (rel="stylesheet")
olarak yazar; ikisi de sayfa görünmeden önce indirilir. Gece teması isteğe bağlı olduğu için
alternatif dosyaları rel="disabled-stylesheet" yaparız: tarayıcı onları indirmez. Ziyaretçi gece
temasını seçince Quarto'nun kendi betiği (toggleColorMode → enableStylesheet) rel'i yeniden
"stylesheet" yapar ve dosya o anda iner.

Quarto çalıştırırken QUARTO_PROJECT_OUTPUT_FILES ortam değişkeninde derlenen dosyaları verir.
"""
import os
import re

ALTERNATIF = re.compile(r'<link\b[^>]*\bquarto-color-alternate\b[^>]*>')


def isle(etiket):
    return etiket.group(0).replace('rel="stylesheet"', 'rel="disabled-stylesheet"')


dosyalar = [f for f in os.environ.get("QUARTO_PROJECT_OUTPUT_FILES", "").splitlines() if f.endswith(".html")]
degisen = 0
for yol in dosyalar:
    if not os.path.exists(yol):
        continue
    with open(yol, encoding="utf-8") as f:
        eski = f.read()
    yeni = ALTERNATIF.sub(isle, eski)
    if yeni != eski:
        with open(yol, "w", encoding="utf-8") as f:
            f.write(yeni)
        degisen += 1
print(f"gece-temasi-ertele: {degisen}/{len(dosyalar)} sayfa")
