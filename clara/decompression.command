#!/bin/bash

#1 is input adress
#2 is aescache
#3 is ppm cache
#4 is txt cache
#5 is password

#6 is aescrypt
#7 is ppm

#cd ~/Desktop
#rm "${2}"
cp "${1}" "${2}"
"${6}" -d -p "${5}" "${2}"
"${7}" d "${3}" "${4}"
#in app write txtcache to box contents
#rm test.c
