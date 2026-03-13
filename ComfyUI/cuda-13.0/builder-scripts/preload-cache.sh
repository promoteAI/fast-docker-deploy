#!/bin/bash

set -euo pipefail

# 中国加速：GitHub 镜像代理（可选，通过 GITHUB_MIRROR 环境变量控制）
GITHUB_MIRROR="${GITHUB_MIRROR:-https://wget.la/https://github.com}"

gcs() {
    local url="$1"
    [[ "$url" == https://github.com/* ]] && url="${GITHUB_MIRROR}/${url#https://github.com/}"
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$url" "${@:2}"
}

echo "########################################"
echo "[INFO] Downloading ComfyUI & Nodes..."
echo "########################################"

mkdir -p /default-comfyui-bundle
cd /default-comfyui-bundle
git clone "${GITHUB_MIRROR}/comfyanonymous/ComfyUI.git"
cd /default-comfyui-bundle/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes
gcs https://github.com/Comfy-Org/ComfyUI-Manager.git

# Force ComfyUI-Manager to use PIP instead of UV
mkdir -p /default-comfyui-bundle/ComfyUI/user/__manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/config.ini
[default]
use_uv = False
security_level = weak
EOF

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

cd /default-comfyui-bundle/ComfyUI/models/vae_approx
gcs https://github.com/madebyollin/taesd.git
cp taesd/*.pth .
rm -rf taesd
