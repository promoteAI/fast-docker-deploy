# 拉取代码
git clone https://wget.la/https://github.com/vllm-project/vllm-omni.git

# 注释
requirements/cuda.txt 中fa3-fwd库

# 从flash_attn官方发布的whl下载
flash_attn-2.8.3+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl 
# 构建
docker build -f Dockerfile.gb10 .