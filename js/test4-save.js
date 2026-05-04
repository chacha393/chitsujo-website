const diaryList = document.querySelector("[data-diary-list]");
const videoList = document.querySelector("[data-video-list]");
const diaryTemplate = document.querySelector("#diary-card-template");
const videoTemplate = document.querySelector("#video-card-template");

const fileProtocol = window.location.protocol === "file:";

if (diaryList && videoList && diaryTemplate && videoTemplate) {
  bootstrap().catch((error) => {
    console.error("test4-save bootstrap failed", error);
    renderError(diaryList, "日記データの読み込みに失敗しました。");
    renderError(videoList, "動画データの読み込みに失敗しました。");
  });
}

async function bootstrap() {
  const [diaryData, videoData] = await Promise.all([
    loadJson("data/diary.json"),
    loadJson("data/videos.json"),
  ]);

  renderDiaryEntries(normalizeEntries(diaryData));
  renderVideoEntries(normalizeEntries(videoData));
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

  if (!entries.length) {
    renderEmpty(
      diaryList,
      "まだ日記はありません。",
      fileProtocol
        ? "ローカルファイルを直接開くと JSON を読めないことがあります。Live Server などのローカルサーバーで確認してください。"
        : "画像や日記が追加されると、ここに並びます。"
    );
    return;
  }

  for (const entry of entries) {
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

function renderVideoEntries(entries) {
  videoList.replaceChildren();

  if (!entries.length) {
    renderEmpty(
      videoList,
      "まだ動画はありません。",
      fileProtocol
        ? "ローカルファイルを直接開くと JSON を読めないことがあります。Live Server などのローカルサーバーで確認してください。"
        : "動画が追加されると、ここに並びます。"
    );
    return;
  }

  for (const entry of entries) {
    const node = videoTemplate.content.firstElementChild.cloneNode(true);
    const frameWrap = node.querySelector(".video-card__frame-wrap");
    const frame = node.querySelector(".video-card__frame");
    const date = node.querySelector(".entry-meta__date");
    const title = node.querySelector(".video-card__title");
    const text = node.querySelector(".video-card__text");
    const youtubeLink = node.querySelector(".video-card__youtube-link");
    const xLink = node.querySelector(".video-card__x-link");

    const embedUrl = getYouTubeEmbedUrl(entry.youtube_url);
    frame.src = embedUrl || "";
    frame.title = entry.title || "YouTube video";
    date.dateTime = entry.date || "";
    date.textContent = formatDate(entry.date);
    title.textContent = entry.title || "Movie";
    text.textContent = entry.text || "";
    youtubeLink.href = entry.youtube_url || "https://youtube.com/@chitsujomea?si=fU7vwQaMJaIpg37N";

    if (entry.x_url) {
      xLink.href = entry.x_url;
    } else {
      xLink.remove();
    }

    if (!embedUrl) {
      frameWrap.remove();
      const fallback = document.createElement("div");
      fallback.className = "empty-card";

      const strong = document.createElement("strong");
      strong.textContent = "動画 URL を確認してください。";

      const paragraph = document.createElement("p");
      paragraph.textContent = "YouTube の watch / shorts / youtu.be リンクに対応しています。";

      fallback.append(strong, paragraph);
      node.prepend(fallback);
    }

    videoList.append(node);
  }
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

function getYouTubeEmbedUrl(url) {
  if (!url) {
    return "";
  }

  try {
    const parsed = new URL(url);
    let videoId = "";

    if (parsed.hostname === "youtu.be") {
      videoId = parsed.pathname.slice(1);
    } else if (parsed.searchParams.get("v")) {
      videoId = parsed.searchParams.get("v");
    } else if (parsed.pathname.startsWith("/shorts/")) {
      videoId = parsed.pathname.split("/")[2];
    } else if (parsed.pathname.startsWith("/live/")) {
      videoId = parsed.pathname.split("/")[2];
    }

    if (!videoId) {
      return "";
    }

    return `https://www.youtube-nocookie.com/embed/${videoId}?rel=0`;
  } catch (error) {
    console.warn("Invalid YouTube URL", url, error);
    return "";
  }
}
