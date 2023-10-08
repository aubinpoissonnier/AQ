### Chargement des données
rp <- aws.s3::s3read_using(
  FUN = data.table::fread,
  # Mettre les options de FUN ici
  object = "analyse_quanti/Ficdep19.csv",
  bucket = "aubinpoissonnier",
  opts = list("region" = ""),
)

### Calculs
rp[, IMMI := ifelse(NATIO != "000" & REG_NAIS == "99", 1, 0)]
tab <- rp[, .(n = sum(POND)), by = c("AN_RECENS", "IMMI")] %>%
  mutate(AN_RECENS = as.factor(AN_RECENS),
         p = n/sum(n), .by = AN_RECENS) %>%
  filter(IMMI == 1)
tab %>%
  ggplot(aes(x = AN_RECENS)) +
  geom_line(aes(y = p,
                group = 1)) + 
  geom_line(aes(y = n/10^8),
            color = "red",
            group = 1) +
  scale_y_continuous(sec.axis = sec_axis(~.*10^8, name="Nombre d'immigré·es",
                                         seq(3*10^6, 7*10^6, 5*10^5),
                                         labels = format(seq(3*10^6, 7*10^6, 5*10^5), big.mark = " ")),
                     breaks = seq(0.0, 0.1, by = 0.005),
                     labels = scales::label_percent(seq(0.00, 0.1, by = 0.005),
                                                    decimal.mark = ","),
                    name = "Part d'immigré·es") +
  scale_x_discrete(breaks = levels(tab$AN_RECENS),
                     name = "Année") +
  theme_minimal() +
  theme(axis.text.y.right = element_text(color = "red"),
        axis.title.y.right = element_text(color = "red")) +
  labs(title = "Nombre et proportion d'immigré·es en France depuis 1968",
       caption = "Source : RP 1968-2019 (données harmonisées) | 2023 | A. Poissonnier\nLecture : en 1968, il y avait 3 250 000 immigré·es en France et la part de proportion immigrée dans la population française était de 6,50%.  ")

