#!/bin/bash 

#skrypt do znajdowania linków do komisji wyborczych w ramach jednej gminy
sed -n 's/^.*href=".*\(\/pl\/wyniki.*\)">RDW.*$/\1/p' gmina2014.html

#ustawienie wyników w jednej linii
sed '/td>$/N;s/\n/\t/' probny2014.html | sed '/td>$/N;s/\n/\t/' > nprobny2014.html

#teraz trzeba znaleźć rozmiar okręgu, frekwencje, liczbę nieważnych głosów i wyniki

obwod=`cat "$p.html" | sed -n 's/^.*Obwód nr \(.*\)<\/a>.*$/\1/p'` #numer obwodu
okreg=`cat "$p.html" | sed -n 's/^.*Okręg wyborczy nr \(.*\)<\/a>.*$/\1/p'`
miejsce=`cat "$p.html" | sed -n 's/^.*<td class="nazwa"><\/td>.*<td class="nazwa">\(.*\)<\/td>.*$/\1/p'`
wyborcow=`cat "$p.html" | sed -n 's/^.*w chwili zakończenia głosowania<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`
wydanych=`cat "$p.html" | sed -n 's/^.*„odmowa podpisu”)<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`
waznych=`cat "$p.html" | sed -n 's/^(z kart ważnych)<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`

#nazwy komitetów
cat "$p.html" | sed -n 's/^.*<td style="text-align:left;" colspan="3">\(.*\)<\/td>.*td.*$/\1/p'  > kom.csv 
#rozklad głosów
cat "$p.html" | sed -n 's/^.*<td style="text-align:left;" colspan="3">.*<\/td>.*<td>\(.*\)<\/td>.*$/\1/p' > glos.csv 

#przerabianie kodów GUSu
sed -n 's/^.*<tr><td>\(.*\) <\/td><td>\(.*\) <\/td><td>\(.*\) <\/td><td>\(.*\) <\/td><td>\(.*\) <\/td><\/tr>.*$/\1, \2, \3, \4, \5/p' kody_GUS.html > kody_GUS.csv

#adresy stron
Rscript stworz_adresy_gmin.R

#Teraz ściąganie
wget --directory-prefix=gminy2014 -i gminy_adresy

#' Teraz trzeba każdy z plików przerobić
#' Najpierw wybieramy wszystkie adresy komisji
#' Potem je łączymy w jedną tabelę
#' I zapisujemy w osobnym pliku
#' Ewentulanie każda komisja w osobnym pliku

touch komisje_adresy
FILES=gminy2014/*
for p in $FILES
do
  sed -n 's/^.*href=".*\(\/pl\/wyniki.*\)">RDW.*$/http:\/\/wybory2014.pkw.gov.pl\1/p' $p > tmp
  wget --directory-prefix=komisje2014 -i tmp
  echo `sed -n 's/^.*href=".*\(\/pl\/wyniki.*\)">RDW.*$/http:\/\/wybory2014.pkw.gov.pl\1/p' $p` >> komisje_adresy
done

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
  waznych=`cat $p | sed -n 's/^(z kart ważnych)<\/td>.*<td class="">\(.*\)<\/td>.*$/\1/p'`
  #nazwy komitetów
  cat $p | sed -n 's/^.*<td style="text-align:left;" colspan="3">\(.*\)<\/td>.*td.*$/\1/p'  > kom.csv 
  #rozklad głosów
  cat $p | sed -n 's/^.*<td style="text-align:left;" colspan="3">.*<\/td>.*<td>\(.*\)<\/td>.*$/\1/p' > glos.csv 
  Rscript polacz2014.R $obwod $kod $wyborcow $wydanych $waznych $miejsce  #połączenie w plik .csv
done