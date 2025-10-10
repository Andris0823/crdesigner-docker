# Python 3.10 slim alap
FROM python:3.10-slim

# --- Alap csomagok + build eszközök + GUI dependencies ---
# HOZZÁADVA: python3-pyxdg az Openbox hibaüzenet javítására
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
    python3-pyxdg \
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

# A legfrissebb verzió klónozása
RUN git clone https://github.com/CommonRoad/commonroad-scenario-designer.git .

# --- A pyproject.toml alapján készítünk egy TELJES requirements.txt fájlt, a 'typer' verzióját felülírva ---
RUN echo "commonroad-io>=2024.2,<=2024.3\n\
commonroad-clcs>=2025.1\n\
commonroad-drivability-checker>=2025.1\n\
commonroad-sumo>=2025.1.3\n\
pyqt6>=6.6.0\n\
matplotlib>=3.6.0\n\
numpy>=1.26.1\n\
scipy>=1.11.3\n\
lxml>=6.0.2\n\
pyproj>=3.4.1\n\
utm>=0.7.0\n\
mgrs>=1.4.5\n\
shapely>=2.0.1\n\
ordered-set>=4.1.0\n\
iso3166>=2.1.1\n\
networkx>=3.0\n\
omegaconf>=2.3.0\n\
pyyaml>=6.0\n\
pygeodesy>=23.3.23\n\
mercantile>=1.2.1\n\
urllib3>=2.0.3\n\
typer>=0.12.3\n\
typing-extensions>=4.8.0\n\
antlr4-python3-runtime==4.9.3\n\
pymetis>=2020.1\n\
similaritymeasures>=0.4.4\n\
kdtree>=0.16\n\
pandas>=2.0.2\n\
requests>=2.31.0\n\
pyclothoids>=0.1.5" > requirements.txt

# Python csomagok telepítése
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir --no-deps .

# Wrapper script és supervisord beállítások
COPY start-gui.sh /app/start-gui.sh
RUN chmod +x /app/start-gui.sh

RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Portok: 5900 VNC, 6080 noVNC
EXPOSE 5900 6080

ENV DISPLAY=:1
ENV QT_QPA_PLATFORM=xcb
ENV QT_X11_NO_MITSHM=1

# Konténer indítása supervisord-dal
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
