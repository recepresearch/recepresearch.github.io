# RECEP web sitesi — proje hafızası

> Her oturumun başında bu dosya okunur. Her önemli karar ve tamamlanan aşamadan sonra güncellenir.
> Son güncelleme: 2026-09-30 (v6: hoca geri bildirimi — grup odaklı yapı, projeler, sürüklenebilir küre, İstanbul)

## ✅ YAYIN DURUMU: AÇIK (2026-09-25 yeniden açıldı)

- **İÇERİK PANELİ (2026-10-24):** https://recepresearch.org/admin/ — Sveltia CMS 0.231.0 (unpkg, sürüm sabit), `admin/config.yml` + `admin/index.html` (`_quarto.yml` resources ile kopyalanır). Koleksiyonlar: `kayitlar` → `konferans-calistay/posts/<slug>/index.md` (Sveltia .qmd + frontmatter kabul etmiyor → .md; profillerde render listesine eklendi), `entries` → `conferences-workshops/posts/…` (EN). Alanlar: title, tur (konferans|calistay|duyuru), date, description, etkinlik-tarihi, yer, baglanti, image, draft, body. Bölüm sayfası `tur`a göre 3 listing (`include`). hero.lua `tur` olan sayfalara künye satırı ekler. Giriş: şimdilik GitHub token; OAuth için Cloudflare Worker (sveltia-cms-auth) + GitHub OAuth App kurulup `base_url` açılacak.
- **YTÜ ağı recepresearch.org adresini ENGELLİYOR** (403 "Yıldız Teknik Üniversitesi · Erişim Engellendi", HTTPS bağlantısı kesiliyor). Canlılığı yerelden değil check-host.net ile dışarıdan doğrula. Sertifika 2026-10-23 onaylandı, HTTPS zorunlu. Alan adı organizasyonda DOĞRULANDI (TXT `_github-pages-challenge-recepresearch` = de105fcf…; Cloudflare’den SİLME).
- **2026-10-23 ALAN ADI:** recepresearch.org (Cloudflare, ücretsiz plan, NS lilyana/sullivan). DNS: 4×A @ → 185.199.108-111.153, CNAME www → recepresearch.github.io, hepsi DNS only (gri bulut — turuncu yapma, sertifika bozulur). Pages cname API ile ayarlandı; Actions yayınında CNAME dosyası gerekmez. site-url/hero.lua/README → https://recepresearch.org/ .
- **2026-10-22 TAŞINMA (tamam):** depo `ContinentOfGrinch/recep` → `ilhanselahattin/recepresearch.github.io` → **`recepresearch/recepresearch.github.io`** (organizasyon, repo id 1383432016, kullanıcı admin). Canlı: **https://recepresearch.github.io/** (kök yol, `/recep/` yok). `site-url`, hero.lua `SITE`, README, `git remote` güncellendi. Eski adresler yönlendirilmez (404).

- 2026-09-25: kullanıcı isteğiyle kapatıldı (Pages silindi + publish iş akışı devre dışı), aynı gün tipografi v3 sonrası yeniden açıldı.
- **Kapatma:** `PUT .../actions/workflows/365129935/disable` + `DELETE .../pages` (CDN önbelleği ~10 dk içinde düşer).
- **Açma:** `PUT .../actions/workflows/365129935/enable` → `POST .../pages` `{"build_type":"workflow"}` → `POST .../actions/workflows/365129935/dispatches` `{"ref":"main"}` → Actions yeşil + canlı 200 kontrolü.
- GitHub dil çubuğu yalnızca SCSS/JS/EJS/CSS gösterir: `.qmd` (Quarto) ve `.yml` dosyaları Linguist tarafından dil olarak sayılmaz; `kure.js` (gömülü veri) üretilmiş dosya olarak dışlanır. Site yine de Quarto sitesidir; kullanıcıya açıklandı.

## ⚠ KESİN KURAL (kullanıcı, 2026-09-23)

**Kullanıcı bilgi verip onaylamadan kategorilerin (proje, ekip, çıktılar, veri ve kod, araçlar, haberler, iletişim) içine içerik YAZILMAZ.** Belgelerden özet, örnek veri, araç içeriği dahil. Sayfalar yalnızca iskelet: başlık + kullanıcının verdiği alt başlıklar + `.recep-bekliyor` kutusu ("içerik hazırlanıyor."). Önceden hazırlanmış içerikler `_taslaklar/` klasöründe (derlenmez, `_taslaklar/BENİOKU.md`); kullanıcı onaylarsa oradan geri taşınır. Tasarım/altyapı işleri serbest.

## 1. proje künyesi

