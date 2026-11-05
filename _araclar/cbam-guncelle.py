"""SKDM (CBAM) maliyet hesaplayıcısını siteye kopyala / güncelle.

Hesaplayıcı ayrı bir depodadır (stochastic-cbam-engine, AGPL-3.0-or-later,
Selahattin İlhan). Site onun sabit bir sürümünü assets/cbam/ altında taşır:
dışarıdan betik yüklenmez (sitenin güvenlik kuralı) ve sitedeki sürüm hangi
commit'ten geldiğiyle birlikte kaydedilir.

Kullanım (proje kökünden):
    python _araclar/cbam-guncelle.py              # aracın main dalı
    python _araclar/cbam-guncelle.py v1.1.0       # etiket, dal ya da commit
    python _araclar/cbam-guncelle.py --yerel ../stochastic-cbam-engine

Kopyalanan: hesaplayici.js, cbam-motor.js, data/web/ (test dosyası ornekler.json
hariç) ve lisansın korunmasını şart koştuğu dosyalar: LICENSE, NOTICE,
LICENSE-ADDITIONAL-TERMS.md, CITATION.cff.
"""
import os
import shutil
import subprocess
import sys
import tempfile
from datetime import date

DEPO = "https://github.com/ilhanselahattin/stochastic-cbam-engine.git"
HEDEF = os.path.join("assets", "cbam")
DOSYALAR = ["hesaplayici.js", "cbam-motor.js", "LICENSE", "NOTICE",
            "LICENSE-ADDITIONAL-TERMS.md", "CITATION.cff"]
HARIC = {"ornekler.json"}


def calistir(*komut, **kw):
    return subprocess.run(komut, check=True, capture_output=True, text=True, **kw).stdout.strip()


def kopyala(kaynak, commit):
    if os.path.isdir(HEDEF):
        shutil.rmtree(HEDEF)
    os.makedirs(HEDEF)
    for f in DOSYALAR:
        shutil.copy2(os.path.join(kaynak, f), os.path.join(HEDEF, f))
    veri = os.path.join(kaynak, "data", "web")
    shutil.copytree(veri, os.path.join(HEDEF, "data", "web"),
                    ignore=lambda d, adlar: [a for a in adlar if a in HARIC])
    with open(os.path.join(HEDEF, "KAYNAK.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("SKDM (CBAM) maliyet hesaplayıcısı — stochastic-cbam-engine\n")
        f.write("Copyright (C) 2026 Selahattin İlhan · AGPL-3.0-or-later (bkz. LICENSE, NOTICE)\n")
        f.write(f"Kaynak kod: {DEPO.removesuffix('.git')}\n")
        f.write(f"Commit: {commit}\n")
        f.write(f"Kopyalandı: {date.today().isoformat()} (_araclar/cbam-guncelle.py)\n")
        f.write("Bu klasörü elle düzenlemeyin; değişiklikler aracın deposunda yapılır.\n")
    adet = sum(len(d[2]) for d in os.walk(HEDEF))
    print(f"assets/cbam: {adet} dosya, commit {commit[:12]}")


def main():
    if not os.path.exists("_quarto.yml"):
        sys.exit("Proje kökünden çalıştırın: python _araclar/cbam-guncelle.py")
    args = sys.argv[1:]
    if args[:1] == ["--yerel"]:
        kaynak = args[1]
        return kopyala(kaynak, calistir("git", "-C", kaynak, "rev-parse", "HEAD"))
    ref = args[0] if args else "main"
    with tempfile.TemporaryDirectory() as gecici:
        calistir("git", "clone", "--quiet", DEPO, gecici)
        calistir("git", "-C", gecici, "checkout", "--quiet", ref)
        kopyala(gecici, calistir("git", "-C", gecici, "rev-parse", "HEAD"))


if __name__ == "__main__":
    main()
