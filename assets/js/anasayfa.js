// Ana sayfa etkileşimleri: SKDM yıl kaydırıcısı ve sözlük (arama, konu çipleri, rastgele kavram).
// Dışarıdan hiçbir şey yüklemez. JS kapalıyken bölümler sade hâlde çalışır (kaydırıcı 2026'yı gösterir,
// sözlük kartları <details> olarak açılıp kapanır).
const EN = (document.documentElement.lang || "").startsWith("en");
const AZ_HAREKET = matchMedia("(prefers-reduced-motion: reduce)").matches;

// ---------------- SKDM yıl kaydırıcısı ----------------
function yuzde(x) {
  const s = (Math.round(x * 1000) / 10).toLocaleString(EN ? "en" : "tr", { maximumFractionDigits: 1 });
  return EN ? s + "%" : "%" + s;
}

// Türkçe ekler sayının okunuşuna uyar: 2026'da, 2033'te; %10'u, %86'sı
const SON_RAKAM = { bulunma: ["da", "de", "de", "te", "te", "te", "da", "de", "de", "da"],
                    iyelik: ["", "i", "si", "ü", "ü", "i", "sı", "si", "i", "u"] };
const ONLAR = { bulunma: ["", "da", "de", "da", "ta", "de", "ta", "de", "de", "da"],
                iyelik: ["", "u", "si", "u", "ı", "si", "ı", "i", "i", "ı"] };
function ek(sayiYazi, tur) {                // yalnızca bu bölümdeki sayılar için: 1–99, 100 ve 2026–2034
  const rakam = sayiYazi.replace(/\D/g, "");
  if (rakam === "100") return tur === "bulunma" ? "de" : "ü";
  const son = +rakam.slice(-1);
  return son ? SON_RAKAM[tur][son] : ONLAR[tur][+rakam.slice(-2, -1)];
}
const yilda = (y) => `${y}'${ek(String(y), "bulunma")}`;
const yildan = (y) => `${y}'${ek(String(y), "bulunma")}n`;  // 2034'ten

async function skdmYil(kap) {
  let meta;
  try {
    const r = await fetch(new URL("../cbam/data/web/meta.json", import.meta.url));
    meta = await r.json();
  } catch { return; }                       // veri gelmezse statik 2026 hâli kalır
  const yillar = meta.yillar, faktor = meta.cbam_faktoru;
  const $ = (s) => kap.querySelector(s);
  const girdi = $("[data-girdi]"), oynat = $("[data-oynat]");

  const goster = (yil) => {
    const i = yillar.indexOf(yil);
    if (i < 0) return;
    const odenen = 1 - faktor[i];
    $("[data-yil]").textContent = yil;
    $("[data-odenen]").textContent = yuzde(odenen);
    $("[data-ucretsiz-cubuk]").style.width = (faktor[i] * 100) + "%";
    $("[data-odenen-cubuk]").style.width = (odenen * 100) + "%";
    $("[data-metin]").textContent = odenen >= 1
      ? (EN ? `From ${yil}, free allocation is gone: certificates cover all embedded emissions.`
            : `${yildan(yil)} itibaren ücretsiz tahsis kalmıyor: gömülü salımın tamamı için sertifika alınır.`)
      : (EN ? `In ${yil}, certificates cover ${yuzde(odenen)} of benchmark-level emissions and all emissions above the benchmark.`
            : `${yilda(yil)} benchmark düzeyindeki salımın ${yuzde(odenen)}'${ek(yuzde(odenen), "iyelik")} için, benchmarkı aşan salımın ise tamamı için sertifika alınır.`);
    girdi.value = yil;
    girdi.setAttribute("aria-valuetext", `${yil}: ${yuzde(odenen)} ${EN ? "paid" : "ödenir"}`);
  };

  let zamanlayici = null;
  const durdur = () => {
    clearInterval(zamanlayici); zamanlayici = null;
    oynat.textContent = EN ? "▶ Play the years" : "▶ Yılları oynat";
    oynat.setAttribute("aria-pressed", "false");
  };
  girdi.addEventListener("input", () => { durdur(); goster(+girdi.value); });
  oynat.hidden = false;
  oynat.setAttribute("aria-pressed", "false");
  oynat.addEventListener("click", () => {
    if (zamanlayici) return durdur();
    let i = yillar.indexOf(+girdi.value);
    if (i >= yillar.length - 1) i = -1;
    oynat.textContent = EN ? "❚❚ Pause" : "❚❚ Durdur";
    oynat.setAttribute("aria-pressed", "true");
    const adim = () => {
      i += 1; goster(yillar[i]);
      if (i >= yillar.length - 1) durdur();
    };
    adim();
    zamanlayici = setInterval(adim, AZ_HAREKET ? 1400 : 900);
  });
  goster(+girdi.value);
}

