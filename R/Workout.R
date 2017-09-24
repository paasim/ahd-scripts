library(tidyverse)
library(stringr)
library(lubridate)
library(forcats)
library(feather)
library(xml2)

args <- c("xmls/Workout.xml", "res/Workout.feather")

camel_to_snake <- function(x)
  str_replace_all(x, "([a-z])([A-Z])", "\\1_\\2") %>% tolower()

fix_cols <- function(x) str_replace_all(x, "`|_|HK|Private", "") %>%
  camel_to_snake()

nodes <- read_xml(args[1]) %>% xml_children()
attrs <- map(nodes, xml_attrs)
ch_attrs <- map(nodes, xml_children) %>%
  # get attributes from each children
  map(~map(.x, xml_attrs)) %>%
  # transform them into named characters
  map(~set_names(map_chr(.x, 2), map(.x, 1)))

# column types
fct_cols <- c(
  "workout_activity_type","duration_unit","swimming_stroke_style","source_name",
  "workout_weather_location_coordinates_latitude","swimming_location_type",
  "weather_temperature","weather_humidity","source_version","weather_condition",
  "workout_elevation_ascended_quantity","total_energy_burned_unit","time_zone",
  "workout_weather_location_coordinates_longitude","swimming_stroke_style",
  "total_distance_unit")
time_cols <- c("creation_date","start_date","end_date","workout_event_type_pause",
               "workout_event_type_marker","workout_event_type_resume")
dbl_cols <- c("duration", "total_distance", "total_energy_burned")
int_cols <- c("workout_was_in_daytime")
i <- str_length("HKWorkoutActivityType") + 1

map2(attrs, ch_attrs, ~as_tibble(t(c(.x, .y)))) %>%
  bind_rows() %>%
  set_names(fix_cols(colnames(.))) %>%
  mutate_at("workout_activity_type", . %>% str_sub(i) %>% camel_to_snake()) %>%
  mutate_at(fct_cols, factor) %>%
  mutate_at(time_cols, ymd_hms) %>%
  mutate_at(dbl_cols, parse_double) %>%
  mutate_at(int_cols, parse_integer) %>%
  write_feather(args[2])
