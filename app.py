from flask import Flask, request, render_template, jsonify
import subprocess
import threading
import uuid
import os

app = Flask(__name__)
DOWNLOAD_DIR = "/downloads"

# Görev durumlarını bellekte tutacağımız basit bir sözlük
tasks = {}

def run_download(task_id, url):
    """Arka planda çalışacak asıl indirme fonksiyonu"""
    try:
        # spotiflac komutuna sanatçı ve albüm klasörü oluşturma parametreleri eklendi
        process = subprocess.run(
            [
                "spotiflac", 
                url, 
                DOWNLOAD_DIR,
                "--use-artist-subfolders",
                "--use-album-subfolders"
            ],
            capture_output=True, 
            text=True
        )
        
        if process.returncode == 0:
            tasks[task_id] = {"status": "completed", "message": "İndirme başarıyla tamamlandı!", "log": process.stdout}
        else:
            tasks[task_id] = {"status": "error", "message": "Bir hata oluştu.", "log": process.stderr}
            
    except Exception as e:
        tasks[task_id] = {"status": "error", "message": str(e), "log": ""}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/download', methods=['POST'])
def download():
    url = request.form.get('url')
    if not url:
        return jsonify({"status": "error", "message": "Lütfen bir Spotify linki girin."}), 400

    # Benzersiz bir görev ID'si oluştur ve durumu 'processing' olarak kaydet
    task_id = str(uuid.uuid4())
    tasks[task_id] = {"status": "processing", "message": "İndirme arka planda devam ediyor...", "log": ""}
    
    # İndirme işlemini arka plan thread'inde başlat
    thread = threading.Thread(target=run_download, args=(task_id, url))
    thread.start()
    
    # Kullanıcıya bekletmeden task_id'yi döndür
    return jsonify({"status": "started", "task_id": task_id})

@app.route('/status/<task_id>', methods=['GET'])
def status(task_id):
    """Ön yüzün belirli aralıklarla durumu sorgulayacağı uç nokta"""
    task = tasks.get(task_id)
    if not task:
        return jsonify({"status": "error", "message": "Görev bulunamadı."}), 404
    
    return jsonify(task)

@app.route('/files', methods=['GET'])
def list_files():
    """İndirme klasöründeki ses dosyalarını bulur ve listeler"""
    files_list = []
    # Klasörü ve alt klasörleri (Sanatçı/Albüm yapısı) tara
    for root, dirs, files in os.walk(DOWNLOAD_DIR):
        for file in files:
            # Sadece ses dosyalarını filtrele
            if file.lower().endswith(('.flac', '.mp3', '.m4a', '.ogg', '.wav')):
                rel_dir = os.path.relpath(root, DOWNLOAD_DIR)
                if rel_dir == ".":
                    files_list.append(file)
                else:
                    files_list.append(os.path.join(rel_dir, file))
                    
    # Alfabetik sıraya dizip JSON olarak döndür
    return jsonify({"files": sorted(files_list)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)