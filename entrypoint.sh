#!/bin/sh
set -e

# ensure env is set (you can choose folder or file)
: "${GDRIVE_FOLDER_ID:?Need GDRIVE_FOLDER_ID}"
# re-export in case entrypoint overrides
export XDG_CACHE_HOME=/data/.cache
export HOME=/data

echo "⬇️  Downloading all files from Drive folder…"
gdown --folder "https://drive.google.com/drive/folders/${GDRIVE_FOLDER_ID}" -O /data/

echo "🚀  Launching TileServer-GL…"
exec tileserver-gl --config /data/config.json
