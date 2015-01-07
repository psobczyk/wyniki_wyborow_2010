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
wyniki <- matrix(NA, ncol=10, nrow=n)
colnames(wyniki) <- rownames(dane_obwod)[1:10]
for(i in 1:n) {
  miejsce <- obwody[i,7]
  miejsce <- gsub("/", "", miejsce)
  miejsce <- gsub(" ", "_", miejsce)
  miejsce <- gsub("__", "_", miejsce)
  #14 komisji wyborczych nie zostało poprawnie wczytanych
  #Rzecz do poprawienia w przyszłości
  try({
    dane_obwod <- read.table(paste0("wyniki/", miejsce, ".csv"), header = T,
                           sep = ",", row.names = 2)
    wyniki[i,] <- dane_obwod[1:10,2]}, silent = TRUE)
}

dane <- cbind(dane, wyniki)
colnames(dane)[10:16] <- c("SLD", "PSL", "PPP","PO", "PIS", "NOP", "PR")
colnames(dane)[1:9] <- c("Teryt", "wojewodztwo", " kodgminy", "gmina",
                         "typ",  "obwod", "wyborcy", "oddane", "wazne")
colnames(dane) <- tolower(colnames(dane))
summary(dane)
write.csv(dane, "wyniki_mazowsze.csv")

