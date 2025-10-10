# --- STAGE 1: The "Builder" ---
FROM python:3.10-bookworm as builder

# Install all build-time and runtime OS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git python3-dev build-essential openbox tigervnc-standalone-server \
    python3-pyxdg novnc websockify supervisor libglib2.0-0 libsm6 \
    libxrender1 libxext6 libgl1-mesa-dev libglu1-mesa-dev libxkbcommon0 \
    libxkbcommon-x11-0 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
    libxcb-render0 libxcb-shape0 libxcb-shm0 libxcb-sync1 \
    libxcb-xfixes0 libxcb-xinput0 libxcb-xkb1 \
    && rm -rf /var/lib/apt/lists/*
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
WORKDIR /app
RUN git clone https://github.com/CommonRoad/commonroad-scenario-designer.git .
RUN pip install --no-cache-dir --no-deps .


# --- STAGE 2: The "Final" Image ---
FROM python:3.10-slim-bookworm

# Install ONLY the required runtime OS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    openbox tigervnc-standalone-server python3-pyxdg novnc websockify \
    supervisor libglib2.0-0 libsm6 libxrender1 libxext6 \
    libgl1-mesa-dev libglu1-mesa-dev libxkbcommon0 libxkbcommon-x11-0 \
    libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 libxcb-image0 \
    libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-render0 \
    libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-xfixes0 \
    libxcb-xinput0 libxcb-xkb1 \
    && rm -rf /var/lib/apt/lists/*

# Copy the application and config files
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
# THE FIX: Copy start-gui.sh from the local context, not the builder.
COPY start-gui.sh /app/start-gui.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x /app/start-gui.sh

# Set environment variables
ENV PATH="/opt/venv/bin:$PATH"
ENV DISPLAY=:1
ENV QT_QPA_PLATFORM=xcb
ENV QT_X11_NO_MITSHM=1

# Expose ports and run as default user (root)
EXPOSE 5900 6080
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
