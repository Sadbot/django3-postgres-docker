### Final image
FROM python:3.7

RUN groupadd -r sweam && useradd -r -g sweam sweam

ARG STATIC_URL
ENV STATIC_URL ${STATIC_URL:-/static/}

RUN apt-get update \
  && apt-get install -y \
    libxml2 \
    libssl1.1 \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    shared-mime-info \
    mime-support \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app /app/media /app/static /app/static/assets
WORKDIR /app
COPY requirements.txt /app/
RUN pip install -r requirements.txt
COPY . /app/

RUN SECRET_KEY=${SECRET_KEY} STATIC_URL=${STATIC_URL} python3 manage.py collectstatic --no-input

RUN chown -R sweam:sweam /app/

EXPOSE 8000

CMD ["uvicorn", "sweam.asgi:application"]
