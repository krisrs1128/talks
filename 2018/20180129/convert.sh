#!/bin/sh

for file in vae*.svg
do
    filename=$(basename $file)
    extension="${filename##*.}"
    filename="${filename%.*}"
    /usr/local/bin/inkscape -z -f "${file}" -w 2500 -e "${filename}.png"
done
