FROM python:3.11-slim

WORKDIR /app

# Git ve FFMPEG kurulumu
RUN apt-get update && apt-get install -y ffmpeg git && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir --force-reinstall --upgrade git+https://github.com/ShuShuzinhuu/SpotiFLAC-Module-Version.git@refs/pull/27/head

# === GOD MODE YAMASI (Python Çekirdek Yaması) ===
# Python'un klasör yaratma kuralını, sistemin en derinine (sitecustomize) yazıyoruz.
RUN cat <<'EOF' > /usr/local/lib/python3.11/site-packages/sitecustomize.py
import os, shutil

original_rename = os.rename
original_replace = os.replace
original_move = shutil.move

def safe_rename(src, dst, *args, **kwargs):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    return original_rename(src, dst, *args, **kwargs)

def safe_replace(src, dst, *args, **kwargs):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    return original_replace(src, dst, *args, **kwargs)

def safe_move(src, dst, *args, **kwargs):
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    return original_move(src, dst, *args, **kwargs)

os.rename = safe_rename
os.replace = safe_replace
shutil.move = safe_move
EOF
# ===============================================

COPY app.py .
COPY templates/ templates/

EXPOSE 5000

CMD ["gunicorn", "--workers", "1", "--threads", "4", "--bind", "0.0.0.0:5000", "app:app"]
