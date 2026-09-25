FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    MPLBACKEND=Agg

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

RUN python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir -r requirements.txt

COPY swrlwithimages_enhanced.py ./

RUN useradd --create-home --uid 10001 appuser \
    && mkdir -p /app/swrl_report \
    && chown -R appuser:appuser /app

USER appuser

ENTRYPOINT ["python", "swrlwithimages_enhanced.py"]
