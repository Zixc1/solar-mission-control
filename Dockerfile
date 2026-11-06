FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    MPLBACKEND=Agg \
    MPLCONFIGDIR=/tmp/matplotlib \
    XDG_CACHE_HOME=/tmp/cache \
    HOME=/tmp

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      g++ \
      git \
      libgl1 \
      libglib2.0-0 \
      libxml2 \
      libxslt1.1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN python -m pip install --upgrade pip setuptools wheel \
    && python -m pip install -r requirements.txt

COPY solar_mission_control.py ./

RUN useradd --create-home --uid 10001 smc \
    && mkdir -p /app/swrl_report /tmp/matplotlib /tmp/cache \
    && chown -R smc:smc /app /tmp/matplotlib /tmp/cache

USER smc

EXPOSE 8080
ENTRYPOINT ["python", "solar_mission_control.py"]
CMD ["health"]
