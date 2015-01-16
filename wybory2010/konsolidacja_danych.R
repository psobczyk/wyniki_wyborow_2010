#'
#' Piotr Sobczyk

obwody <- read.table(file = "140000-obwody.csv", sep = ";", header = T)
n <- 3298
dane <- as.data.frame(obwody[1:n,1:6])

miejsce <- obwody[1,7]
miejsce <- gsub("/", "", miejsce)
miejsce <- gsub(" ", "_", miejsce)
dane_obwod <- read.table(paste0("wyniki/", miejsce, ".csv"), header = T,
                         sep = ",", row.names = 2)

#UWAGA, wybieramy tylko 7 list zarejestrowanych ogólnopolsko, a więc takich, które
#będą w każdym okręgu na mazowszu. To miejsce do rozszerzenia w przyszłości
wyniki <- NULL
for(i in 1:n) {
  miejsce <- obwody[i,7]
  miejsce <- gsub("/", "", miejsce)
  miejsce <- gsub(" ", "_", miejsce)
  miejsce <- gsub("__", "_", miejsce)
  #14 komisji wyborczych nie zostało poprawnie wczytanych
  #Rzecz do poprawienia w przyszłości
  try({
    dane_obwod <- read.table(paste0("wyniki/", miejsce, ".csv"), header = T,
                           sep = ",", row.names = 1)
    wyniki <- rbind(wyniki, 
      cbind( cbind(dane[i,], 
                   t(dane_obwod[1:3, 2, drop=F]))[rep(1,nrow(dane_obwod)-3),],
             dane_obwod[4:nrow(dane_obwod),1],
             dane_obwod[4:nrow(dane_obwod),2]))}, silent = TRUE)
}

colnames(wyniki) <- c("teryt", "wojewodztwo", " kodgminy", "gmina",
                         "typ",  "obwod", "wyborcy", "oddane", "wazne", 
                         "partia", "wynik")
summary(wyniki)
write.csv(wyniki, "mazowsze2010.csv")
