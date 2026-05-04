const diaryList = document.querySelector("[data-diary-list]");
const diaryTemplate = document.querySelector("#diary-card-template");
const canRenderDiary = Boolean(diaryList && diaryTemplate);
const diaryLimit = getDiaryLimit(diaryList?.dataset?.diaryLimit);

const fileProtocol = window.location.protocol === "file:";

if (canRenderDiary) {
  bootstrapDiary().catch((error) => {
    console.error("diary bootstrap failed", error);
    renderError(diaryList, "日記データの読み込みに失敗しました。");
  });
}

async function bootstrapDiary() {
  const diaryData = await loadJson("data/diary.json");
  renderDiaryEntries(normalizeEntries(diaryData));
}

async function loadJson(path) {
  try {
    const response = await fetch(path, { cache: "no-store" });
    if (!response.ok) {
      throw new Error(`${path}: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.warn(`Could not load ${path}`, error);
    return { entries: [], error: true };
  }
}

function normalizeEntries(data) {
  const entries = Array.isArray(data?.entries) ? data.entries : [];
  return entries
    .filter((entry) => entry && !entry.sample)
    .sort((a, b) => compareDates(b.date, a.date));
}

function compareDates(left, right) {
  const leftDate = Date.parse(left || "");
  const rightDate = Date.parse(right || "");

  if (Number.isNaN(leftDate) && Number.isNaN(rightDate)) {
    return 0;
  }
  if (Number.isNaN(leftDate)) {
    return -1;
  }
  if (Number.isNaN(rightDate)) {
    return 1;
  }
  return leftDate - rightDate;
}

function renderDiaryEntries(entries) {
  diaryList.replaceChildren();

  const visibleEntries = diaryLimit ? entries.slice(0, diaryLimit) : entries;

  if (!visibleEntries.length) {
    renderEmpty(
      diaryList,
      "まだ日記はありません。",
      fileProtocol
        ? "ローカルファイルを直接開くと JSON を読めないことがあります。Live Server などのローカルサーバーで確認してください。"
        : "画像や日記が追加されると、ここに並びます。"
    );
    return;
  }

  for (const entry of visibleEntries) {
    const node = diaryTemplate.content.firstElementChild.cloneNode(true);
    const mediaLink = node.querySelector(".diary-card__media-link");
    const image = node.querySelector(".diary-card__image");
    const date = node.querySelector(".entry-meta__date");
    const title = node.querySelector(".diary-card__title");
    const text = node.querySelector(".diary-card__text");
    const xLink = node.querySelector(".text-link");

    const fallbackLink = entry.x_url || entry.image || "#";

    mediaLink.href = fallbackLink;
    image.src = entry.image || "assets/images/ui/logo/logo.png";
    image.alt = entry.alt || entry.title || "日記画像";
    date.dateTime = entry.date || "";
    date.textContent = formatDate(entry.date);
    title.textContent = entry.title || "Diary";
    text.textContent = entry.text || "";
    xLink.href = entry.x_url || fallbackLink;

    if (!entry.x_url) {
      xLink.textContent = "画像を見る";
    }

    diaryList.append(node);
  }
}

function getDiaryLimit(value) {
  const parsed = Number.parseInt(value || "", 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
}

function renderEmpty(target, title, text) {
  const card = document.createElement("article");
  card.className = "empty-card";

  const strong = document.createElement("strong");
  strong.textContent = title;

  const paragraph = document.createElement("p");
  paragraph.textContent = text;

  card.append(strong, paragraph);
  target.append(card);
}

function renderError(target, title) {
  if (!target) {
    return;
  }

  target.replaceChildren();
  renderEmpty(
    target,
    title,
    fileProtocol
      ? "ローカルファイルを直接開くと JSON の読み込みに失敗することがあります。"
      : "時間をおいてもう一度読み込んでください。"
  );
}

function formatDate(value) {
  const parsed = Date.parse(value || "");
  if (Number.isNaN(parsed)) {
    return value || "日付未設定";
  }

  return new Intl.DateTimeFormat("ja-JP", {
    year: "numeric",
    month: "numeric",
    day: "numeric",
  }).format(new Date(parsed));
}
