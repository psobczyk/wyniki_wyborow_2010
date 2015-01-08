#' 
#' Piotr Sobczyk
#' wczytanie danych, obróbka do postaci łatwiejszej do analizy i rysowania wykresów
#' 

library(ggplot2)
library(dplyr)

dane.plik <- read.csv("wyniki_calosc.csv", header=F)
colnames(dane.plik) <- c("kod", "obwod", " adres", "wyborcy", "oddane", "wazne", "partia", "glosy")
#colnames(dane.plik) <- c("kod", "obwod", " adres", "wyborcy", "oddane", "wyjete", "wazne", "partia", "glosy")
lista.wojwodztw <- read.csv("wojewodztwa.csv", header=F, row.names=1)
lista.wojwodztw <- sapply(strsplit(paste(lista.wojwodztw[,1]), split = " "), function(x) x[3])
lista.powiatow <- read.csv("powiaty.csv", header=F)
message("Wczytano dane z pliku")

#to powinno być przepisane
pow <- floor((dane.plik$kod/100)%%100)
woj <- floor(dane.plik$kod/10000)
powiat <- sapply(1:length(pow), function(i){
  j <- which(lista.powiatow[,1]==woj[i] & lista.powiatow[,2]==pow[i])
  lista.powiatow[j,3] })
dane.plik <- cbind(dane.plik, powiat)
message("Przetworzono dane o powiatach")

dane <- dane.plik %>%
  mutate(frekwencja  = 100*oddane/wyborcy,
         niewazne    = 100*(1-wazne/oddane),
         wynik       = 100*glosy/oddane,
         wojewodztwo = lista.wojwodztw[floor(kod/10000)/2]) %>%
  select(kod, wojewodztwo, powiat, wyborcy, frekwencja, niewazne, partia, wynik)
# dane <- dane.plik %>%
#   mutate(frekwencja  = 100*wyjete/wyborcy,
#          niewazne    = 100*(1-wazne/wyjete),
#          wynik       = 100*glosy/wyjete,
#          wojewodztwo = lista.wojwodztw[floor(kod/10000)/2]) %>%
#   select(kod, wojewodztwo, powiat, frekwencja, niewazne, partia, wynik)
