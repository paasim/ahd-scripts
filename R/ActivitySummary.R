library(tidyverse)
library(stringr)
library(lubridate)
library(forcats)
library(feather)
library(xml2)

args <- c("xmls/ActivitySummary.xml", "res/ActivitySummary.feather")

camel_to_snake <- function(x)
  str_replace_all(x, "([a-z])([A-Z])", "\\1_\\2") %>% tolower()

int_cols <- c("active_energy_burned_goal",
              "apple_exercise_time", "apple_exercise_time_goal",
              "apple_stand_hours", "apple_stand_hours_goal")

read_xml(args[1]) %>%
  xml_children() %>%
  xml_attrs() %>%
  map(~as_tibble(t(.x))) %>%
  bind_rows() %>%
  set_names(camel_to_snake(colnames(.))) %>%
  mutate(date_components = ymd(date_components),
         active_energy_burned = as.numeric(active_energy_burned),
         active_energy_burned_unit = as_factor(active_energy_burned_unit)) %>%
  mutate_at(int_cols, as.integer) %>%
  write_feather(args[2])

