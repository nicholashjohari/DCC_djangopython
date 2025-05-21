# === Stage 1: Build dependencies ===
FROM python:3.11-slim AS build

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc && \
    rm -rf /var/lib/apt/lists/*

RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# === Stage 2: Final image ===
FROM python:3.11-slim

ENV PATH="/app/venv/bin:$PATH"
WORKDIR /app

COPY --from=build /app/venv /app/venv

COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
