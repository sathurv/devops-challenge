# ---- Stage 1: Build ----- #
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Stage 2: Runtime ----- #
FROM python:3.12-slim

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

COPY --from=builder /install /usr/local

COPY app.py .

USER appuser

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]