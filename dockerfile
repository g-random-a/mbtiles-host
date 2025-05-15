FROM maptiler/tileserver-gl:latest

# 1) Install python3, pip & gdown as root
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-pip \
 && pip3 install --no-cache-dir gdown \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /data

# 2) Copy config + entrypoint
COPY config.json entrypoint.sh /data/
RUN chmod +x /data/entrypoint.sh \
    # prepare cache dir under /data
 && mkdir -p /data/.cache/gdown \
 && chown -R 1000:1000 /data

# 3) Tell both the XDG cache and HOME to live in /data
ENV XDG_CACHE_HOME=/data/.cache
ENV HOME=/data

EXPOSE 8080

# 4) Drop back to the tileserver non-root user
USER 1000

ENTRYPOINT ["/data/entrypoint.sh"]