// ---------------- sözlük ----------------
// Türkçe büyük/küçük harf ve aksan farkı aramayı engellemesin: "sKdm", "gomulu" da bulsun
const sade = (s) => s.toLocaleLowerCase(EN ? "en" : "tr").normalize("NFD").replace(/[̀-ͯ]/g, "").replace(/ı/g, "i");

function sozluk(kap) {
  const $ = (s) => kap.querySelector(s);
  const kartlar = [...kap.querySelectorAll(".recep-kavram")];
  const ara = $("[data-sozluk-ara]"), sayi = $("[data-sozluk-sayi]"), yok = $("[data-sozluk-yok]");
  const cipler = [...kap.querySelectorAll(".recep-cip")];
  const metin = new Map(kartlar.map((k) => [k, sade(k.dataset.ara || k.textContent)]));
  let konu = "";

  const suz = () => {
    const q = sade(ara.value.trim());
    let n = 0;
    for (const k of kartlar) {
      const gorunur = (!konu || k.dataset.konu === konu) && (!q || metin.get(k).includes(q));
      k.hidden = !gorunur;
      if (!gorunur) k.open = false;
      n += gorunur;
    }
    yok.hidden = n > 0;
    sayi.textContent = EN ? `${n} term${n === 1 ? "" : "s"} shown` : `${n} kavram gösteriliyor`;
  };

  for (const c of cipler) {
    c.addEventListener("click", () => {
      konu = c.dataset.konu;
      for (const d of cipler) d.setAttribute("aria-pressed", String(d === c));
      suz();
    });
  }
  ara.addEventListener("input", suz);
  ara.addEventListener("keydown", (e) => { if (e.key === "Escape" && ara.value) { ara.value = ""; suz(); } });

  $("[data-sozluk-rastgele]").addEventListener("click", () => {
    const aday = kartlar.filter((k) => !k.hidden && !k.open);
    const havuz = aday.length ? aday : kartlar.filter((k) => !k.hidden);
    if (!havuz.length) return;
    const k = havuz[Math.floor(Math.random() * havuz.length)];
    for (const d of kartlar) if (d !== k) d.open = false;
    k.open = true;
    k.scrollIntoView({ block: "nearest", behavior: AZ_HAREKET ? "auto" : "smooth" });
    k.querySelector("summary").focus({ preventScroll: true });
    k.classList.remove("recep-kavram--parla"); void k.offsetWidth; k.classList.add("recep-kavram--parla");
  });

  $(".recep-sozluk-arac").hidden = false;
}

// bölüm ekrana yaklaşınca kur (ilk açılışta iş yapma)
function yaklasinca(el, fn) {
  if (!el) return;
  if (!("IntersectionObserver" in window)) return fn(el);
  const io = new IntersectionObserver((g) => {
    if (g.some((x) => x.isIntersecting)) { io.disconnect(); fn(el); }
  }, { rootMargin: "400px 0px" });
  io.observe(el);
}

yaklasinca(document.querySelector("[data-skdm-yil]"), skdmYil);
yaklasinca(document.querySelector("[data-sozluk]"), sozluk);
