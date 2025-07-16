# n8n ClickUp Connector

This project runs a local or server-based [n8n](https://n8n.io/) instance that connects to [ClickUp](https://clickup.com/) to manually set task IDs and comment on ClickUp tickets with instructions. It includes a basic setup for both local development (with ngrok support) and production deployment.

---

## 🚀 Features

- 🧩 Connects n8n to ClickUp
- 🛠️ Manually sets task IDs and comments ClickUp tickets
- 🔐 Basic Auth protection
- 🌐 Exposes local instance with Ngrok (for testing webhooks)
- 📦 File-based storage (no external DB required)

---

## 📁 Project Structure

```
├── docker-compose.yml        # Docker setup for n8n + ngrok
├── start-n8n.sh              # Local-only startup script using ngrok
├── .env                      # Your actual environment variables (not committed)
├── .env.example              # Example env file for reference
├── project_ids.json          # Your actual config (not committed)
├── project_ids.example.json  # Example config with structure
├── n8n_data/                 # Volume-mapped storage (JSON-based)
```

---

## 🖥️ Local Development

1. Copy example files:

```bash
cp .env.example .env
cp project_ids.example.json project_ids.json
```

2. Add your ClickUp config and ngrok token to `.env` and `project_ids.json`.

3. Run the local startup script (includes ngrok):

```bash
chmod +x start-n8n.sh
./start-n8n.sh
```

This will:

- Start both n8n and ngrok
- Wait for a public ngrok URL
- Inject that URL into `.env` as `WEBHOOK_URL`
- Restart n8n to apply the updated webhook setting

Access UI at: `http://localhost:5678`

> ⚠️ **Important:** The ngrok address changes every time you reboot your machine or restart ngrok. If your ClickUp integration depends on the public URL, you’ll need to re-run `start-n8n.sh` and update ClickUp with the new webhook URL.

---

## 🌐 Production Setup

1. Clone this repo on your server:

```bash
git clone git@github.com:<your-user>/n8n-server.git
cd n8n-server
```

2. Copy and configure:

```bash
cp .env.example .env
cp project_ids.example.json project_ids.json
```

3. Edit `.env` with your domain and config.

4. Start n8n (without ngrok):

```bash
docker compose up -d
```

Set up a reverse proxy (e.g., NGINX or Caddy) to expose it securely via HTTPS.

---

## 🔒 Environment Variables

See `.env.example` for available options:

- `N8N_BASIC_AUTH_ACTIVE`, `N8N_BASIC_AUTH_USER`, `N8N_BASIC_AUTH_PASSWORD`
- `N8N_HOST`, `N8N_PORT`, `WEBHOOK_URL`
- `NGROK_AUTHTOKEN`
- `TZ` — timezone for cron jobs

---

## 🧪 Data Persistence

This setup uses **file-based storage**, not a database. All workflows, credentials, etc. are saved inside the `n8n_data/` volume.

Do not delete that folder unless you intend to wipe all data.

---

## 🗂️ ClickUp Project Mapping

The `project_ids.json` file maps ClickUp folders to task prefixes and internal values. This file is required at runtime but not committed.

```json
[
  {
    "folder": "ExampleFolder",
    "folder_id": "00000000000",
    "prefix": "EXM",
    "value": 0
  }
]
```

> After cloning, copy `project_ids.example.json` to `project_ids.json` and customize.

---

## 📌 Notes

- `start-n8n.sh` is **for local development only** and uses ngrok.
- `project_ids.json` and `.env` are **excluded from Git** for security and portability.
- This setup assumes no external database — all data is stored via Docker volume.

---

Made with ❤️ using [n8n.io](https://n8n.io/) + [ClickUp](https://clickup.com/)

