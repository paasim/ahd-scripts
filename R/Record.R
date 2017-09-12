library(tidyverse)
library(purrr)
library(stringr)
library(lubridate)
library(forcats)
library(feather)
library(xml2)

args <- commandArgs(trailingOnly = TRUE)
# args <- c("temp.xml", "res/Record.feather")

camel_to_snake <- function(x)
  str_replace_all(x, "([a-z])([A-Z])", "\\1_\\2") %>% tolower()

i <- str_length("HKQuantityTypeIdentifier") + 1

read_xml(args[1]) %>% xml_children() %>% xml_attrs() %>%
  map(function(x) t(x) %>% as_tibble()) %>%
  bind_rows(.id = "ind") %>%
  select(-device, -sourceVersion) %>%
  setNames(camel_to_snake(colnames(.))) %>%
  mutate_at(vars(matches("_date")), ymd_hms) %>%
  mutate_at(c("type", "source_name", "unit"), as_factor) %>%
  mutate(ind = as.integer(ind),
         type = fct_relabel(type, function(x) str_sub(x, i) %>% camel_to_snake()),
         value = as.numeric(value)) %>%
  write_feather(args[2])

