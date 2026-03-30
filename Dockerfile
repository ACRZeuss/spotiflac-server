FROM python:3.11-slim

WORKDIR /app

# Gerekli sistem paketlerini kur (ffmpeg ses dönüştürme için şart)
RUN apt-get update && apt-get install -y git ffmpeg && rm -rf /var/lib/apt/lists/*

# Web arayüzü gereksinimlerini kopyala ve kur
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Orijinal SpotiFLAC CLI deposunu klonla ve onun bağımlılıklarını kur
RUN git clone https://github.com/jelte1/SpotiFLAC-Command-Line-Interface.git
RUN pip install --no-cache-dir -r SpotiFLAC-Command-Line-Interface/requirements.txt

# Kendi yazdığımız dosyaları konteynere aktar
COPY app.py .
COPY templates/ templates/

EXPOSE 5000

CMD ["python3", "app.py"]