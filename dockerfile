# Enable build-arg substitution
# syntax=docker/dockerfile:1

FROM maptiler/tileserver-gl:latest

# 1) Accept your Drive folder ID as a build-arg
ARG GDRIVE_FOLDER_ID

# 2) Become root to install gdown and Python
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-pip \
 && pip3 install --no-cache-dir gdown \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /data

# 3) Download ALL MBTiles at build time (using --continue to handle large files)
#    The folder will be flattened into /data.
RUN export XDG_CACHE_HOME=/data/.cache \
 && mkdir -p /data/.cache \
 && gdown --continue --folder "https://drive.google.com/drive/folders/${GDRIVE_FOLDER_ID}" -O /data \
 && rm -rf /data/.cache \
 && pip3 uninstall -y gdown

# 4) Copy in your TileServer config
COPY config.json /data/config.json

# 5) Expose the HTTP port
EXPOSE 8080

# 6) Launch TileServer-GL directly (no entrypoint script needed)
ENTRYPOINT ["tileserver-gl", "--config", "/data/config.json"]
