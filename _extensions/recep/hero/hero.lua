--[[
  recep · sayfa başlığı filtresi (DynamicHero)

  Her HTML sayfasının en üstüne otomatik bir başlık alanı ekler:
    · ana sayfa   → KÜRE HERO: ortada dönen wireframe dünya (assets/js/kure.js),
                    altında "recep" (Inter 900), grup adı (Lora), koordinat (Space Mono)
    · diğer sayfalar → ART CANVAS HERO: sütun genişliğinde, tam opak, 1-bit dither
                    Rönesans eseri; dev başlık (Inter 900) tuvalin SOL ALT köşesine
                    demirli, tuvalden taşarak zemine biner. Altında açıklama (Lora).
  Eser, sayfanın bulunduğu klasörden (sekmeden) OTOMATİK seçilir; sayfalarda ek kod gerekmez.

  Front matter ile ayar (hepsi isteğe bağlı):
    title          → başlık            description → alt satır (Lora)
    hero: false    → bu sayfada kapat  hero-eser: athens|ambassadors|vitruvian|adam|syndics|pacioli|codex
    hero-baslik    → başlığı ez        hero-boyut: buyuk (16:9) | orta (21:9)
    hero-meta      → tuvalin üstündeki sol etiketi ez (Space Mono, neon; varsayılan: /yol)

  Çift dil (_quarto-tr.yml / _quarto-en.yml): dil front matter'daki `lang` alanından okunur.
  Her sayfaya karşı dildeki eşinin adresi yazılır (<meta name="recep-ceviri"> + hreflang);
  navbar'daki tr / en seçicisi bu adresi kullanır (_quarto.yml → include-after-body).
]]

-- eser → dosya (1-bit PNG; w/h verilmezse 720×405), odak noktası ve künye.
-- ince = true: tuval genişliğinde (859 px) üretilmiş ince taneli dither; dar ekranda yumuşak ölçeklenir
-- sabit = true: alt sayfalarda da 16:9 kalır (21:9 kırpım yüzleri keserdi)
local ESER = {
  athens      = { dosya = "athens.png",      odak = "50% 50%", w = 859, h = 483, ince = true, kunye = "raphael — atina okulu, 1509–1511",
                  kunye_en = "raphael — the school of athens, 1509–1511" },
  ambassadors = { dosya = "ambassadors.png", odak = "50% 50%", w = 859, h = 483, ince = true, kunye = "hans holbein (genç) — elçiler, 1533",
                  kunye_en = "hans holbein the younger — the ambassadors, 1533" },
  vitruvian   = { dosya = "vitruvian.png",   odak = "50% 30%", kunye = "leonardo da vinci — vitruvius adamı, y. 1490",
                  kunye_en = "leonardo da vinci — vitruvian man, c. 1490" },
  adam        = { dosya = "adam.png",        odak = "50% 42%", kunye = "michelangelo — adem'in yaratılışı, y. 1508–1512",
                  kunye_en = "michelangelo — the creation of adam, c. 1508–1512" },
  syndics     = { dosya = "syndics.png",     odak = "50% 50%", kunye = "rembrandt — kumaşçılar loncası yöneticileri, 1662",
                  kunye_en = "rembrandt — the syndics of the drapers' guild, 1662" },
  codex       = { dosya = "codex.png",       odak = "50% 50%", w = 859, h = 483, ince = true,
                  kunye = "leonardo da vinci — codex atlanticus, f. 26 verso",
                  kunye_en = "leonardo da vinci — codex atlanticus, f. 26 verso" },
  pacioli     = { dosya = "pacioli.png",     odak = "50% 50%", w = 859, h = 483, ince = true, sabit = true,
                  kunye = "jacopo de' barbari (atf.) — luca pacioli portresi, 1495",
                  kunye_en = "jacopo de' barbari (attr.) — portrait of luca pacioli, 1495" },
}

-- sekme (klasör) → eser
local SEKME = {
  arastirmacilar = "athens", ["404"] = "athens",
  ["konferans-calistay"] = "ambassadors", iletisim = "ambassadors",
  ["veri-kod"] = "codex", araclar = "pacioli",
  projeler = "adam", ciktilar = "adam",
  hakkimizda = "syndics",
  -- İngilizce klasörler (_quarto-en.yml)
  researchers = "athens", ["conferences-workshops"] = "ambassadors", contact = "ambassadors",
  ["data-code"] = "codex", tools = "pacioli",
  projects = "adam", outputs = "adam", about = "syndics",
}

