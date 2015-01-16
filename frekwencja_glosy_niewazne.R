#' 
#' Piotr Sobczyk
#' Analiza zależności wyników, frekwencji i głosów nieważnych
#' w podziale na typ miejscowości 
#' 

source("wczytywanie_danych.R")
library(splines)

# Jak frekwencja i głosy nieważne zależą od typu miejscowości
dane %>%
  filter(wyborcy>100) %>%
  select(typ, niewazne) %>%
  distinct %>%
  ggplot(aes(x=niewazne)) + 
  geom_histogram(binwidth=.5, colour="black", fill="gray") + 
  facet_grid(typ ~ .) +
  theme(strip.text.y = element_text(size=12, face="bold"),
        strip.background = element_rect(colour="red", fill="#CCCCFF")) +
  xlab("% głosów nieważnych") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme.basic

dane %>%
  filter(wyborcy>100) %>%
  select(typ, frekwencja) %>%
  distinct %>%
  ggplot(aes(x=frekwencja)) + 
  geom_histogram(binwidth=.5, colour="black", fill="gray") + 
  facet_grid(typ ~ .) +
  theme(strip.text.y = element_text(size=12, face="bold"),
        strip.background = element_rect(colour="red", fill="#CCCCFF")) +
  xlab("% głosów nieważnych") +
  ylab("Liczba lokali wyborczych") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme.basic


#' Teraz dodamy wyniki partii
#' Najpierw rozważmy proste statystyki
dane %>%
  filter(wyborcy > 500) %>%
  group_by(partia) %>% 
  summarize(poparcie = sum(glosy)/sum(frekwencja*wyborcy/10000),
            mediana = median(wynik)) %>%
  arrange(desc(poparcie)) %>%
  top_n(10)

dane %>%
  filter(wyborcy > 500,
         niewazne > 30) %>%
  group_by(partia) %>% 
  summarize(poparcie = sum(glosy)/sum(frekwencja*wyborcy/10000),
            mediana = median(wynik)) %>%
  arrange(desc(poparcie)) %>%
  top_n(10)

# Kto zyskuje gdy rozważamy tylko lokale z duża liczbą
# głosów nieważnych? PSL i Mniejszość Niemiecka :)

#tworzymy motyw dla naszych wykresów - dzięki temu wygodniej
#potem przeglądać kod
theme.basic <- 
  theme(legend.position = "none") +
  theme(plot.title = element_text(size=26, family="Trebuchet MS", face="bold", hjust = 0.5, color="#666666")) +
  theme(axis.title = element_text(size=18, family="Trebuchet MS", face="bold", color="#666666")) +
  theme(strip.text.y = element_text(size=12, face="bold")) +
  theme(strip.background = element_rect(colour="red", fill="#CCCCFF")) +
  theme(panel.background = element_rect(fill = "white"))

duze.partie <- c("Komitet Wyborczy Polskie Stronnictwo Ludowe",
                 "Komitet Wyborczy Prawo i Sprawiedliwość",
                 "Komitet Wyborczy Platforma Obywatelska RP")

#do rysowania wykresów, nie musimy tworzyć nowych ramek danych
#po prostu przekazujemy zmienioną ramkę danych jako wejście dla ggplota
dane %>%
  filter(partia %in% duze.partie,
         wyborcy > 500) %>%
  select(typ, niewazne, partia, wynik) %>%
  ggplot(aes(y=wynik, x=niewazne)) + 
    geom_point(shape=20, alpha=1/4, size = 0.5, col = "red") +  
    facet_grid(typ ~ partia)+
    geom_smooth(formula=y~ ns(x,3), method = "gam") +
    xlab("% głosów nieważnych") +
    ylab("Poparcie w %") +
    ggtitle("Wyniki wyborów samorzadowych 2014") +
    theme.basic

dane %>%
  filter(partia %in% duze.partie,
         wyborcy > 500) %>%
  select(typ, frekwencja, partia, wynik) %>%
  ggplot(aes(y=wynik, x=frekwencja)) + 
  geom_point(shape=20, alpha=1/4, size = 0.5, col = "red") +  
  facet_grid(typ ~ partia)+
  geom_smooth(formula=y~ ns(x,3), method = "gam") +
  xlab("Frekwencja w %") +
  ylab("Poparcie w %") +
  ggtitle("Wyniki wyborów samorzadowych 2014") +
  theme.basic

