const TWITCH_TOKEN_URL = "https://id.twitch.tv/oauth2/token";
const TWITCH_STREAMS_URL = "https://api.twitch.tv/helix/streams";

let cachedToken;

export async function onRequestOptions() {
  return new Response(null, {
    status: 204,
    headers: corsHeaders(),
  });
}

export async function onRequestGet({ request, env }) {
  try {
    const url = new URL(request.url);
    const userLogin = url.searchParams.get("user_login") || env.TWITCH_USER_LOGIN || "mamorumea";

    if (!env.TWITCH_CLIENT_ID || !env.TWITCH_CLIENT_SECRET) {
      return json(
        {
          error: "TWITCH_CLIENT_ID and TWITCH_CLIENT_SECRET are required.",
        },
        500,
      );
    }

    const accessToken = await getAppAccessToken(env);
    const streamsUrl = new URL(TWITCH_STREAMS_URL);
    streamsUrl.searchParams.set("user_login", userLogin);

    const streamResponse = await fetch(streamsUrl, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Client-Id": env.TWITCH_CLIENT_ID,
      },
    });

    if (!streamResponse.ok) {
      return json(
        {
          error: "Twitch streams request failed.",
          status: streamResponse.status,
        },
        streamResponse.status,
      );
    }

    const payload = await streamResponse.json();
    const stream = Array.isArray(payload.data) ? payload.data[0] : null;

    return json(
      {
        isLive: Boolean(stream),
        userLogin,
        title: stream?.title || "",
        gameName: stream?.game_name || "",
        viewerCount: stream?.viewer_count ?? null,
        startedAt: stream?.started_at || "",
        thumbnailUrl: formatThumbnailUrl(stream?.thumbnail_url || ""),
      },
      200,
      {
        "Cache-Control": "public, max-age=60",
      },
    );
  } catch (error) {
    return json(
      {
        error: "Unexpected Twitch status error.",
        message: error instanceof Error ? error.message : String(error),
      },
      500,
    );
  }
}

async function getAppAccessToken(env) {
  const now = Date.now();

  if (
    cachedToken &&
    cachedToken.clientId === env.TWITCH_CLIENT_ID &&
    cachedToken.expiresAt > now + 60_000
  ) {
    return cachedToken.value;
  }

  const body = new URLSearchParams({
    client_id: env.TWITCH_CLIENT_ID,
    client_secret: env.TWITCH_CLIENT_SECRET,
    grant_type: "client_credentials",
  });

  const response = await fetch(TWITCH_TOKEN_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body,
  });

  if (!response.ok) {
    throw new Error(`Twitch token request failed: ${response.status}`);
  }

  const token = await response.json();

  cachedToken = {
    clientId: env.TWITCH_CLIENT_ID,
    value: token.access_token,
    expiresAt: now + token.expires_in * 1000,
  };

  return cachedToken.value;
}

function formatThumbnailUrl(url) {
  return url
    .replace("{width}", "640")
    .replace("{height}", "360");
}

function json(body, status = 200, headers = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      ...corsHeaders(),
      ...headers,
    },
  });
}

function corsHeaders() {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
  };
}
