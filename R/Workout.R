library(tidyverse)
library(purrr)
library(stringr)
library(lubridate)
library(forcats)
library(feather)
library(xml2)

args <- commandArgs(trailingOnly = TRUE)
# args <- c("temp.xml", "res/Workout.feather")

attr_tbl <- function(x) xml_attrs(x) %>% t() %>% as_tibble()
transform_node <- function(x) {
  xml_children(x) %>%                     # get the children
    map(attr_tbl) %>%                     # get their attributes
    bind_rows() %>%                       # merge them together
    select(c("key", "value")) %>%         # keep only key and value
    filter(!str_detect(key, "<NA>")) %>%  # drop NAs (pause-events)
    bind_rows(attr_tbl(x) %>% gather())   # combine them with 'main'-attrs
}

camel_to_snake <- function(x) 
  str_replace_all(x, "([a-z])([A-Z])", "\\1_\\2") %>% tolower()

fix_key <- function(x) str_replace_all(x, "_|HK|PrivateWorkout", "") %>%
  camel_to_snake()

i <- str_length("HKWorkoutActivityType") + 1
transform_act_type <- function(x)
  ifelse(str_detect(x, "HK"), str_sub(x, i) %>% camel_to_snake(), x)

tibble(node = read_xml(args[1]) %>% xml_children()) %>%
  transmute(ind = seq_along(node), attrs = map(node, transform_node)) %>%
  unnest() %>%
  mutate(key = fix_key(key) %>% as_factor()) %>%
  filter(key != "source_version") %>%
  mutate(value = transform_act_type(value)) %>%
  write_feather(args[2])
  