- **Ne:** RECEP — *Çevre, Temiz Enerji ve Ekonomi Politikaları Araştırma Grubu* web sitesi.
- **Proje:** TÜBİTAK 1001, no **325K372** (dosya adından; doğrulanmalı). "AB SKDM'nin Türkiye Ekonomisine Etkileri: Sektörel Maliyet Yükü, Fiyat Etkileri ve Sosyo-Ekonomik Yansımaların Hibrit Girdi-Çıktı Modeli ile Analizi". Yürütücü Doç. Dr. Tunç Durmaz, YTÜ; ortak TÜİK; 24 ay; 4 iş paketi.
- **Yöntem (DİKKAT):** hibrit **Girdi-Çıktı (Leontief)** modeli + AB ithalat talep esneklikleri **2SLS** + mikro veri uydu hesapları. **Sistem GMM DEĞİL** (ilk oturumdaki varsayım yanlıştı, düzeltildi).
- **Kaynak belgeler (yerel, siteye konmaz):** `../1001_basvuru_formu_325K372R (1).pdf` (içerik kaynağı; bütçe/kişisel bilgi alınmadı), `../RECEP_Altyapi_ve_Web_Sitesi_Teklifi.docx`, `../skdm_toplantı.docx`, marka paketi `../Marka/logo_örnekleri/brand/` (svg, png, icons, src/globe.json).
- **Bütçe:** 0 TL. Açık kaynak + GitHub Pages + Actions.
- **GitHub:** https://github.com/recepresearch/recepresearch.github.io (public, `main`, organizasyon) → canlı: https://recepresearch.org/ (github.io adresi buraya yönlenir). Pages kaynağı = GitHub Actions. İleride Tunç Durmaz / lab organizasyonuna devredilecek (README'de adımlar).
- **Araçlar:** Quarto 1.10.18 (yerel = CI), R 4.5.1, Node 24. `gh` CLI yok → GitHub API için `git credential fill` token'ı + curl (Türkçe JSON → `--data-binary @dosya.json`).

## 2b. TASARIM v5 — küre ana sayfa + 1-bit "art canvas" hero (2026-09-26, GÜNCEL; 2a'daki filigran/görsel/ana sayfa maddelerinin YERİNE geçer)

