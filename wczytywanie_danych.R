#' 
#' Piotr Sobczyk
#' wczytanie danych, obróbka do postaci łatwiejszej do analizy i rysowania wykresów
#' 

library(ggplot2)
library(dplyr)

dane.plik <- read.csv("wyniki_calosc.csv", header=F)
colnames(dane.plik) <- c("kod", "obwod", " adres", "wyborcy", "oddane",
                         "wyjete", "wazne", "partia", "glosy")
lista.wojwodztw <- read.csv("wojewodztwa.csv", header=F, row.names=1)
lista.wojwodztw <- sapply(strsplit(paste(lista.wojwodztw[,1]), split = " "), 
                          function(x) x[3])
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

gminy_typ <- read.csv("kody_GUS.csv", header=F)
typ <- dane.plik$kod
miasta <- gminy_typ[gminy_typ[,2]==1,1]
wies <- gminy_typ[gminy_typ[,2]==2,1]
wiejsko.miejskie <- gminy_typ[gminy_typ[,2]==3,1]
warszawa <- gminy_typ[gminy_typ[,2]==8,1]
powiaty <- gminy_typ[grepl("M. ", x= gminy_typ[,3]),1]

typ[dane.plik$kod%in%miasta] <- "małe miasto"
typ[dane.plik$kod%in%wies] <- "wies"
typ[dane.plik$kod%in%wiejsko.miejskie] <- "miejsko-wiejskie"
typ[dane.plik$kod%in%warszawa] <- "duze miasto"
typ[dane.plik$kod%in%powiaty] <- "duze miasto"
dane.plik <- cbind(dane.plik, typ)
dane <- dane.plik %>%
  mutate(frekwencja  = 100*wyjete/wyborcy,
         niewazne    = 100*(1-wazne/wyjete),
         wynik       = 100*glosy/wazne,
         wojewodztwo = lista.wojwodztw[floor(kod/10000)/2]) %>%
  dplyr::select(kod, typ, wojewodztwo, powiat, wyborcy, frekwencja, niewazne, partia, wynik, glosy)
