# 🎵 SpotiFLAC Server (WebUI)

A lightweight, modern, and asynchronous web interface for the [SpotiFLAC](https://pypi.org/project/SpotiFLAC/) command-line tool. Built with Python, Flask, and Docker, this project is designed specifically to seamlessly integrate with media servers like Navidrome, Plex, or Jellyfin via Runtipi.

![UI Preview](https://img.shields.io/badge/UI-Modern_Dark_Theme-1DB954?style=flat-square)
![Localization](https://img.shields.io/badge/i18n-EN%20%7C%20TR-blueviolet?style=flat-square)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=flat-square&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=flat-square&logo=python&logoColor=white)

## ✨ Features

* **Modern Web Interface:** A beautifully crafted, responsive dark theme inspired by modern music streaming platforms.
* **Bilingual Support (i18n):** Instantly switch between English and Turkish UI directly from the web interface.
* **Asynchronous Downloads:** Non-blocking background downloads. You can queue a massive playlist, and the UI will poll the status without browser timeouts.
* **Production Ready:** Powered by Gunicorn (multi-threaded) to handle requests reliably and efficiently.
* **Built-in Library Viewer:** View your downloaded audio files directly from the web interface without needing to SSH into your server.
* **Customizable Settings:** Choose your preferred source service (Tidal, Qobuz, Deezer, Amazon) and output folder structure (e.g., Artist/Album layout) via a sleek dropdown menu.
* **Media Server Friendly:** Perfect for feeding high-fidelity FLAC files directly into your self-hosted music library.
* **Runtipi Optimized:** Includes necessary configurations to run effortlessly as a Custom App behind Runtipi's reverse proxy.

## 🚀 Installation

### Option A: Deployment via Runtipi (Recommended)

If you are using [Runtipi](https://runtipi.io/) to manage your home server, follow these steps to integrate the app smoothly:

1. **Clone the repository to your server:**

   ```bash
   git clone https://github.com/ACRZeuss/spotiflac-server.git
   cd spotiflac-server
   ```

2. **Build the Docker image locally:**

    ```bash
    docker build -t spotiflac-server:latest .
    ```

    Add as a Custom App in Runtipi:

    1. Open your Runtipi Dashboard -> App Store -> Add Custom App.
    2. Name it spotiflac.
    3. Paste the following YAML configuration:

    ```yaml
    services:
      spotiflac:
        image: spotiflac-server:latest
        container_name: spotiflac-server
        volumes:
          # Maps to Runtipi's default music directory
          - /opt/runtipi/media/music:/downloads
        restart: unless-stopped
        x-runtipi:
          is_main: true
          internal_port: 5000

    x-runtipi:
      schema_version: 2
    ```

    Click Install. You can now access SpotiFLAC Server directly from your Runtipi dashboard!

### Option B: Standalone Docker Compose

If you are not using Runtipi, you can run it using standard Docker Compose:

1. **Clone the repository:**

    ```bash
    git clone https://github.com/ACRZeuss/spotiflac-server.git
    cd spotiflac-server
    ```

2. **Edit docker-compose.yml (Optional):**

   Change the volume path from `/opt/runtipi/media/music` to your preferred local music directory.

   Build and start the container:

    ```bash
    docker compose up -d --build
    ```

   Access the web interface at `http://<your-server-ip>:5000`.

### ⚙️ Usage

1. Open the web interface.

2. Select your preferred language (EN/TR) from the top right corner.

3. Expand the Download Settings panel to select your source (Tidal, Qobuz, etc.) and folder layout.

4. Paste a Spotify track, album, or playlist URL into the input field.

5. Click Download.

6. The UI will display the live progress. Once completed, the files will automatically appear in the Library section below and sync with your media server.

## FAQ

<details>
<summary>Is this software free?</summary>

_Yes. This software is completely free.
You do not need an account, login, or subscription.
All you need is an internet connection._

</details>

<details>
<summary>Can using this software get my Spotify account suspended or banned?</summary>

_No.
This software has no connection to your Spotify account.
Spotify data is obtained through reverse engineering of the Spotify Web Player, not through user authentication._

</details>

<details>
<summary>Where does the audio come from?</summary>

_The audio is fetched using third-party APIs._

</details>

<details>
<summary>Why does metadata fetching sometimes fail?</summary>

_This usually happens because your IP address has been rate-limited.
You can wait and try again later, or use a VPN to bypass the rate limit._

</details>

<details>
<summary>Why does Windows Defender or antivirus flag or delete the file?</summary>

_This is a false positive.
It likely happens because the executable is compressed using UPX._

_If you are concerned, you can fork the repository and build the software yourself from source._

</details>

<details>
<summary>Want to support the project?</summary>

_If this software is useful and brings you value,
consider supporting the project by buying me a coffee.
Your support helps keep development going._

</details>

## Other projects

### [SpotiFLAC (Desktop)](https://github.com/afkarxyz/SpotiFLAC)

Download music in true lossless FLAC from Tidal, Qobuz & Amazon Music available for Windows, macOS & Linux.

### [SpotiFLAC Next](https://github.com/afkarxyz/SpotiFLAC-Next)

Get Spotify tracks in true FLAC from Tidal, Qobuz, Amazon Music & Deezer — no account required.

### [SpotiDownloader](https://github.com/afkarxyz/SpotiDownloader)

Get Spotify tracks, albums, playlists and discography in MP3 and FLAC.

### [SpotubeDL](https://spotubedl.com)

Download Spotify Tracks, Albums, Playlists as MP3/OGG/Opus with High Quality.

### [SpotiFLAC (Mobile)](https://github.com/zarzet/SpotiFLAC-Mobile)

SpotiFLAC for Android & iOS — maintained by [@zarzet](https://github.com/zarzet)

### [SpotiFLAC (CLI)](https://github.com/Nizarberyan/SpotiFLAC)

SpotiFLAC for command-line environments — maintained by [@Nizarberyan](https://github.com/Nizarberyan)

### [SpotiFLAC (Python Module)](https://github.com/ShuShuzinhuu/SpotiFLAC-Module-Version)

SpotiFLAC Python library for SpotiFLAC integration — maintained by [@ShuShuzinhuu](https://github.com/ShuShuzinhuu)

### 🛠️ Tech Stack

- Backend: Python, Flask, Gunicorn

- Frontend: HTML5, CSS3, Vanilla JS (AJAX Polling, DOM Manipulation)

- Core Downloader: SpotiFLAC (PyPI)

- Audio Processing: FFmpeg

- Containerization: Docker

### 📝 License

**This project is open-source. The core downloading logic belongs to the original SpotiFLAC developers. This repository provides a modern, containerized Web UI wrapper to enhance the user experience and simplify deployments on home servers.**