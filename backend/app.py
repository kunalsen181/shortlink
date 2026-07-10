import os
import string
import random
from flask import Flask, request, jsonify, redirect, abort
import redis
import psycopg2
from psycopg2.extras import RealDictCursor
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "shortlink")
DB_USER = os.getenv("DB_USER", "shortlink")
DB_PASS = os.getenv("DB_PASS", "shortlink")
REDIS_HOST = os.getenv("REDIS_HOST", "cache")

r = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)


def get_db_connection():
    return psycopg2.connect(host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASS)


def init_db():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS urls (
            id SERIAL PRIMARY KEY,
            code VARCHAR(10) UNIQUE NOT NULL,
            original_url TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        )
    """)
    conn.commit()
    cur.close()
    conn.close()


def generate_code(length=6):
    chars = string.ascii_letters + string.digits
    return ''.join(random.choice(chars) for _ in range(length))


@app.route("/api/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/api/shorten", methods=["POST"])
def shorten():
    data = request.get_json(silent=True) or {}
    original_url = data.get("url")
    if not original_url:
        return jsonify({"error": "url is required"}), 400

    conn = get_db_connection()
    cur = conn.cursor()

    code = generate_code()
    while True:
        cur.execute("SELECT 1 FROM urls WHERE code = %s", (code,))
        if not cur.fetchone():
            break
        code = generate_code()

    cur.execute(
        "INSERT INTO urls (code, original_url) VALUES (%s, %s)",
        (code, original_url)
    )
    conn.commit()
    cur.close()
    conn.close()

    r.set(code, original_url, ex=3600)

    return jsonify({"code": code, "short_url": f"/{code}"}), 201


@app.route("/<code>")
def redirect_to_url(code):
    cached = r.get(code)
    if cached:
        return redirect(cached)

    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT original_url FROM urls WHERE code = %s", (code,))
    row = cur.fetchone()
    cur.close()
    conn.close()

    if not row:
        abort(404)

    r.set(code, row["original_url"], ex=3600)
    return redirect(row["original_url"])


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000, debug=True)
