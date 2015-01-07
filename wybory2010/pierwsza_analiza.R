#'
#' Pierwsze modele
#' Piotr Sobczyk
#' 

library(dplyr)

dane <- read.csv("wyniki_mazowsze.csv", row.names = 1, header = T)
names(dane)

dane2 <- do.call("rbind", rep(list(dane[,1:9]), 4))
dane2[["partia"]] <- rep(colnames(dane)[c(11,13,14,10)], each = nrow(dane))
dane2[["wynik"]] <- unlist(dane[,c(11,13,14,10)])

dane3 <- dane2 %>%
  filter(wyborcy > 500) %>%
  mutate(frekwencja = 100*oddane/wyborcy,
         niewazne = 100*(1-wazne/oddane)) %>%
  select(typ, frekwencja, niewazne, partia, wynik)

lm.fit1 <- lm(wynik~., data = dane3)
summary(lm.fit1)
AIC(lm.fit1)

lm.fit2 <- lm(wynik~.^2, data = dane3)
summary(lm.fit2)
AIC(lm.fit2)

lm.fit3 <- lm(wynik~partia+typ*partia-typ+partia*niewazne-niewazne+frekwencja*partia-frekwencja,
              data = dane3)
summary(lm.fit3)
AIC(lm.fit3)

tree.fit <- rpart(wynik~., data = dane3)
plot(tree.fit)
text(tree.fit, use.n = TRUE)

pairs(~wynik+frekwencja+niewazne, data=dane3)
