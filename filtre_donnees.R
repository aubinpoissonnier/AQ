library(aws.s3)
library(purrr)
## Données

df <- map(
  .x = c("/analyse_quanti/FD_INDCVIZE_2019.csv",
         "/analyse_quanti/FD_INDCVIZE_2017.csv",
         "/analyse_quanti/FD_INDCVIZE_2015.txt",
         "/analyse_quanti/FD_INDCVIZD_2013.txt",
         "/analyse_quanti/FD_indcvizd_2011.txt",
         "/analyse_quanti/FD_INDCVIZD_2009.txt"),
  .f =
    ~ aws.s3::s3read_using(
      FUN = data.table::fread,
      # Mettre les options de FUN ici
      object = .,
      bucket = "aubinpoissonnier",
      opts = list("region" = ""),
      select =
        c(ARM="character",
             IPONDI="character",
             IMMI="factor",
             SEXE="factor")
))

df2 <- df %>%
  list_rbind(
    names_to = "id"
  )

df2 <- df2[ARM %in% 69000:70000]

aws.s3::s3write_using(
  df2,
  FUN = data.table::fwrite,
  object = "diffusion/RP_LYON_2009_2019.csv",
  bucket = "aubinpoissonnier",
  opts = list("region" = "")
)







aws.s3::get_bucket("aubinpoissonnier",
                   prefix = "diffusion/",
                   region = "")


aws.s3::get_bucket("donnees-insee",
                   prefix = "diffusion/RP/2016/individu",
                   region = "")

df <- aws.s3::s3read_using(
  FUN = data.table::fread,
  # Mettre les options de FUN ici
  object = "/diffusion/RP_AURA_2016.csv",
  bucket = "aubinpoissonnier",
  opts = list("region" = ""),
)

names(df)

df <- aws.s3::s3read_using(
  FUN = arrow::read_parquet,
  # Mettre les options de FUN ici
  object = "diffusion/RP/2016/individu_reg/individu_reg.parquet",
  bucket = "donnees-insee",
  opts = list("region" = ""),
)
library(dplyr)
df <- data.table(df)
df[region == "84",]

df2 <- df %>%
  filter(region == 84 & lprf == 1)

aws.s3::s3write_using(
  df2,
  FUN = data.table::fwrite,
  object = "diffusion/RP_AURA2016_ind.csv",
  bucket = "aubinpoissonnier",
  opts = list("region" = "")
)
