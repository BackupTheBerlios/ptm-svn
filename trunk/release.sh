#!/bin/bash

VER=$1
SVNDIR=`pwd`

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

for i in FAQ Makefile.am autogen.sh configure.in; do 
	cp ../users/damjanek/release/$i ~/man-pages-pl/; 
done

cd ~/man-pages-pl

for i in man*; do 
	cat $SVNDIR/users/damjanek/release/Makefile.am.manX > ~/man-pages-pl/Makefile.am.$i
	ls ~/man-pages-pl/$i | sed -e '$!s/$/\ \\/' >>~/man-pages-pl/Makefile.am.$i
	mv ~/man-pages-pl/Makefile.am.$i ~/man-pages-pl/$i/Makefile.am
done


for i in NEWS README AUTHORS ChangeLog; do touch ~/man-pages-pl/$i; done


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
