
#
# Check full dataset downloaded from ICES OHAT
#
# Look for stations/years with the same contaminants measured in fish liver and muscle 
#

library(readr)
library(dplyr)

fn <- "OSPAR_MIME_2019/OSPAR_MIME_AMAP_Biota_contaminants_effects_20191010/OSPAR_MIME_AMAP_Biota_contaminants_effects_20191010_utf8.txt"

readLines(fn, n = 3)

# Sample
dat <- read_tsv(fn, 
                n_max = 10000, 
                col_types = cols(
                  .default = col_character(),
                  OSPAR_region = col_double(),
                  SD_StationCode = col_double(),
                  SD_ASMT_StationCode = col_logical(),
                  MYEAR = col_double(),
                  Latitude = col_double(),
                  Longitude = col_double(),
                  NOINP = col_double(),
                  Value = col_double(),
                  DETLI = col_double(),
                  LMQNT = col_double(),
                  UNCRT = col_double(),
                  METCU = col_character(),
                  VFLAG = col_character(),
                  tblAnalysisID = col_double(),
                  tblParamID = col_double(),
                  tblBioID = col_double(),
                  tblSampleID = col_double(),
                  tblUploadID = col_double()
                ))


# ALL (15 seconds)
dat <- read_tsv(fn, 
                col_types = cols(
                  .default = col_character(),
                  OSPAR_region = col_double(),
                  SD_StationCode = col_double(),
                  SD_ASMT_StationCode = col_logical(),
                  MYEAR = col_double(),
                  Latitude = col_double(),
                  Longitude = col_double(),
                  NOINP = col_double(),
                  Value = col_double(),
                  DETLI = col_double(),
                  LMQNT = col_double(),
                  UNCRT = col_double(),
                  METCU = col_character(),
                  VFLAG = col_character(),
                  tblAnalysisID = col_double(),
                  tblParamID = col_double(),
                  tblBioID = col_double(),
                  tblSampleID = col_double(),
                  tblUploadID = col_double()
                ))


head(dat)

dat %>% filter(Country == "Norway" & MYEAR == 2018) %>% View()

xtabs(~MYEAR, dat %>% filter(Country == "Norway"))

xtabs(~PARAM, dat %>% filter(Country == "Norway"))

xtabs(~PARGROUP, dat %>% filter(Country == "Norway"))

xtabs(~PARAM + MATRX, dat %>% filter(PARGROUP %in% "I-MET"))

apply(is.na(dat), 2, sum)

# Stations:
xtabs(~is.na(StationName) + is.na(SD_StationName), dat)

# Some stations have only Latitude, Longitude:
dat %>%
  filter(is.na(StationName) & is.na(SD_StationName)) %>%
  View()

# Add 'Stat' for station
dat <- dat %>%
  mutate(Stat = case_when(
    !is.na(StationName) ~ StationName,
    !is.na(SD_StationName) ~ SD_StationName,
    TRUE ~ paste0(round(Latitude, 5), "_", round(Longitude, 5))
  ))

#
# Explore metals ----
#

# Number of measurements (including data < LOQ)
dat2 <- dat %>%
  filter(PARGROUP %in% "I-MET" & SpeciesType %in% "Fish" & MATRX %in% c("LI", "MU")) %>%
  count(PARAM, Country,Species, Stat, MYEAR, MATRX) %>%
  tidyr::pivot_wider(names_from = MATRX, values_from = n, values_fill = 0)

xtabs(~Species, dat2)
xtabs(~Species + PARAM, dat2)

xtabs(~Species + PARAM, dat2 %>% filter(LI > 0 & MU > 0))

xtabs(~Country + PARAM, dat2 %>% filter(LI > 0 & MU > 0 & Species %in% "Gadus morhua"))

# Median values
dat3 <- dat %>%
  filter(PARGROUP %in% "I-MET" & SpeciesType %in% "Fish" & MATRX %in% c("LI", "MU")) %>%
  filter(!is.na(QFLAG)) %>%   # OBS - disregard under LOQ
  group_by(PARAM, Country,Species, Stat, MYEAR, MATRX) %>%
  summarise(Value = median(Value)) %>%
  tidyr::pivot_wider(names_from = MATRX, values_from = Value, values_fill = NA)

xtabs(~Country + PARAM, dat3 %>% filter(LI > 0 & MU > 0 & Species %in% "Gadus morhua"))
xtabs(~paste(Country, Species) + PARAM, dat3 %>% filter(LI > 0 & MU > 0))

#
# All parameters
#

# Median values
dat4 <- dat %>%
  filter(SpeciesType %in% "Fish" & MATRX %in% c("LI", "MU")) %>%
  filter(!is.na(QFLAG)) %>%   # OBS - disregard under LOQ
  group_by(PARGROUP, PARAM, Country,Species, Stat, MYEAR, MATRX) %>%
  summarise(Value = median(Value)) %>%
  tidyr::pivot_wider(names_from = MATRX, values_from = Value, values_fill = NA)


xtabs(~PARGROUP, dat4 %>% filter(LI > 0 & MU > 0))

xtabs(~paste(Country, Species) + PARAM, dat4 %>% filter(LI > 0 & MU > 0 & PARGROUP %in% "I-MET"))
xtabs(~paste(Country, Species) + PARAM, dat4 %>% filter(LI > 0 & MU > 0 & PARGROUP %in% "OC-CB"))
xtabs(~paste(Country, Species) + PARAM, dat4 %>% filter(LI > 0 & MU > 0 & PARGROUP %in% "OC-HC"))

xtabs(~Country + PARAM, dat4 %>% filter(LI > 0 & MU > 0 & Species %in% "Gadus morhua"))

xtabs(~paste(Country, Species) + PARAM, dat4 %>% filter(LI > 0 & MU > 0))

dat4 %>% filter(LI > 0 & MU > 0) %>% View()

dat4 %>% filter(LI > 0 & MU > 0) %>% View()
