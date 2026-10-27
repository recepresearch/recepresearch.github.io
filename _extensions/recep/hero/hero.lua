--[[
  recep · sayfa başlığı filtresi (DynamicHero)

  Her HTML sayfasının en üstüne otomatik bir başlık alanı ekler:
    · ana sayfa   → KÜRE HERO: ortada dönen wireframe dünya (assets/js/kure.js),
                    altında "recep" (Inter 900) ve grup adı
    · diğer sayfalar → SADE BAŞLIK: büyük başlık (Inter 700), altında kısa açıklama. Görsel yok; açık ve ferah. (2026-10-25: 1-bit Rönesans
                    tabloları kaldırıldı — eski hali `yedek-2026-10-25` sürümünde.)

  Front matter ile ayar (hepsi isteğe bağlı):
    title          → başlık            description → alt satır (Lora)
    hero: false    → bu sayfada kapat
    hero-baslik    → başlığı ez        hero-boyut: buyuk | orta (başlık boyu)

  Çift dil (_quarto-tr.yml / _quarto-en.yml): dil front matter'daki `lang` alanından okunur.
  Her sayfaya karşı dildeki eşinin adresi yazılır (<meta name="recep-ceviri"> + hreflang);
  navbar'daki tr / en seçicisi bu adresi kullanır (_quarto.yml → include-after-body).
]]

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
</section>]],
    kacis(baslik),
    alt and ('<p class="recep-khero-alt">' .. kacis(alt) .. '</p>') or "")
end

-- kaynak anahtarı → yayındaki html yolu (sitenin köküne göre)
local function cikti(anahtar)
  if anahtar == "index.en" then return "index.html" end
  return anahtar .. ".html"
end

-- arama motorları için yayındaki tam adres: ".../index.html" → ".../"
local function tamAdres(yol)
  return SITE .. yol:gsub("index%.html$", "")
end

-- karşı dildeki eşin adresi: <meta name="recep-ceviri"> (göreli) + canonical ve hreflang (mutlak).
-- hreflang yalnızca gerçek bir eş varsa yazılır (eşi olmayan sayfa karşı dilin ana sayfasına gider ama
-- arama motoruna onun çevirisiymiş gibi bildirilmez).
local function ceviriBaglantisi(dil, parcalar, derinlik)
  local anahtar = table.concat(parcalar, "/"):gsub("%.qmd$", ""):gsub("%.md$", "")
  local ofset = derinlik == 0 and "./" or string.rep("../", derinlik)
  local trYol, enYol, hedef, esVar, kendi
  if dil == "en" then
    esVar = TERS[anahtar] ~= nil
    enYol = cikti(anahtar)
    trYol = esVar and cikti(TERS[anahtar]) or "index.html"
    hedef = ofset .. "../" .. trYol              -- _site/en/… → _site/…
    kendi = tamAdres("en/" .. enYol)
  else
    esVar = CEVIRI[anahtar] ~= nil
    trYol = cikti(anahtar)
    enYol = esVar and cikti(CEVIRI[anahtar]) or "index.html"
    hedef = ofset .. "en/" .. enYol
    kendi = tamAdres(trYol)
    -- 404 herhangi bir adreste gösterilir: göreli yol kırılır, mutlak adres kullan
    if anahtar == "404" then hedef = SITE .. "en/" .. enYol end
  end
  local satirlar = { string.format('<meta name="recep-ceviri" content="%s">', hedef) }
  if anahtar ~= "404" then
    table.insert(satirlar, string.format('<link rel="canonical" href="%s">', kendi))
  end
  if esVar then
    table.insert(satirlar, string.format('<link rel="alternate" hreflang="tr" href="%s">', tamAdres(trYol)))
    table.insert(satirlar, string.format('<link rel="alternate" hreflang="en" href="%s">', tamAdres("en/" .. enYol)))
    table.insert(satirlar, string.format('<link rel="alternate" hreflang="x-default" href="%s">', tamAdres(trYol)))
  end
  quarto.doc.include_text("in-header", table.concat(satirlar, "\n"))
end

