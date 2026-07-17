# ShortLink

A simple URL shortener built to practice a full DevOps toolchain: Docker,
Kubernetes, Jenkins, Terraform, Ansible.

## Architecture
- `frontend/` — static HTML/JS UI served by nginx
- `backend/` — Flask API (shorten + redirect logic)
- `db` — PostgreSQL (stores URL mappings)
- `cache` — Redis (caches hot redirects)

## Run locally with Docker Compose
```bash
docker compose up --build
```
Then open http://localhost:8080

## API
- `POST /api/shorten` `{ "url": "https://example.com" }` → `{ "code": "...", "short_url": "/..." }`
- `GET /<code>` → redirects to the original URL
- `GET /api/health` → health check

## Roadmap
1. Docker Compose (local dev) — done
2. Vagrant + Terraform — provision local VMs
3. Ansible — configure the VMs
4. Kubernetes (Kind) — deploy the app in-cluster
5. Jenkins — CI/CD pipeline
6. AWS — migrate infra with Terraform/EKS

Testing Jenkins auto-trigger..
