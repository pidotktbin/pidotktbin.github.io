#!/bin/sh

PREFIX=${PREFIX:-/workspace/ComfyUI/models}

get() {
    url=$2
    path=$1

    redirect_url="$(curl -vI "$url" 2>&1 | grep filename | tail -n1 | sed "s/location: //g;s/\'//g")"
    name="$(curl "$url" -vI 2>&1 | grep filename | tail -n1 | sed 's/.*filename%3D%22\([^%]*\)%22.*/\1/g')"

    wget "$redirect_url" -O "$PREFIX/$path/$name"
}

get checkpoints "https://civitai.com/api/download/models/493469?type=Model&format=SafeTensor&size=full&fp=fp16" # pvc
get checkpoints "https://civitai.com/api/download/models/290640?type=Model&format=SafeTensor&size=pruned&fp=fp16" # ponyxl
get checkpoints "https://civitai.com/api/download/models/108289?type=Model&format=SafeTensor&size=pruned&fp=fp16" # meina pastel
get checkpoints "https://civitai.com/api/download/models/230869?type=Model&format=SafeTensor&size=pruned&fp=fp16" # gyoza
get checkpoints "https://civitai.com/api/download/models/266360?type=Model&format=SafeTensor&size=pruned&fp=fp16" # flat2d
get checkpoints "https://civitai.com/api/download/models/48881?type=Model&format=SafeTensor&size=pruned&fp=fp16" # camellia
get checkpoints "https://civitai.com/api/download/models/105924?type=Model&format=SafeTensor&size=pruned&fp=fp16" # cetus
get checkpoints "https://civitai.com/api/download/models/5038?type=Model&format=SafeTensor&size=full&fp=fp16" # aom2 hard
get checkpoints "https://civitai.com/api/download/models/9355?type=Pruned%20Model&format=SafeTensor&size=pruned&fp=fp16" # alternate aom2
# tponyai, login required
# get checkpoints "https://civitai.com/api/download/models/673299?type=Model&format=SafeTensor&size=full&fp=bf16"
get embeddings "https://civitai.com/api/download/models/9208?type=Model&format=SafeTensor&size=full&fp=fp16" # ez neg