-- yapılandırılmış veri (schema.org, JSON-LD): Google'ın bilgi kartı ve etkinlik sonuçları için
local function jsonYazi(s)
  return '"' .. s:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub("\n", " "):gsub("<", "\\u003c") .. '"'
end

local function jsonNesne(t)
  local parca = {}
  for _, cift in ipairs(t) do
    local k, v = cift[1], cift[2]
    if v ~= nil then
      local deger = type(v) == "table" and jsonNesne(v) or jsonYazi(v)
      table.insert(parca, jsonYazi(k) .. ":" .. deger)
    end
  end
  return "{" .. table.concat(parca, ",") .. "}"
end

local function jsonLd(nesne)
  quarto.doc.include_text("in-header",
    '<script type="application/ld+json">' .. jsonNesne(nesne) .. "</script>")
end

-- ana sayfa: araştırma grubu (YTÜ'ye bağlı kurum)
local function kurumBilgisi(dil)
  local en = dil == "en"
  jsonLd({
    { "@context", "https://schema.org" },
    { "@type", "ResearchOrganization" },
    { "name", "RECEP" },
    { "alternateName", en and "Environment, Clean Energy and Economic Policies Research Group"
                           or "Çevre, Temiz Enerji ve Ekonomi Politikaları Araştırma Grubu" },
    { "url", en and SITE .. "en/" or SITE },
    { "logo", SITE .. "assets/marka/apple-touch-icon.png" },
    { "address", { { "@type", "PostalAddress" }, { "addressLocality", "İstanbul" }, { "addressCountry", "TR" } } },
    { "parentOrganization", { { "@type", "CollegeOrUniversity" },
                              { "name", en and "Yıldız Technical University" or "Yıldız Teknik Üniversitesi" },
                              { "url", "https://www.yildiz.edu.tr" } } },
  })
end

-- konferans / çalıştay / duyuru kayıtları (içerik paneli, /admin/): başlığın altında künye satırı
local TUR = {
  tr = { konferans = "konferans", calistay = "çalıştay", duyuru = "duyuru" },
  en = { konferans = "conference", calistay = "workshop", duyuru = "announcement" },
}
local AYLAR = {
  tr = { "ocak", "şubat", "mart", "nisan", "mayıs", "haziran", "temmuz", "ağustos", "eylül", "ekim", "kasım", "aralık" },
  en = { "january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december" },
}

local function isoTarih(s)
  local y, a, g = (s or ""):match("^(%d%d%d%d)-(%d%d)-(%d%d)")
  if y then return y, tonumber(a), tonumber(g) end
end

local function tarihYazi(s, dil)
  local y, a, g = isoTarih(s)
  if not y then return s end
  return string.format("%d %s %s", g, AYLAR[dil][a], y)
end

-- etkinlik tarih aralığı: "12–13 kasım 2026" · "30 ekim – 2 kasım 2026" · tek gün "12 kasım 2026"
local function aralikYazi(bas, bit, dil)
  local y1, a1, g1 = isoTarih(bas)
  local y2, a2, g2 = isoTarih(bit)
  if not y1 then return bas end
  if not y2 or bit == bas then return tarihYazi(bas, dil) end
  if y1 ~= y2 then return tarihYazi(bas, dil) .. " – " .. tarihYazi(bit, dil) end
  if a1 ~= a2 then
    return string.format("%d %s – %d %s %s", g1, AYLAR[dil][a1], g2, AYLAR[dil][a2], y1)
  end
  return string.format("%d–%d %s %s", g1, g2, AYLAR[dil][a1], y1)
end

-- konferans / çalıştay: başlangıç tarihi varsa Google'a etkinlik olarak bildir
local function etkinlikBilgisi(m, dil, tur)
  local bas = yazi(m["baslangic"])
  if (tur ~= "konferans" and tur ~= "calistay") or not isoTarih(bas) then return end
  local bit = isoTarih(yazi(m["bitis"])) and yazi(m["bitis"]) or nil
  local yer = yazi(m["yer"])
  local kucuk = yer and pandoc.text.lower(yer) or ""
  local cevrimici = (kucuk:find("çevrim", 1, true) or kucuk:find("online", 1, true)) and true or false
  local konum
  if cevrimici then
    konum = { { "@type", "VirtualLocation" }, { "url", yazi(m["baglanti"]) or SITE } }
  elseif yer then
    konum = { { "@type", "Place" }, { "name", yer }, { "address", yer } }
  end
  local resim = yazi(m["image"])
  jsonLd({
    { "@context", "https://schema.org" },
    { "@type", "Event" },
    { "name", yazi(m["title"]) or "" },
    { "description", yazi(m["description"]) },
    { "startDate", bas },
    { "endDate", bit },
    { "eventStatus", "https://schema.org/EventScheduled" },
    { "eventAttendanceMode", cevrimici and "https://schema.org/OnlineEventAttendanceMode"
                                        or "https://schema.org/OfflineEventAttendanceMode" },
    { "location", konum },
    { "image", resim and resim:match("^https?://") and resim or nil },
    { "inLanguage", dil },
    { "organizer", { { "@type", "ResearchOrganization" }, { "name", "RECEP" }, { "url", SITE } } },
  })
end

local function kayitKunyesi(m, dil)
  local tur = yazi(m["tur"])
  if not tur then return nil end
  local en = dil == "en"
  etkinlikBilgisi(m, dil, tur)
  local satir = {}
  local function ekle(etiket, deger)
    table.insert(satir, string.format("<dt>%s</dt><dd>%s</dd>", etiket, deger))
  end
  ekle(en and "type" or "tür", kacis(TUR[en and "en" or "tr"][tur] or tur))
  local yayin = yazi(m["date"])     -- Quarto bu alanı date-format ile biçimlendirmiş getirir
  if yayin then ekle(en and "published" or "yayın", kacis(pandoc.text.lower(tarihYazi(yayin, en and "en" or "tr")))) end
  local bas = yazi(m["baslangic"])
  if bas then ekle(en and "date" or "tarih", kacis(aralikYazi(bas, yazi(m["bitis"]), en and "en" or "tr"))) end
  local yer = yazi(m["yer"])
  if yer then ekle(en and "venue" or "yer", kacis(yer)) end
  local bag = yazi(m["baglanti"])
  if bag and bag:match("^https?://") then
    ekle(en and "link" or "bağlantı", string.format('<a href="%s">%s</a>', kacis(bag),
      kacis((bag:gsub("^https?://", ""):gsub("/$", "")))))
  end
  return pandoc.RawBlock("html", '<div class="recep-proje-kunye recep-kayit-kunye"><dl>' .. table.concat(satir) .. "</dl></div>")
end

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return nil end
  local kunye = kayitKunyesi(doc.meta, yazi(doc.meta["lang"]) or "tr")
  if kunye then table.insert(doc.blocks, 1, kunye) end
  local m = doc.meta
  local dil = yazi(m["lang"]) or "tr"
  local sekme, dosya, derinlik, parcalar = konum()
  ceviriBaglantisi(dil, parcalar, derinlik)
  if sekme == "ana" then kurumBilgisi(dil) end
  if m["hero"] == false or yazi(m["hero"]) == "false" then return doc end
  if dosya == "index.en" then dosya = "index" end
  local baslik = yazi(m["hero-baslik"]) or yazi(m["title"]) or yazi(m["pagetitle"]) or ""
  local alt = yazi(m["description"])

  if sekme == "ana" then
    table.insert(doc.blocks, 1, pandoc.RawBlock("html", kureHero(baslik, alt)))
    return doc
  end

  local boyut = yazi(m["hero-boyut"])
  if boyut ~= "buyuk" and boyut ~= "orta" then
    boyut = (dosya == "index" and derinlik <= 1) and "buyuk" or "orta"   -- bölüm sayfası büyük; alt sayfa ve kayıtlar orta
  end


  local html = string.format([[
<section class="recep-dhero recep-dhero--%s" aria-labelledby="recep-dhero-baslik">
  <h1 id="recep-dhero-baslik" class="recep-dhero-baslik">%s</h1>
  %s
</section>]],
    boyut, kacis(baslik),
    alt and ('<p class="recep-dhero-alt">' .. kacis(alt) .. '</p>') or "")

  table.insert(doc.blocks, 1, pandoc.RawBlock("html", html))
  return doc
end
