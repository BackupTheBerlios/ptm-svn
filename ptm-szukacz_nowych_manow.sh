###################################################################
###	Skrypt do wyszukiwania nieprzetłumaczonych		###
###	manuali nie znajdujących się w repozytorium PTM		###
###	a następnie posortowania ich w katalogi w/g 		###
###	progrmaów i wrzucenie do repozytorium.			###
###								###
###	Skrypt należy odpalać z katalogu w którym znajduje się	###
###	katalog trunk repo.					###
###								###
###	Na działanie skryptu nie udzielam jakichkolwiek		###
###	gwarancji - używasz go na własną odpowiedzialność!	###
###								###
###	autor: Paweł Sędrowski					###
###################################################################

#! /bin/bash -

PTM_ILE=0
mkdir szukacz-temp/
for x in $(ls -1 /usr/share/man/ | grep man)		# dla kazdego katalogu *man* w /usr/share/man/
do
	PTM_W_KATALOGU=$(ls -l /usr/share/man/$x | grep -v ^l | tr -s [:blank:] | cut --delimiter=" " -f 8)
	for y in $PTM_W_KATALOGU
	do
		PTM_NAZWA=$(echo $y | cut -d . -f 1,2)
		if test "$(ls -R1 | grep $PTM_NAZWA)"	# jeżeli man jest w repo
		then
			continue
		else
			cp /usr/share/man/$x/$y szukacz-temp/
			gzip -d szukacz-temp/$y
			PTM_ROZGZIPOWANE=$(ls -1 szukacz-temp/)
			if test $(cat szukacz-temp/$PTM_ROZGZIPOWANE | wc -l) -le 2
			then
				rm -rf szukacz-temp/*
				continue
			else
				PTM_PAKIET=$(qfile -C $y | cut -d / -f 2 | cut --delimiter=" " -f 1 | uniq)	#sprawdź do jakiego pakietu man należy i wrzuć do odpowiedniego katalogu
				#echo $PTM_PAKIET		## DEBUG
				if test ! "$(echo $PTM_PAKIET)"			# jeżeli NIE udało się ustalić do jakiego pakietu należy
				then
					continue
				else
					if test $(echo $PTM_PAKIET | wc -l) -gt 1
					then
						PTM_PAKIET=$(echo $PTM_PAKIET | grep -v man-pages)
					fi
					if test ! -d "trunk/angielskie/$PTM_PAKIET"
					then
						svn mkdir trunk/angielskie/$PTM_PAKIET
					fi
					cp szukacz-temp/$PTM_ROZGZIPOWANE trunk/angielskie/$PTM_PAKIET/
					rm -rf szukacz-temp/*
					svn add trunk/angielskie/$PTM_PAKIET/$PTM_ROZGZIPOWANE
					echo $((PTM_ILE++)) >> /dev/null
				fi
			fi
		fi
	done
done

rm -rf szukacz-temp/
echo $PTM_ILE

unset -v PTM_ILE PTM_PAKIET PTM_NAZWA PTM_W_KATALOGU x y