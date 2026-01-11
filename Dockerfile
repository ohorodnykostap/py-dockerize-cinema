FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /app/

CMD ["sh", "-c", "python manage.py wait_for_db && python manage.py migrate && python manage.py collectstatic --noinput && gunicorn cinema_service.wsgi:application --bind 0.0.0.0:8000"]
