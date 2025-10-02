#load libraries ----
library(dplyr)

#read in metadata ----
metadata <- read.csv("NBDL-e3fb54acd25d6a7f/metadata-e3fb54acd25d6a7f.csv")

format_metadata <- metadata %>% 
  slice(-1) %>%	# remove first row
  select(NBDL.unique.ID, Kingdom, Phylum, Class, Order, Family, Genus, Species.Name.Supplied) %>%
  rename(`#ID` = NBDL.unique.ID,
         kingdom = Kingdom,
         phylum = Phylum,
         class = Class,
         order = Order,
         family = Family,
         genus = Genus,
         species = Species.Name.Supplied) %>%
  mutate(domain = case_when(	# populate domain column
    kingdom %in% c("Animalia", "Plantae", "Fungi", "Protista") ~ "Eukaryota",
    kingdom == "Bacteria" ~ "Bacteria",
    kingdom == "Archaea" ~ "Archaea",
    TRUE ~ NA_character_
  )) %>%
  relocate(domain, .before = kingdom) %>%	# move domain before kingdom
  select(-c(kingdom))

write.csv(format_metadata, "NBDL_metadata.csv", row.names = F)
