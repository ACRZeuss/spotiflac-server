FROM python:3.11-slim

WORKDIR /app

# Gerekli sistem paketlerini kur (artık git'e gerek yok, sadece ses dönüştürme için ffmpeg yeterli)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Hem web arayüzü gereksinimlerini hem de resmi SpotiFLAC paketini kur
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir SpotiFLAC

COPY app.py .
COPY templates/ templates/

EXPOSE 5000

CMD ["python3", "app.py"]