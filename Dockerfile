# Python 3.10 slim alap
FROM python:3.10-slim

# --- Alap csomagok + build eszközök + GUI dependencies ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
	openbox \
    xvfb \
    x11vnc \
	x11-xserver-utils \
	x11-utils \
	tigervnc-standalone-server \
	wget curl git procps \
    python3-dev \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-xinput0 \
    libxcb-xkb1 \
    novnc \
    websockify \
    curl \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Munka könyvtár
WORKDIR /app

# Repo klónozása
RUN git clone https://github.com/CommonRoad/commonroad-scenario-designer.git /app

# Minimal pip requirements a pyproject.toml alapján
RUN echo "commonroad-io>=2024.2,<=2024.3\ncommonroad-clcs>=2025.1\ncommonroad-drivability-checker==2025.1\ncommonroad-sumo>=2025.1.3\npyqt6>=6.6.0\nmatplotlib>=3.6.0\nnumpy>=1.26.1\nscipy>=1.11.3\nlxml>=6.0.2\npyproj>=3.4.1\nutm>=0.7.0\nmgrs>=1.4.5\nshapely>=2.0.1\nnetworkx>=3.0\npyyaml>=6.0\nrequests>=2.31.0\npandas>=2.0.2\ntyper==0.9.0\nclick==8.0.4" > requirements.txt

# Python csomagok telepítése
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir .

# Wrapper script és supervisord beállítások
COPY start_crdesigner.sh /app/start_crdesigner.sh
RUN chmod +x /app/start_crdesigner.sh

RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Portok: 5900 VNC, 6080 noVNC
EXPOSE 5900 6080

ENV DISPLAY=:1
ENV QT_QPA_PLATFORM=xcb
ENV QT_X11_NO_MITSHM=1

# Konténer indítása supervisord-dal
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