-- Türkçe kaynak ↔ İngilizce kaynak (proje köküne göre, uzantısız). Yeni sayfa eklerken buraya da ekleyin.
local CEVIRI = {
  ["index"] = "index.en",
  ["hakkimizda/index"] = "about/index",
  ["projeler/index"] = "projects/index",
  ["projeler/skdm/index"] = "projects/cbam/index",
  ["projeler/skdm/amac-kapsam"] = "projects/cbam/aims-scope",
  ["projeler/skdm/yontem"] = "projects/cbam/methodology",
  ["projeler/skdm/is-paketleri"] = "projects/cbam/work-packages",
  ["projeler/skdm/tubitak"] = "projects/cbam/tubitak",
  ["projeler/adep"] = "projects/adep",
  ["projeler/cetp-intact"] = "projects/cetp-intact",
  ["arastirmacilar/index"] = "researchers/index",
  ["ciktilar/index"] = "outputs/index",
  ["ciktilar/politika-notlari"] = "outputs/policy-briefs",
  ["ciktilar/tebligler-makaleler"] = "outputs/working-papers",
  ["ciktilar/sunumlar"] = "outputs/presentations",
  ["veri-kod/index"] = "data-code/index",
  ["veri-kod/uyumlastirma-anahtarlari"] = "data-code/concordance-keys",
  ["veri-kod/veri-setleri"] = "data-code/datasets",
  ["veri-kod/analiz-kodlari"] = "data-code/analysis-code",
  ["araclar/index"] = "tools/index",
  ["araclar/skdm-hesaplayici"] = "tools/cbam-calculator",
  ["araclar/karbon-fiyati"] = "tools/carbon-price",
  ["konferans-calistay/index"] = "conferences-workshops/index",
  ["iletisim/index"] = "contact/index",
}
local TERS = {}
for tr, en in pairs(CEVIRI) do TERS[en] = tr end

local SITE = "https://recepresearch.org/"

