# FIXES.md

## Fix 1
- **File:** `api/main.py`
- **Line:** 6
- **Issue:** Redis connection was pointing to `localhost` which works fine on your machine
but the moment this runs in Docker, there is no localhost — services talk by name
- **Fix:** Pulled the host and port from environment variables using `os.getenv("REDIS_HOST", "redis")` and `os.getenv("REDIS_PORT", 6379)`

## Fix 2
- **File:** `api/main.py`
- **Issue:** The API had no `/health` route. Without it, Docker has nothing to check
and will never mark the container as healthy
- **Fix:** Added a `/health` endpoint that returns `{"status": "ok"}`

## Fix 3
- **File:** `worker/worker.py`
- **Line:** 6
- **Issue:** Same localhost problem as the API — worker could not reach Redis inside Docker
- **Fix:** Same fix, environment variables for host and port

## Fix 4
- **File:** `worker/worker.py`
- **Line:** 12
- **Issue:** Worker had no signal handling. If Docker stops the container mid-job,
the job just disappears with no record of what happened
- **Fix:** Added SIGTERM and SIGINT handlers so the worker exits cleanly

## Fix 5
- **File:** `frontend/app.js`
- **Line:** 5
- **Issue:** API URL was hardcoded as `http://localhost:8000`. Inside Docker the API
service is reachable by its service name, not localhost
- **Fix:** Changed to read from `process.env.API_URL` with `http://api:8000` as fallback

## Fix 6
- **File:** `frontend/app.js`
- **Issue:** No `/health` route on the frontend either. Docker Compose was set to wait
for healthy status before starting dependents — this would hang forever
- **Fix:** Added a `/health` route returning `{"status": "ok"}`

## Fix 7
- **File:** `api/requirements.txt`
- **Issue:** All three packages had no versions pinned. A build today and a build
next week could pull completely different versions and silently break things
- **Fix:** Pinned to `fastapi==0.111.0`, `uvicorn==0.29.0`, `redis==5.0.4`

## Fix 8
- **File:** `worker/requirements.txt`
- **Issue:** Same unpinned dependency problem
- **Fix:** Pinned to `redis==5.0.4`

## Fix 9
- **File:** `api/.env`
- **Issue:** A real `.env` file containing an actual password (`REDIS_PASSWORD`) was
sitting in the repo ready to be committed and pushed publicly
- **Fix:** Added `.env` to `.gitignore` and removed it from git tracking immediately