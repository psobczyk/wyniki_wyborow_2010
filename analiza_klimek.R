#' Piotr Sobczyk
#' 
#' Badanie inspirowane przez Statistical detection of systematic election irregularities
#' http://www.pnas.org/content/109/41/16469.full.pdf+html
#' 

duze.partie <- unique(dane.plik$partia)[c(1,3,4,6)]
dane.fsd <- dane.plik %>%
  filter(partia %in% duze.partie,
         wyborcy > 100) %>%
  mutate(wynik       = 100*glosy/oddane,
         frekwencja  = 100*oddane/wyborcy,
         wojewodztwo = lista.wojwodztw[floor(kod/10000)/2]) %>%
  dplyr::select(wojewodztwo, wyborcy, frekwencja, partia, wynik)

ggplot(dane.fsd, aes(y=wynik, x=frekwencja)) + 
  geom_point(shape=20, alpha=1/4, size = 0.5, col = "red") +  
  facet_grid(wojewodztwo ~ partia)+
  theme(strip.text.y = element_text(size=12, face="bold"),
        strip.background = element_rect(colour="red", fill="#CCCCFF")) +
  xlab("Frekwencja w %") +
  ylab("Poparcie w %") +
  ggtitle("Wyniki wyborów samorzadowych 2014")

ggplot(dane.fsd, aes(y=wynik, x=frekwencja)) + 
  geom_point(shape=20, alpha=1/4, size = 0.5, col = "red") +  
  theme(strip.text.y = element_text(size=12, face="bold"),
        strip.background = element_rect(colour="red", fill="#CCCCFF")) +
  xlab("Frekwencja w %") +
  ylab("Poparcie w %") +
  ggtitle("Wyniki wyborów samorzadowych 2014")

#czy rozkład frekwencji jest w przybliżeniu normalny?
ggplot(dane.fsd, aes(x=frekwencja)) + 
  geom_histogram(binwidth=.5, colour="black", fill="gray")

#ciekawe a proste porównanie asymetrii wyników
aggregate(dane.fsd$wynik, by=list(dane.fsd$partia), median)
aggregate(dane.fsd$wynik, by=list(dane.fsd$partia), mean)

dane.plot <- dane.fsd %>%
  filter(wynik>0)
library(MASS)
boxcox(dane.plot$wynik~1)
#więc bierzemy przekształcenie pierwiastkowe
ggplot(dane.plot, aes(x=scale(sqrt(wynik)))) + 
  geom_histogram(binwidth=.5, colour="black", fill="gray") + 
  facet_grid(partia ~ .) +
  theme(strip.text.y = element_text(size=12, face="bold"),
        strip.background = element_rect(colour="red", fill="#CCCCFF")) +
  xlab("Poparcie w %") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme_bw()

#Czy da się zbudować sensowny model w oparciu o frekwencje?
lm.fit <- lm(dane.fsd$wynik~dane.fsd$frekwencja)
summary(lm.fit) 
#praktycznie zerowe R^2

lm.fit2 <- lm(dane.fsd$wynik~dane.fsd$frekwencja*dane.fsd$partia)
summary(lm.fit2)
