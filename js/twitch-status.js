document.addEventListener("DOMContentLoaded", () => {
  const cards = document.querySelectorAll("[data-twitch-status-card]");

  cards.forEach((card) => {
    updateTwitchCard(card);
  });
});

async function updateTwitchCard(card) {
  const endpoint = card.dataset.twitchStatusEndpoint;
  const channelUrl = card.dataset.twitchChannelUrl || "https://www.twitch.tv/mamorumea";
  const controller = new AbortController();
  const timeout = window.setTimeout(() => controller.abort(), 8000);

  setTwitchCardLoading(card);

  if (!endpoint) {
    window.clearTimeout(timeout);
    setTwitchCardError(card, channelUrl);
    return;
  }

  try {
    const response = await fetch(endpoint, {
      cache: "no-store",
      signal: controller.signal,
    });

    if (!response.ok) {
      throw new Error(`Twitch status request failed: ${response.status}`);
    }

    const payload = await response.json();
    setTwitchCardState(card, normalizeTwitchPayload(payload), channelUrl);
  } catch (error) {
    console.warn(error);
    setTwitchCardError(card, channelUrl);
  } finally {
    window.clearTimeout(timeout);
  }
}

function normalizeTwitchPayload(payload) {
  if (typeof payload?.isLive === "boolean") {
    return payload;
  }

  const stream = Array.isArray(payload?.data) ? payload.data[0] : null;

  if (!stream) {
    return { isLive: false };
  }

  return {
    isLive: true,
    title: stream.title,
    gameName: stream.game_name,
    viewerCount: stream.viewer_count,
    startedAt: stream.started_at,
    thumbnailUrl: stream.thumbnail_url,
  };
}

function setTwitchCardLoading(card) {
  card.dataset.state = "loading";
  setText(card, "[data-twitch-status-label]", "確認中");
  setText(card, "[data-twitch-status-title]", "Twitchの配信状況を確認します。");
  setText(card, "[data-twitch-status-meta]", "配信中ならサムネイルを表示します。");
  setTwitchPlaceholder(card, "確認中\n配信しているか確認しています");
  setThumbnail(card, null, "");
}

function setTwitchCardState(card, status, channelUrl) {
  if (status.isLive) {
    const title = status.title || "Twitchで配信中です";
    const meta = [
      status.gameName,
      Number.isFinite(status.viewerCount) ? `${status.viewerCount.toLocaleString()} viewers` : null,
    ].filter(Boolean).join(" / ");

    card.dataset.state = "live";
    setText(card, "[data-twitch-status-label]", "配信中");
    setText(card, "[data-twitch-status-title]", title);
    setText(card, "[data-twitch-status-meta]", meta || "配信サムネイルを表示中");
    setTwitchPlaceholder(card, "配信中\nTwitchで見てね");
    setThumbnail(card, formatThumbnailUrl(status.thumbnailUrl), `${title}の配信サムネイル`);
    setCta(card, channelUrl, "Twitchで見る ↗");
    return;
  }

  card.dataset.state = "offline";
  setText(card, "[data-twitch-status-label]", "配信中ではない");
  setText(card, "[data-twitch-status-title]", "いまはTwitch配信中ではありません。");
  setText(card, "[data-twitch-status-meta]", "次の配信までここで待機");
  setTwitchPlaceholder(card, "配信していません\nまたあとで見に来てね");
  setThumbnail(card, null, "");
  setCta(card, channelUrl, "Twitchを開く ↗");
}

function setTwitchCardError(card, channelUrl) {
  card.dataset.state = "error";
  setText(card, "[data-twitch-status-label]", "確認できません");
  setText(card, "[data-twitch-status-title]", "いまは配信状況を確認できません。");
  setText(card, "[data-twitch-status-meta]", "リンクからTwitchを開いて確認できます。");
  setTwitchPlaceholder(card, "確認できません\n配信中かTwitchで確認してね");
  setThumbnail(card, null, "");
  setCta(card, channelUrl, "Twitchを開く ↗");
}

function setText(scope, selector, text) {
  const target = scope.querySelector(selector);

  if (target) {
    target.textContent = text;
  }
}

function setCta(scope, href, text) {
  const cta = scope.querySelector("[data-twitch-cta]");
  const thumbnailLink = scope.querySelector("[data-twitch-thumbnail-link]");

  if (cta) {
    cta.href = href;
    cta.textContent = text;
  }

  if (thumbnailLink) {
    thumbnailLink.href = href;
  }
}

function setTwitchPlaceholder(scope, text) {
  setText(scope, "[data-twitch-placeholder]", text);
}

function setThumbnail(scope, src, alt) {
  const image = scope.querySelector("[data-twitch-thumbnail]");

  if (!image) {
    return;
  }

  if (!src) {
    image.hidden = true;
    image.removeAttribute("src");
    image.alt = "";
    return;
  }

  image.src = src;
  image.alt = alt;
  image.hidden = false;
}

function formatThumbnailUrl(url) {
  if (!url) {
    return "";
  }

  return url
    .replace("{width}", "640")
    .replace("{height}", "360");
}
