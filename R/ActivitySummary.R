library(tidyverse)
library(purrr)
library(stringr)
library(lubridate)
library(forcats)
library(feather)
library(xml2)

args <- commandArgs(trailingOnly = TRUE)
# args <- c("temp.xml", "res/ActivitySummary.feather")

camel_to_snake <- function(x)
  str_replace_all(x, "([a-z])([A-Z])", "\\1_\\2") %>% tolower()

read_xml(args[1]) %>% xml_children() %>% xml_attrs() %>%
  map(function(x) t(x) %>% as_tibble()) %>% bind_rows(.id = "ind") %>%
  setNames(camel_to_snake(colnames(.))) %>%
  mutate(date_components = ymd(date_components),
         active_energy_burned = as.numeric(active_energy_burned),
         active_energy_burned_unit = as_factor(active_energy_burned_unit)) %>%
  mutate_at(c(1, 4, 6:9), as.integer) %>%
  write_feather(args[2])

