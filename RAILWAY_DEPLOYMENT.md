# KEDCO Technical Automation — Railway deployment

The application is deployed as one Node.js service. Express serves `frontend/index.html` at `/`, serves the existing module pages from `frontend/pages/`, and exposes the existing `/api/*` routes from the same origin. No production page should call `localhost`.

## 1. Push the safe application source

Create a private GitHub repository and push this project root. The repository should include `frontend/`, `backend/src/`, `backend/package.json`, `backend/package-lock.json`, `package.json`, `railway.json`, `.gitignore`, and `.env.example`.

Do not commit `.env`, `LOGIN_DETAILS_PRIVATE.csv`, `cloud data/`, `backend/node_modules/`, or `backend/dist/`. The existing local operational data is left intact on this computer, but it must be transferred to the Railway Volume through a secured migration rather than committed to GitHub.

## 2. Create the Railway service

1. In Railway, create a project and deploy the GitHub repository.
2. The checked-in `railway.json` supplies the build command, start command, and `/health` health check.
3. Add these service variables (use the values in `.env.example` as the template):

   - `NODE_ENV=production`
   - `KEDCO_PUBLIC_URL=https://teams.com.ng`
   - `CORS_ORIGIN=https://teams.com.ng,https://www.teams.com.ng`
   - `KEDCO_LOCAL_DATA_ROOT=/data/kedco`
   - `KEDCO_SMTP_HOST`, `KEDCO_SMTP_PORT`, `KEDCO_SMTP_SECURE`, `KEDCO_SMTP_USER`, `KEDCO_SMTP_PASS`, and `KEDCO_SMTP_FROM` if password reset email is required

Railway supplies `PORT`; do not replace it with a fixed production port. The local fallback remains `5500` only for local development.

## 3. Persist operational data

Attach a Railway Volume to the service at `/data`. The application will write its file-backed data below `/data/kedco`. Without a Volume, user accounts, sessions, workflow records, reports, and uploaded evidence can disappear when the service restarts or redeploys.

Before switching users to production, securely copy the intended contents of the local `cloud data/` directory into `/data/kedco` using Railway's volume file tools or another approved migration method. Review `system/sessions.json` and rotate active sessions/passwords as part of that migration.

## 4. Connect `teams.com.ng`

In the Railway service Settings, add `teams.com.ng` and, if needed, `www.teams.com.ng` under Public Networking → Custom Domain. Railway will show the exact CNAME/ALIAS target and TXT verification value for the service. Add both records at the DNS provider for `teams.com.ng`; the apex domain requires CNAME flattening, ALIAS, or ANAME support. Railway issues the HTTPS certificate after the domain is verified.

Use the Railway-provided service domain to test first:

```text
GET https://<railway-service-domain>/health
GET https://<railway-service-domain>/
```

Then verify the same endpoints on `https://teams.com.ng`. The login page is the landing page; dashboards remain role-routed after authentication.

## 5. Post-deployment checks

```text
GET /health                         200 JSON
GET /                                200 frontend/index.html
GET /pages/system-operations/...    200 for each approved page
POST /api/auth/login                 200 with a migrated active user
```

Also test a real login, role landing route, logout, password reset (if SMTP is configured), one representative workflow submission, one report/data write, and one evidence upload. Keep the local application available until those checks pass and the initial Railway Volume backup exists.