local function kacis(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function yazi(v)
  if v == nil then return nil end
  local s = pandoc.utils.stringify(v)
  if s == "" then return nil end
  return s
end

-- proje köküne göre göreli yol: "projeler/skdm/index.qmd" → { "projeler", "skdm", "index" }
local function konum()
  local girdi = (quarto.doc.input_file or ""):gsub("\\", "/")
  local kok = ((quarto.project and quarto.project.directory) or ""):gsub("\\", "/")
  local rel = girdi
  if kok ~= "" and girdi:sub(1, #kok) == kok then rel = girdi:sub(#kok + 2) end
  local parcalar = {}
  for p in rel:gmatch("[^/]+") do table.insert(parcalar, p) end
  local dosya = (parcalar[#parcalar] or ""):gsub("%.qmd$", ""):gsub("%.md$", "")
  local derinlik = #parcalar - 1
  local sekme
  if derinlik == 0 then
    sekme = (dosya == "index" or dosya == "index.en") and "ana" or dosya
  else
    sekme = parcalar[1]
  end
  return sekme, dosya, derinlik, parcalar
end

-- ana sayfa: ortada dönen küre
local function kureHero(baslik, alt)
  return string.format([[
<section class="recep-khero" aria-labelledby="recep-khero-baslik">
  <div class="recep-kure recep-khero-kure" data-hiz="0.006" role="presentation"></div>
  <h1 id="recep-khero-baslik" class="recep-khero-baslik">%s</h1>
  %s
  <p class="recep-khero-koord">lat 41.01 · lon 28.98 · <b>●</b> istanbul</p>
</section>]],
    kacis(baslik),
    alt and ('<p class="recep-khero-alt">' .. kacis(alt) .. '</p>') or "")
end

-- kaynak anahtarı → yayındaki html yolu (sitenin köküne göre)
local function cikti(anahtar)
  if anahtar == "index.en" then return "index.html" end
  return anahtar .. ".html"
end

-- karşı dildeki eşin adresi: <meta name="recep-ceviri"> (göreli) + hreflang (mutlak)
local function ceviriBaglantisi(dil, parcalar, derinlik)
  local anahtar = table.concat(parcalar, "/"):gsub("%.qmd$", ""):gsub("%.md$", "")
  local ofset = derinlik == 0 and "./" or string.rep("../", derinlik)
  local trYol, enYol, hedef
  if dil == "en" then
    enYol = cikti(anahtar)
    trYol = TERS[anahtar] and cikti(TERS[anahtar]) or "index.html"
    hedef = ofset .. "../" .. trYol              -- _site/en/… → _site/…
  else
    trYol = cikti(anahtar)
    enYol = CEVIRI[anahtar] and cikti(CEVIRI[anahtar]) or "index.html"
    hedef = ofset .. "en/" .. enYol
    -- 404 herhangi bir adreste gösterilir: göreli yol kırılır, mutlak adres kullan
    if anahtar == "404" then hedef = SITE .. "en/" .. enYol end
  end
  quarto.doc.include_text("in-header", string.format(
    '<meta name="recep-ceviri" content="%s">\n' ..
    '<link rel="alternate" hreflang="tr" href="%s%s">\n' ..
    '<link rel="alternate" hreflang="en" href="%sen/%s">',
    hedef, SITE, trYol, SITE, enYol))
end

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return nil end
  local m = doc.meta
  local dil = yazi(m["lang"]) or "tr"
  local sekme, dosya, derinlik, parcalar = konum()
  ceviriBaglantisi(dil, parcalar, derinlik)
  if m["hero"] == false or yazi(m["hero"]) == "false" then return nil end
  if dosya == "index.en" then dosya = "index" end
  local baslik = yazi(m["hero-baslik"]) or yazi(m["title"]) or yazi(m["pagetitle"]) or ""
  local alt = yazi(m["description"])

  if sekme == "ana" and not yazi(m["hero-eser"]) then
    table.insert(doc.blocks, 1, pandoc.RawBlock("html", kureHero(baslik, alt)))
    return doc
  end

  local eserAdi = yazi(m["hero-eser"]) or SEKME[sekme]
  if not eserAdi or not ESER[eserAdi] then return nil end
  local eser = ESER[eserAdi]

  local boyut = yazi(m["hero-boyut"])
  if boyut ~= "buyuk" and boyut ~= "orta" then
    boyut = (dosya == "index") and "buyuk" or "orta"
  end

  -- yol: /arastirmacilar · /projeler/skdm/yontem
  local klasor = derinlik > 0 and ("/" .. table.concat(parcalar, "/", 1, #parcalar - 1)) or ""
  local yol = (dosya == "index") and (klasor ~= "" and klasor or "/") or (klasor .. "/" .. dosya)

  local etiket = yazi(m["hero-meta"])
  local w, h = eser.w or 720, eser.h or 405
  local ekSinif = (eser.ince and " recep-dhero--ince" or "") .. (eser.sabit and " recep-dhero--sabit" or "")

  local ofset = derinlik == 0 and "." or string.rep("..", derinlik, "/")
  local src = ofset .. "/assets/sanat/" .. eser.dosya

  local html = string.format([[
<section class="recep-dhero recep-dhero--%s%s" data-eser="%s" aria-labelledby="recep-dhero-baslik">
  <div class="recep-dhero-meta%s"><span>%s</span><span>1-bit · %d×%d</span></div>
  <div class="recep-dhero-tuval">
    <img src="%s" alt="" width="%d" height="%d" style="object-position: %s" decoding="async" fetchpriority="high">
    <h1 id="recep-dhero-baslik" class="recep-dhero-baslik"><span>%s</span></h1>
  </div>
  <div class="recep-dhero-alt-satir">
    %s
    <p class="recep-dhero-kunye">%s</p>
  </div>
</section>]],
    boyut, ekSinif, eserAdi, etiket and " recep-dhero-meta--etiket" or "", kacis(etiket or yol), w, h, src, w, h, eser.odak, kacis(baslik),
    alt and ('<p class="recep-dhero-alt">' .. kacis(alt) .. '</p>') or "",
    kacis((dil == "en" and eser.kunye_en) or eser.kunye))

  table.insert(doc.blocks, 1, pandoc.RawBlock("html", html))
  return doc
end
