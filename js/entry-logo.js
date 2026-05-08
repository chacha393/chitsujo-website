document.addEventListener("DOMContentLoaded", () => {
  const revealContent = () => {
    document.body.classList.remove("entry-logo-lock");
    document.body.classList.add("content-visible");
  };

  const navigationEntry = performance.getEntriesByType("navigation")[0];
  const isBackForward = navigationEntry?.type === "back_forward";

  if (document.querySelector(".splash")) {
    return;
  }

  const params = new URLSearchParams(window.location.search);

  if (params.has("noEntryLogo")) {
    revealContent();
    return;
  }

  const referrer = document.referrer;
  let isExternalEntry = !referrer;

  if (referrer) {
    try {
      isExternalEntry = new URL(referrer).origin !== window.location.origin;
    } catch {
      isExternalEntry = true;
    }
  }

  if (isBackForward || !isExternalEntry) {
    revealContent();
    return;
  }

  const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const splash = document.createElement("div");
  splash.className = "entry-logo-overlay";
  splash.setAttribute("aria-hidden", "true");
  splash.innerHTML = `
    <img
      class="entry-logo-overlay__logo splash-logo"
      src="assets/images/ui/logo/logo.png"
      alt="秩序めあのロゴ"
      width="200"
      height="200"
    >
  `;

  document.body.appendChild(splash);
  document.body.classList.add("entry-logo-lock");

  requestAnimationFrame(() => {
    splash.classList.add("is-visible");
  });

  const visibleMs = prefersReducedMotion ? 1200 : 1800;
  const removeMs = prefersReducedMotion ? 1400 : 2000;

  window.setTimeout(() => {
    splash.classList.add("is-hiding");
  }, visibleMs);

  window.setTimeout(() => {
    splash.remove();
    revealContent();
  }, removeMs);
});

window.addEventListener("pageshow", (event) => {
  if (!event.persisted) {
    return;
  }

  document.querySelector(".entry-logo-overlay")?.remove();
  document.body.classList.remove("entry-logo-lock");
  document.body.classList.add("content-visible");
});
