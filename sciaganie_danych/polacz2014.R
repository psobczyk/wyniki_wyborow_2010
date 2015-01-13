args     <- commandArgs(trailingOnly = TRUE)
obwod    <- as.numeric(args[1])
kod      <- as.numeric(args[2])
wyborcow <- as.numeric(gsub(" ", "", args[3]))
wydanych <- as.numeric(args[4])
wyjetych <- as.numeric(args[5])
waznych  <- as.numeric(args[6])
miejsce  <- args[7:length(args)]

miejsce  <- paste0(miejsce, collapse="_")
miejsce <- gsub("/", "", miejsce)
miejsce <- gsub("\"", "", miejsce)

komitety <- read.csv("kom.csv", header=F)
glosy <- read.csv("glos.csv", header=F)

dane2 <- data.frame("Kod gminy"=kod, "Numer obwodu"=obwod, "Adres"=miejsce, 
                    "Liczba wyborców"=wyborcow, "Liczba kart oddanych"=wydanych, 
                    "Liczba kart wyjętych"=wyjetych, "Liczba głosów ważnych"=waznych)
dane2 <- dane2[rep(1,nrow(komitety)),]
dane2 <- cbind(dane2, komitety, glosy)
if(any(is.na(dane2))){
  print("Błąd")
  print(miejsce)
  print(kod)
  print(obwod)
} else{
  write.table(dane2, "wyniki_calosc.csv", sep=",", row.names = FALSE, append = TRUE, col.names = FALSE)
}

# komitet  <- c("Liczba wyborców", "Liczba kart oddanych", "Liczba głosów ważnych")
# procent  <- c(wyborcow, wydanych, waznych)
# d <- data.frame(komitet, procent)
# dane <- cbind(komitety, glosy)
# colnames(dane) <- c("komitet", "procent")
# dane <- rbind(d, dane)
# 
# #musimy usunąć znak specjalny /, występuje w adresach niektórych lokali wyborczych
# miejsce <- gsub("/", "", miejsce)
# filename <- paste0("wyniki2014/", miejsce, ".csv")
# write.table(dane, filename, sep=",", row.names = FALSE)


