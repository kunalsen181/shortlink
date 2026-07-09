const API_BASE = window.location.origin.replace(":8080", ":5000");

async function shorten() {
  const url = document.getElementById("urlInput").value;
  const resultDiv = document.getElementById("result");

  if (!url) {
    resultDiv.innerText = "Please enter a URL.";
    return;
  }

  try {
    const res = await fetch(`${API_BASE}/api/shorten`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ url })
    });

    const data = await res.json();

    if (res.ok) {
      const shortUrl = `${API_BASE}${data.short_url}`;
      resultDiv.innerHTML = `Short URL: <a href="${shortUrl}" target="_blank">${shortUrl}</a>`;
    } else {
      resultDiv.innerText = `Error: ${data.error}`;
    }
  } catch (err) {
    resultDiv.innerText = "Could not reach the backend. Is it running?";
  }
}
