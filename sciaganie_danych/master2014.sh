#!/bin/bash 

#przerabianie kodów GUSu
sed -n 's/^.*<tr><td>\(.*\) <\/td><td>\(.*\) <\/td><td>\(.*\) <\/td><td>\(.*\) <\/td><td>\(.*\) <\/td><\/tr>.*$/\1\2\3, \4, \5/p' gminy_powiaty.txt > kody_GUS.csv
sed -n 's/^.*<tr bgcolor="ddeeff"><td>\(.*\) <\/td><td>\(.*\) <\/td><td> <\/td><td colspan=2>\(.*\) <\/td><\/tr>.*$/\1, \2, \3/p' gminy_powiaty.txt  > powiaty.csv

#adresy stron
Rscript stworz_adresy_gmin.R

#Teraz ściąganie stron dla każdej gminy
wget --directory-prefix=gminy2014 -i gminy_adresy

#' Teraz trzeba każdy z plików przerobić
#' Najpierw wybieramy wszystkie adresy komisji
#' Potem je łączymy w jedną tabelę

rm temp
touch temp
FILES=gminy2014/*
for p in $FILES
do
  echo `sed -n 's/^.*href=".*\(\/pl\/wyniki.*\)">RDW.*$/http:\/\/wybory2014.pkw.gov.pl\1/p' $p` >> temp
done
sed -e 's/\s\+/\n/g' temp > komisje_adresy
wget --directory-prefix=komisje2014 -i komisje_adresy

FILES=komisje2014/*
for p in $FILES
do
  sed '/td>$/N;s/\n/\t/' $p | sed '/td>$/N;s/\n/\t/' > temp2
  p=temp2
  obwod=`cat $p | sed -n 's/^.*Protokół z obwodu nr. \(.*\)<\/div>.*$/\1/p'`
  kod=`cat $p | sed -n 's/^.*<td class="nazwa">\(.*[0-9]\{6\}.*\)<\/td>.*$/\1/p'`
  miejsce=`cat $p | sed -n 's/^.*<td class="nazwa"><\/td>.*<td class="nazwa">\(.*\)<\/td>.*$/\1/p'`
  wyborcow=`cat $p | sed -n 's/^.*w chwili zakończenia głosowania<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`
  wydanych=`cat $p | sed -n 's/^.*„odmowa podpisu”)<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`
  wyjetych=`cat $p | sed -n 's/^.*kart wyjętych z urny<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`
  waznych=`cat $p | sed -n 's/^(z kart ważnych)<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`
  #nazwy komitetów
  cat $p | sed -n 's/^.*<td style="text-align:left;" colspan="3">\(.*\)<\/td>.*td.*$/\1/p'  > kom.csv 
  #rozklad głosów
  cat $p | sed -n 's/^.*<td style="text-align:left;" colspan="3">.*<\/td>.*<td>\(.*\)<\/td>.*$/\1/p' > glos.csv 
  Rscript polacz2014.R $obwod $kod $wyborcow $wydanych $wyjetych $waznych $miejsce  #połączenie w plik .csv
done