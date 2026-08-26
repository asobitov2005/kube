import os

import asyncpg
from fastapi import FastAPI, HTTPException

app = FastAPI(title="Kubernetes FastAPI demo")


@app.get("/")
async def root():
    return {
        "message": "FastAPI servisidan salom!",
        "service": "python-api",
        "pod": os.getenv("HOSTNAME", "local"),
    }


@app.get("/healthz")
async def healthz():
    return {"status": "ok"}


@app.get("/readyz")
async def readyz():
    return {"status": "ready"}


@app.get("/db")
async def database_check():
    required = ["DB_HOST", "DB_NAME", "DB_USER", "DB_PASSWORD"]
    if not all(os.getenv(key) for key in required):
        raise HTTPException(503, "Database sozlamalari berilmagan")
    connection = await asyncpg.connect(
        host=os.environ["DB_HOST"],
        port=int(os.getenv("DB_PORT", "5432")),
        database=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
    )
    try:
        value = await connection.fetchval("SELECT 1")
        return {"database": "ok", "result": value}
    finally:
        await connection.close()
