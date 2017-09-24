library(tidyverse)
library(stringr)
library(lubridate)
library(forcats)
library(feather)
library(xml2)

args <- c("xmls", "res/Record.feather", "res/Stand.feather")

fnames <- list.files(args[1], pattern = "^rec[0-9]+\\.xml$", full.names = TRUE)

xml_2_tibble <- function(fname)
  read_xml(fname) %>% xml_children() %>% xml_attrs() %>%
  map(~as_tibble(t(.x))) %>%
  bind_rows()

i <- str_length("HKQuantityTypeIdentifier") + 1

camel_to_snake <- function(x)
  str_replace_all(x, "([a-z])([A-Z])", "\\1_\\2") %>% tolower()

fct_cols <- c("type", "source_name", "source_version", "unit", "device")

all <- map(fnames, xml_2_tibble) %>%
  bind_rows() %>%
  set_names(camel_to_snake(colnames(.))) %>%
  mutate(type = str_sub(type, i)) %>%
  mutate_at(fct_cols, factor) %>%
  mutate_at(vars(matches("date")), ymd_hms)

filter(all, !str_detect(value, "HKCategory")) %>%
  mutate(value = parse_double(value)) %>%
  write_feather(args[2])

i2 <- str_length("HKCategoryValueApple") + 1
filter(all, str_detect(value, "HKCategory")) %>%
  mutate(value = str_sub(value, i2) %>% as_factor) %>%
  write_feather(args[3])
