 #!/bin/bash 

echo "" > plik.txt
for file in okregi_linki/*.html
do
    echo $file
    #adresy z danymi dla komisji obwodowych
    cat $file | sed -n 's/^.*href=".*\(\/obw\/pl.*\.html\).*\.html.*$/\1/p' >> plik.txt
done
#nazwy ściąganych stron
cat plik.txt | sed -n 's/^.*\/obw\/pl\/[0-9]*\/\(.*\)\.html.*$/\1/p' > nazwy.txt 

#ściąganie stron poleceniem wget
# prev="http://wybory2010.pkw.gov.pl"
# while read p; do
#   wget "$prev$p"
#   echo "$prev$p"
# done < plik.txt

# #przetwarzanie ściągniętych stron
# while read p; do
#   obwod=`cat "$p.html" | sed -n 's/^.*Obwód nr \(.*\)<\/a>.*$/\1/p'` #numer obwodu
#   okreg=`cat "$p.html" | sed -n 's/^.*Okręg wyborczy nr \(.*\)<\/a>.*$/\1/p'`
#   miejsce=`cat "$p.html" | sed -n 's/^.*Komisji Wyborczej<\/td><td>\(.*\)<\/td>.*$/\1/p'`
#   wyborcow=`cat "$p.html" | sed -n 's/^.*Liczba wyborców<\/td><td>\(.*\)<\/td>.*$/\1/p' | tr -d " "`
#   wydanych=`cat "$p.html" | sed -n 's/^.*Liczba kart oddanych<\/td><td>\(.*\)<\/td>.*$/\1/p' | tr -d " "`
#   waznych=`cat "$p.html" | sed -n 's/^.*Liczba głosów ważnych<\/td><td>\(.*\)<\/td>.*$/\1/p' | tr -d " "`
#   cat "$p.html" | sed '/^.*%.*%.*$/d' | sed -n 's/^.*width:\(.*\)%.*$/\1/p' > glos.csv #rozklad głosów
#   cat "$p.html" | sed -n 's/^.*Lista nr.*\(KOMITET.*\)<\/a>.*$/\1/p' > kom.csv #nazwy komitetów
#   Rscript polacz.R $wyborcow $wydanych $waznych $miejsce #połączenie w plik .csv
#   #echo "$p.html"
#   echo $miejsce #nazwa komisji obwodowej
# done < nazwy.txt

