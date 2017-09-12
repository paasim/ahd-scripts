library(tidyverse)
library(purrr)
library(stringr)
library(lubridate)
library(forcats)
library(feather)
library(xml2)

args <- commandArgs(trailingOnly = TRUE)
args <- c("temp.xml", "res/Stand.feather")

remove_str <- "HKCategoryValueAppleStandHour"
camel_to_snake <- function(x)
  str_replace_all(x, "([a-z])([A-Z])", "\\1_\\2") %>% tolower()

read_xml(args[1]) %>% xml_children() %>% xml_attrs() %>%
  map(function(x) t(x) %>% as_tibble()) %>%
  bind_rows(.id = "ind") %>%
  transmute(ind = as.integer(ind),
            time = ymd_hms(startDate),
            value = str_replace_all(value, remove_str, "") %>%
              tolower() %>% as_factor()) %>%
  write_feather(args[2])

