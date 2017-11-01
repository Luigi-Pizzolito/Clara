#!/bin/sh

#1 is txt chache adress
#2 is ppm cache adress
#3 is aes cache adress
#4 is output adress
#5 is password

#6 is aescrypt
#7 is ppm

#cd ~/Desktop
#in app write box contents to txtcache
"${7}" c "${1}" "${2}"
"${6}" -e -p "${5}" "${2}"
#rm compressedtext1.ppm
cp "${3}" "${4}"
