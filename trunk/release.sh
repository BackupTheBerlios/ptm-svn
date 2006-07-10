#!/bin/bash

VER=$1

mkdir ~/man-pages-pl

for i in `echo {1..9}`; 
	do mkdir -p ~/man-pages-pl/man$i; 
done

cd man-pages

for i in *; do 
	cd $i
	for j in *; do 
		cp $j ~/man-pages-pl/man`echo $j | sed -e 's/.*\([0-9]$\)/\1/'`&>/dev/null; 
	done
	cd ..;
done

cd ~/
tar cjf ~/man-pages-pl-$VER-u8.tar.bz2 man-pages-pl

echo "UTF8 release: ~/man-pages-pl-$VER-u8.tar.bz2"

cd ~/man-pages-pl

for i in man*; do
	cd $i
	recode u8..l2 * &>/dev/null
	cd ..
done

cd ~/

tar cjf ~/man-pages-pl-$VER-l2.tar.bz2 man-pages-pl

echo "ISO-8859-2 release: ~/man-pages-pl-$VER-l2.tar.bz2"

rm -Rf ~/man-pages-pl