Kullanıcı: soluk filigran "yıkanmış, silik" — Digital Brutalism / Post-Internet Art, "yüksek sınıf dijital sanat galerisi" istiyor. Ana sayfa diğerlerinden farklı olmalı.
- **Ana sayfa (`.recep-khero`, hero.lua `kureHero`):** ortada dönen büyük küre (`.recep-kure`, `min(56vh,540px,86vw)`, çerçevesiz), altında "recep" Inter 900, grup adı Lora italik, `lat 39.0 · lon 35.2 · ● türkiye` Space Mono. Altında butonlar + 7 kart.
- **Alt sayfalar (`.recep-dhero`):** sütun genişliğinde (max 64rem) TAM OPAK tuval; bölüm index 16:9 (`buyuk`), alt sayfa 21:9 (`orta`). Üstte meta satırı (`/yol` · `1-bit · 720×405`), altta açıklama (Lora) + künye (sağda, Space Mono).
- **1-bit görseller:** `assets/sanat/*.png` 720×405, Atkinson dither, kaynaktan 16:9 kırpma. Betik: scratchpad `sanat/dither2.html` + `dither2-surucu.mjs` (parametreler: genişlik, kontrast, parlaklık, cx, cy, yakınlaştırma). Vitruvius `2.4, 30, .5, .33, 1.06` (yakınlaştırma = kenardaki siyah şeritleri atar). WebP'ler SİLİNDİ.
- **Renk:** img `grayscale(100%) contrast(200%)`, `image-rendering: pixelated`, `mix-blend-mode` tuval zemini ile: açık `#0033FF` + `screen` (kobalt/beyaz), gece `#ECEAE4` + `multiply` (zifiri/kırık beyaz). Değişkenler `$recep-tuval-zemin`, `$recep-tuval-karisim`.
- **Başlık:** sol alt köşeye demirli, `translateY(--baslik × .42)` ile tuvalden taşar; `<span>` zemin renginde levha (`box-decoration-break: clone`). Boyut container query: `--baslik` buyuk `clamp(3.2rem,14cqi,9rem)`, orta `clamp(2.6rem,9cqi,6rem)`. Açıklama boşluğu `--baslik × .56 + 1.25rem`.
- **araçlar = pacioli.png** (2026-09-26): tablo 1,2:1, kullanıcı polihedron + masadaki aletlerin tam görünmesini ve 859×483 tuvali istedi → kırpılmadan 580×483 dither, siyah 859×483 tuvale sağa yaslı. `sabit = true` (alt sayfada da 16:9), `hero-meta` "> DIR_PACIOLI.exe // CALC_ENGINE_NODE". Aynı işte düzeltildi: başlık levhası artık h1 üzerinde tek blok (çok satırda satır zeminleri harfleri örtüyordu); alt sayfada `max-width: 64%`; kenar çubuklu sayfalarda (sütun ≈809 px) ince görseller yumuşak ölçeklenir.
- **araçlar düzeltmesi** (2026-09-26): kullanıcı soldaki siyah boşluğu "bozuk" buldu → Pacioli artık 16:9 kırpım (cy .44, yüzler + polihedron tam, masa kesik), tuvali doldurur. Araç kartları ve alt sayfalarda `.recep-durum` terminal satırları (Space Mono; ilk satır mavi, diğerleri %50 mürekkep): `> STATUS: İÇERİK HAZIRLANIYOR...` / `// MODULE_IN_DEVELOPMENT` / `[VERİ_SETİ_ENTEGRASYONU_BEKLENİYOR]` — kullanıcının verdiği birebir dizeler. Markdown'da `>` ve `...` kaçışı şart (yoksa blockquote ve … olur). Bash/sed/heredoc ters eğik çizgiyi yutuyor → bu tür düzenlemeleri Edit ile yap.
- **veri ve kod = codex.png** (2026-09-26): Codex Atlanticus f. 26v, 16:9 + 1,35× yakınlaştırma, tonlar ters (kâğıt siyah, mürekkep ışık), seviye 62–165, 859×483 ince FS; `hero-meta` "> DIR_DAVINCI.exe // OPEN_SOURCE_MANUSCRIPT". elciler.html'e `ters`, `siyah`, `beyaz`, `yak` parametreleri eklendi. Vitruvius artık hiçbir sekmeye bağlı değil.
- **ekip = athens.png yenilendi** (2026-09-26): 859×483 ince FS, 1,2× yakınlaştırma, cy .58, gama 1,45 (açık fresk ilk denemede yıkanmış çıktı). `hero-meta` "> DIR_ATHENS.exe // RESEARCH_SYNDICATE_NODE". Kullanıcı "mavi-beyaz eski açık tema" dedi: bu, tarayıcısında AÇIK temanın seçili olmasından (tuval açık temada kobalt/beyaz). Açık temayı kaldırmak ya da tuvali her iki temada koyu yapmak kullanıcıya soruldu.
- **ÇİFT DİL (2026-09-26):** Quarto profilleri. `_quarto.yml` ortak (tema, filtre, küre + dil seçici betikleri, `profile: default: tr`), `_quarto-tr.yml` (lang tr, _site/, TR menü/sidebar/footer, render listesi), `_quarto-en.yml` (lang en, _site/en/, EN menü). EN kaynaklar ayrı klasörlerde: about (=hakkımızda), project, team, outputs, data-code, tools, news, contact + `index.en.qmd` (`output-file: index.html`). Kullanıcı kararları: hakkımızda→about, proje→project; EN iskelet + hakkımızda/proje metinlerinin çevirisi; dil seçici Space Mono (JetBrains Mono DEĞİL); ana sayfa küre ortada kalır. hero.lua: `CEVIRI` tablosu (tr↔en kaynak yolu) → `<meta name="recep-ceviri">` + hreflang; `kunye_en`; EN klasörleri SEKME'de. Seçici (_quarto.yml include-after-body JS) navbar sağ kenarı (right 3.6rem, aramanın solu), <1200 top 34px right 6.2rem, <640 px açılır menünün altında (kopya `.recep-dil--menu`). Stil: #05080D zemin, #39FF14 metin/çerçeve, aktif dil dolu yeşil, radius 0. Şablonlar `templateParams.dil`. TUZAK: `resources` desenleri `/` ile köke sabitlenmeli (yoksa EN derlemesi _site/assets'i _site/en/_site'a kopyalar). CI: Render (tr) → `quarto render --profile en` → lychee. Derleme sırası: tr SONRA en.
- **v6 — HOCA GERİ BİLDİRİMİ (2026-09-30):** site tek projeye değil gruba (RECEP) ait. Menü (8 öğe, ≥1400 px tek satır; altı hamburger — `collapse-below: xxl`, theme.scss kırılımları 1400/1399.98): SOL hakkımızda · projeler · araştırmacılar · çıktılar | SAĞ araçlar · veri ve kod · konferans ve çalıştaylar (iki satır, max-width 8.4em) · iletişim. EN: about · projects · researchers · outputs | tools · data & code · conferences & workshops · contact. Haberler → konferans-calistay (duyurular orada). Taşımalar (git mv): proje/ → projeler/skdm/, ekip/ → arastirmacilar/, haberler/ → konferans-calistay/; EN project/ → projects/cbam/, team/ → researchers/, news/ → conferences-workshops/. Eski adresler `aliases` ile yönlenir (Windows yerel derlemede yönlendirme yolu ters eğik çizgili; CI Linux'ta düzgün). projeler/index: "güncel projeler" (tübitak 1001 — skdm projesi, adep, cetp intact) + "geçmiş projeler" (hazırlanıyor). ADEP ve CETP INTACT yalnızca başlık — METİNLERİ KULLANICI GÖNDERECEK; hangi projenin güncel/geçmiş olduğu kullanıcıya teyit ettirilecek. Footer'dan tübitak bağlantısı kalktı → "yıldız teknik üniversitesi". Ana sayfa: 8 kart, butonlar hakkımızda · projeler · araçlar.
- **Küre v6:** Yükleyici `kure.js?v=6` sürüm etiketiyle çağrılır (_quarto.yml include-after-body) — kure.js her değiştiğinde ARTIR; aksi halde Pages 10 dk önbellek yüzünden kullanıcı eski betiği görür (kullanıcı "etkileşim yok" dedi, sebep buydu). kırmızı nokta İSTANBUL (28.98°D, 41.01°K; hoca "başkent doğuya kaymış" dedi), EGIM 30, koordinat satırı "lat 41.01 · lon 28.98 · ● istanbul". Büyük küre `min(66vh, 660px, 94vw)`, sürüklenebilir (`surukle: true`): sol tık / dokunma (touch-action pan-y → dikey kaydırma sayfada kalır) / ok tuşları; yatay = boylam, dikey = eğim (±80°), küre YERİNDE kalır; bırakınca atalet (τ≈450 ms), sonra eğim varsayılana döner ve otomatik dönüş sürer. Navbar küresi etkileşimsiz. Test: scratchpad `surukle-test.mjs` (CDP fare olayları).
- **PROJE İÇERİĞİ (2026-09-30, kullanıcı onayıyla hocanın sitesinden):** kaynak https://www.tuncdurmaz.com/ (Projects/About/Contact). Üç proje de sitede "Forthcoming" → etiket "yakında başlıyor" / "forthcoming" (.recep-tag--yakinda). TÜBİTAK 1001 tam adı, ADEP (AI-DIO, 2035 projeksiyonu), INTACT (CETPartnership / Horizon Europe & TÜBİTAK; hoca İP6 lideri + YTÜ yürütücüsü; INTACT-RISKAID açıklaması). Künye: .recep-proje-kunye tanım listesi. Hoca artık PROF. DR. (eski Doç. bilgisi eskidi); data/ekip.yml’ye yürütücü olarak eklendi (kurum YTÜ İktisat, alan, web, scholar; e-posta sitede açık yazmıyor → eklenmedi). ekip.yml’de *_en alanları (unvan_en, kurum_en, alan_en) → EN şablon. EKLENMEDİ (hocanın kişisel rolleri, grup projesi değil): TRANSMIT COST Action WG1 eş liderliği (2025–), TTGV Climate Lab, 12. Kalkınma Planı SBB raportörlüğü — kullanıcıya soruldu.
- **GitHub bağlantıları kaldırıldı (2026-10-02, kullanıcı isteği):** navbar tools (github simgesi), footer github simgesi (tr/en), repo-url + repo-actions (düzenle / sorun bildir) silindi. Siteden depoya hiçbir bağlantı yok; TEKRAR EKLEME. Tema düğmesi navbar sol üstte tek başına.
- **haberler + iletişim = ambassadors.png** (2026-09-26): Merkür kolajı "çok kötü" → geri alındı (10fe6ef). Tam tablo denendi, "çok dik" bulundu → iletişimdeki gibi 16:9 alttan kırpım (cy .36). Görsel ince taneli Floyd–Steinberg, **859×483 = tuval genişliği** (1:1, retinada 2×), sert eşik yok, çok hafif tarama satırı kayması. ESER alanları `w`, `h`, `ince = true` (→ `.recep-dhero--ince`, 1280 px altında yumuşak ölçekleme). Betik scratchpad `sanat/elciler.html`, `elciler-surucu.mjs`, `e3.json`. Ders: 1-bit görseli ekrandaki boyutuyla birebir üret; küçültme moiré yapar. Mobil testi deviceScaleFactor 3 ile yap (1× yanıltıcı derecede sert görünür).
- **`hero-meta`** front matter: tuval üstündeki sol etiketi ezer, neon yeşil, büyük harf korunur. Başında `>` varsa YAML tek tırnak + `\>` kaçışı gerekir (yoksa pandoc blockquote sayıp siler).
- **Navbar küresi:** Quarto `.navbar-logo { padding-right: 4px }` + border-box küreyi yumurtaya çeviriyordu → `padding:0; flex-shrink:0; aspect-ratio:1/1`. Boyut artık CSS'ten okunur (42/36 px), küçük kürede 2× süper örnekleme.

## 2a. TASARIM v4 — "Elegant Cyber-Renaissance / High-End Editorial Brutalism" (2026-09-25; filigran/görsel/ana sayfa maddeleri 2b ile DEĞİŞTİ)

Kullanıcı: önceki neon kutular, pikselli yeşil çerçeveler, glitch/tarama çizgisi ve "REC" terminal pencereleri "ucuz ve ürkütücü". **Tüm site** zarif, çerçevesiz dile geçirildi (Nous AI / Hermes-Agent estetiği).

- **YASAK:** neon kutular/çerçeveler, tarama çizgisi, glitch, "REC", L köşe/nişangah, terminal pencere çerçeveleri, `#`/`$`/`>` terminal önekleri, ofsetli neon gölgeler. Neon yeşil yalnızca logodaki `[recep]` parantezlerinde ve küre çizgilerinde kalır.
- **DynamicHero** = Quarto filtresi `_extensions/recep/hero/hero.lua` (`_quarto.yml` → `filters: [hero]`). Her HTML sayfasının başına `<section class="recep-dhero">` ekler; sayfa klasöründen sekmeyi bulur, eseri otomatik seçer:
  ana/ekip/404 → athens · haberler/iletisim → ambassadors · veri-kod/araclar → vitruvian · proje/ciktilar → adam (odak: eller, `38% 46%`).
  Başlık `title` (veya `hero-baslik`), alt satır `description`. Ayarlar: `hero: false`, `hero-eser`, `hero-boyut: tam|buyuk|orta` (varsayılan: ana=tam, index=buyuk, alt sayfa=orta). Görsel yolu `quarto.project` derinliğinden hesaplanır (raw HTML); 404'te Quarto mutlak yola çevirir.
- **Filigran CSS:** `.recep-dhero-sanat` absolute, `left:50%; width:100vw; translateX(-50%)`, flex ortalı, `z-index:0`; img `grayscale(100%)`, açık: `opacity .15` + `multiply`; gece: `opacity .14` + `screen`; Vitruvius (krem kâğıt) gece temasında `invert(1) contrast(1.25)` (`$recep-art-kagit`) — yoksa açık dikdörtgen kutu gibi görünüyordu. Kenarlar radyal maskeyle tamamen erir: `ellipse 60% 58%`, `#000 22% → transparent 82%` (yarıçap × son durak < %50 olmalı, yoksa kutu kenarı görünür). `body { overflow-x: clip }`. Sidebar zemini `transparent` (yoksa filigranı dikey kesiyordu). `body:has(.recep-dhero) #title-block-header { display:none }`.
- **Başlık:** Inter 900, `-0.06em`, `line-height .86`, küçük harf, ortalı; tam `clamp(4.5rem,17vw,14rem)`, büyük `clamp(3.4rem,11vw,9.5rem)`, orta `clamp(2.6rem,7vw,6rem)`. Açıklama Lora italik. Yol satırı (`/proje`) Space Mono (ana sayfada gizli). Künye sağ altta Space Mono .62rem, küçük harf.
- **Görseller:** `assets/sanat/*.webp` — yüksek çözünürlüklü Commons asıllarından headless Edge canvas ile küçültme + gri tonlama + WebP (167–368 KB). Betikler scratchpad `sanat/webp.html`, `sanat/webp-surucu.mjs`. Kaynaklar `assets/sanat/KAYNAK.md`. ArtWindow bileşeni ve 1-bit PNG'ler SİLİNDİ.
- **Tipografi v4:** Katman 1 Inter 900 → YALNIZCA dev sayfa başlıkları (DynamicHero) + logo. Katman 2 Lora → h2–h6 dahil TÜM alt başlıklar (500, küçük harf), gövde, açıklamalar. Katman 3 **Space Mono** 400/700 (JetBrains Mono kaldırıldı) → navbar, sidebar, TOC, breadcrumb, meta, butonlar, footer, kod.
- **Bileşenler:** kart ızgarası kutusuz (yalnızca üst saç çizgisi, hover'da koyulaşır, başlık Lora 1.45rem); butonlar Space Mono büyük harf, saç çizgisi kenar, hover'da ters dolgu (birincil: dolu); `.recep-bekliyor` = ortalı Lora italik "— içerik hazırlanıyor. —" (kutu yok); navbar aktif öğe = ince alt çizgi (kutu yok).
- **Palet v4:** gece metin `#ECEAE4`, soluk `#8E918F`, çizgi `rgba(236,234,228,.12)`, bağlantı yumuşak mavi `#7FC8F8`; açık soluk `#55524B`, çizgi `rgba(10,10,10,.12)`.
- **Ana sayfa:** hero = Atina Okulu + dev "recep" + grup adı; altında butonlar + 7 bölüm kartı. Önceki büyük küre kutusu kaldırıldı (neon çerçeve yasağı); küre navbar logosunda dönmeye devam ediyor.

## 2. tasarım manifestosu v2 (ESKİ — navbar/küre/palet temeli hâlâ geçerli; görsel dil için 2a v4 esastır)

- **Dil:** "bilimsel brutalizm" + siberpunk/terminal. Tüm köşeler keskin (`border-radius: 0`, `$enable-rounded: false` + global `*{border-radius:0!important}`).
- **Palet — gece (VARSAYILAN):** zemin #05080D, metin #E6EDF3, soluk #8B98A5, çizgi #1C2633, yüzey #0B111A, **neon yeşil #39FF14**, **elektrik mavi #00A3FF**.
- **Palet — açık:** bkz. 2a (kırık beyaz #F4F2EC, zifiri #0A0A0A); yeşil **#12A12F**, mavi **#0077CC**.
- **Navbar (v3, kullanıcı düzeltmesi):** **tek satır, bölünmüş:** SOL `proje · ekip · çıktılar` | MERKEZ [küre + [recep]] | SAĞ `veri ve kod · araçlar · haberler · iletişim`. Alt alta YOK, logo solda YOK. Her iki temada #05080D, sabit (`pinned` + `z-index: 9999`). ≥1200px: `.navbar-collapse{display:contents}` + grid `1fr auto 1fr`; Quarto `left:`→`.me-auto`, `right:`→`.ms-auto`. GitHub+tema düğmesi sol kenarda, arama sağ kenarda (mutlak). <1200px (`collapse-below: xl`): [menü düğmesi | marka | tema+arama], menü aşağı açılır.
- **Logo/küre:** `assets/js/kure.js` — **gerçekten dönen wireframe dünya** (canvas, kütüphanesiz ortografik izdüşüm, Natural Earth 110m kıyı çizgileri neon yeşil, 20° ağ elektrik mavi), **Türkiye'de (35.2E, 39.0N) yanıp sönen neon kırmızı nokta + radar halkası** (#FF1F4B), küreyle birlikte döner, arka yüzde gizlenir. Eğim 24° (kuzeyden). Navbar'da `.navbar-logo` img → 46px canvas (hız 0.018°/ms); hero'da `.recep-kure` (hız 0.006, dış kesikli halka ters döner, renkler CSS değişkenlerinden `--recep-yesil/mavi/kirmizi/zemin`). JS yoksa yedek: `amblem-nav.svg` / `amblem-koyu.svg`. `prefers-reduced-motion` → tek kare. IntersectionObserver ile görünmezken durur.
- **Küre derleme:** kaynak `assets/js/kure.src.js`; veri `assets/js/kaynak/kara-110m.json`; `node assets/js/kaynak/kure-derle.mjs assets/js/kure.src.js assets/js/kaynak/kara-110m.json assets/js/kure.js`. Yükleyici `_quarto.yml` `include-after-body` içinde, `<meta name="quarto:offset">` ile her derinlikte doğru yol.
- [recep] metni **Inter 900** (marka kelime işaretine en yakın), köşeli parantezler CSS kenarlıklarıyla kalın kare çizgi.
- **Çerçeveler:** kart ızgarası, butonlar, şeritler `$recep-frame` (gece #00A3FF / açık #0077CC); birincil buton ve hero küre çerçevesi neon yeşil; hero'da terminal ızgarası + mavi köşe imleri.
- **Gece varsayılanı garantisi (2026-09-26 güncel):** kullanıcı "ana mod koyu, açık mod yukarıdan seçilebilen seçenek" istedi. `include-in-header` betiği her yeni tarayıcı oturumunun ilk sayfasında (`sessionStorage` `recep-oturum` bayrağı yoksa) Quarto'nun kalıcı `quarto-color-scheme` kaydını siler ve gerekirse sayfayı yeniler → site HER ZAMAN gece açılır; düğmeyle seçilen açık tema yalnızca o oturumda (sayfalar arası, tr/en dahil) korunur. Yeni sekme = yeni oturum → gece. Eski `recep-tema=v2` bayrağı kaldırıldı. Not: temiz tarayıcıda gece varsayılanı zaten çalışıyordu; kullanıcının açık görmesi eski kalıcı tercihindendi. Test: scratchpad `oturum-test.mjs` (CDP Target.createTarget ile yeni sekme).
- **Tipografi:** bkz. 2a (3 katman: Inter 900 · Lora · JetBrains Mono). Başlıklar küçük harf. h2 önüne `# ` (yeşil), h3 önüne `## ` (mavi); `.no-prefix` ile kapatılır.
- **Etkileşim dili:** hover'da `translate(-2px,-2px)` + `4px 4px 0` neon gölge (brutalist), kartlarda alttan dolan neon çizgi.

## 3. site mimarisi (kalıcı adresler)

**Kategoriler İSKELET (içerik bekliyor); İSTİSNA: hakkımızda (kullanıcı metni, 2026-09-26) ve proje/index açıklaması (kullanıcı, f951b19).**

| menü | adres | alt kategoriler (sayfa) | altyapı |
|---|---|---|---|
| hakkımızda | /hakkimizda/ | tek sayfa; metin kullanıcıdan birebir (yazım hataları dahil, kullanıcıya bildirildi) | eser syndics (Rembrandt); `hero-meta` terminal etiketi; `.recep-metin` Lora okuma bloğu; navbar SOL başta (4 · logo · 4) |
| proje | /proje/ | amac-kapsam, yontem, is-paketleri, tubitak | sidebar |
| ekip | /ekip/ | yürütücü, araştırmacılar, danışmanlar, bursiyerler (tek sayfa, gruplar) | `data/ekip.yml` (boş, `rol: yok` yer tutucu) + `_templates/ekip.ejs` |
| çıktılar | /ciktilar/ | politika-notlari, tebligler-makaleler, sunumlar | `data/ciktilar.yml` (`bolum` ile süzülür) + `_templates/ciktilar.ejs` |
| veri ve kod | /veri-kod/ | uyumlastirma-anahtarlari (NACE–ISCO–GTİP), veri-setleri, analiz-kodlari | sidebar |
| araçlar | /araclar/ | skdm-hesaplayici, karbon-fiyati | sidebar; OJS altyapısı `_taslaklar/araclar/` içinde hazır |
| haberler | /haberler/ | duyurular, etkinlikler, çalıştay haberleri (kartlar) | ilk haberde listing + RSS açılacak (`_taslaklar/haberler/index.qmd` şablon); `haberler/posts/_metadata.yml` hazır |
| iletişim | /iletisim/ | e-posta, adres, sosyal medya bağlantıları (kartlar) | — |

- Sidebar: proje, ciktilar, veri-kod, araclar → `- auto: <klasör>`, sıra `order` alanıyla; bölüm index'i `order: 0`.
- İskeletler `scratchpad/iskelet.mjs` ile üretildi (yeniden gerekmez).
- RSS bağlantıları navbar/footer'dan kaldırıldı (haber yokken kırık olurdu); ilk haberle geri eklenecek.

## 4. teknik kararlar ve tuzaklar

| konu | karar / tuzak |
|---|---|
| Tema sırası | `format.html.theme` içinde **dark önce** → varsayılan gece; `respect-user-color-scheme: false`. |
| OJS tema izleme | `Generators.observe` + MutationObserver(body.class). **Yalnızca değer değişince notify et** — aksi halde Quarto'nun body sınıfı değişiklikleri sonsuz yeniden çizim döngüsü yaratır. |
| OJS + file:// | OJS sayfaları `file://` ile headless tarayıcıda **donar** (modül yükleme). Test için yerel HTTP sunucusu: `node scratchpad/sunucu.mjs _site` (port 4321, `/recep/` önekini soyar). Canlıda sorun yok. |
| Grafikler | Observable Plot, tek seri (kategorik palet gerekmez), `tip` ile hover, `Inputs.table` ile tablo görünümü; paletler JS'te iki tema için sabit. dataviz validator: açık palet PASS; gece neon "lightness band" FAIL yalnızca kategorik çiftte geçerli, tek seride sorun değil. |
| SKDM geçiş takvimi | pay = ücretsiz tahsisin kaldırılma oranı: 2026 %2,5 · 2027 %5 · 2028 %10 · 2029 %22,5 · 2030 %48,5 · 2031 %61 · 2032 %73,5 · 2033 %86 · 2034 %100. |
| Temsili veriler | Hesaplayıcı emisyon yoğunlukları ve ETS yıllık ortalamaları **yaklaşık/temsili**; sayfalarda uyarı var; resmi kaynakla değiştirilecek. |
| Marka SVG'leri | C2PA meta verisi soyularak (`scratchpad/amblem.mjs`) `assets/marka/` altına alındı: amblem-nav/koyu/acik (animasyonlu), recep-yatay-koyu/acik (svg+png), apple-touch-icon; `assets/favicon.svg`, `assets/og.png` (1200×630, marka paketinden). |
| Footer linki | Proje kökü mutlak yol: `/proje/tubitak.qmd` (göreli yazılırsa alt sayfalarda kırılır). |
| EJS | Şablonlar ```` ```{=html} ```` içinde; listing verisi `_` klasöründe olamaz (`data/`). Listing `include: {bolum: ...}` ile süzme çalışıyor. |
| Fontlar | self-host woff2 (Inter değişken 100–900 → logo için 900 kullanılıyor). |
| Bash | `python` çağırma (Store alias, takılır). Heredoc'ta Türkçe kesme işaretli uzun metinler bazen kabuğu bozuyor → Write aracı kullan. |

## 5. doğrulama yöntemi

- `rm -rf _site && quarto render` → uyarısız olmalı.
- Ekran görüntüsü: headless Edge, her çağrıda **ayrı `--user-data-dir`**, `--virtual-time-budget=6000`. OJS sayfaları için HTTP sunucusu şart. Açık tema: sayfada `localStorage.setItem("quarto-color-scheme","alternate")` sonrası yönlendirme.
- Headless minimum genişlik ~481px.

## 6. tamamlanan aşamalar

- [x] Aşama 1–2 (2026-09-23): ilk iskelet, altyapı, CI (render + lychee + Pages), self-host fontlar, repo + ilk yayın.
- [x] Aşama 3 (2026-09-23): **yeniden tasarım** — manifesto v2 paleti, iki satırlı ortalanmış navbar + animasyonlu marka amblemi, 7 bölümlü yeni bilgi mimarisi, başvuru formundan proje içeriği, ekip verisi, SKDM hesaplayıcısı ve karbon fiyatı paneli (OJS), GTİP→NACE taslak anahtar, R Leontief demosu, iş-zaman çizelgesi. Gece/mobil/araç sayfaları ekran görüntüsüyle doğrulandı.

- [x] Aşama 4 (2026-09-23, kullanıcı düzeltmesi): bölünmüş tek satır navbar + merkez logo; canvas tabanlı gerçekten dönen wireframe küre + Türkiye'de yanıp sönen kırmızı nokta (navbar + hero); neon çerçeveler; gece varsayılanı sıfırlama betiği; tüm kategoriler iskelete çevrildi, içerikler `_taslaklar/`'a taşındı. Dönüş CDP ile gerçek zamanlı doğrulandı (3 sn arayla kare özetleri farklı).

## 7. açık işler / TODO

- [x] Aşama 3 commit `c5d83f9` + push; Actions başarılı; canlıda 13 adres 200, araçlar çalışıyor. Açık tema, ekip ve mobil ekran görüntüleriyle doğrulandı (açık temada amblem-acik'in gri arka plan kutusu kaldırıldı).
- [ ] Kullanıcıdan doğrulanacaklar: proje no 325K372, başlangıç tarihi, ekip listesinin yayımlanma onayı, kurumlar (Avşar, Arı, Demir), iletişim e-postası ve adres.
- [ ] Temsili verileri resmi kaynaklarla değiştir: ETS yıllık ortalamaları (ICAP/EEX), SKDM varsayılan emisyon değerleri.
- [ ] GTİP→NACE anahtarını Ek I alt pozisyon istisnalarıyla doğrula.
- [ ] İngilizce sürüm (tablo: About, Team, Outputs, Data & Code, Tools, News, Contact) — Quarto profilleri veya `/en/` alt ağacı ile; henüz başlanmadı.
- [ ] `renv` ile R paketlerini kilitle (R içeriği büyüyünce).

- **Doğrulama notu:** headless tarayıcıda `--virtual-time-budget` requestAnimationFrame'i ilerletmez (4 sn'de 6 kare). Animasyon kontrolü için `scratchpad/cdp.mjs` (Edge `--remote-debugging-port=9333` + Node WebSocket, gerçek zamanlı ölçüm ve ekran görüntüsü). Headless Edge'i kapatırken genel `taskkill /IM msedge.exe` KULLANMA (kullanıcının tarayıcısını etkileyebilir); yalnızca `edge-cdp` profilli süreçleri hedefle.
- **Kabuk notu:** `node -e '...'` içinde tek tırnaklı JS dizeleri kabukta düşer → tırnak içeren düzenlemeleri Edit/Write ile yap.

## 8. sıradaki adım

**Kullanıcının kategori bilgilerini göndermesini bekle.** Gelen her bilgiyi yalnızca ilgili kategoriye işle; `_taslaklar/` içeriğini ancak kullanıcı onaylarsa kullan. Bekleme sürecinde yalnızca tasarım/altyapı işleri yapılabilir.
