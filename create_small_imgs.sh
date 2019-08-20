#!/bin/bash
newsize=${1:-30}
for dir in $(find content/gallery/images -maxdepth 1 -type d ! -path content/gallery/images)
do
    echo ${dir}
    mkdir -p ${dir}/small
    find ${dir} -maxdepth 1 -iname "*.[jpg][png][jpeg]" -type f -printf "%f\n" \
        | xargs -L1 -I{} convert -resize $newsize% ${dir}/"{}" ${dir}/small/"{}"
done
