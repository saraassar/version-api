import os

from fastapi import FastAPI

app = FastAPI()

# These are NOT computed here — they're baked into the image at build time
# via Docker build-args, and CI is the only thing that ever sets them.
GIT_SHA = os.getenv("GIT_SHA", "unknown")
BUILD_TIME = os.getenv("BUILD_TIME", "unknown")


@app.get("/healthz")
def healthz():
    return {"status": "ok"}


@app.get("/version")
def version():
    return {"git_sha": GIT_SHA, "build_time": BUILD_TIME}
