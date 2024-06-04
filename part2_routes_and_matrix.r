library(dplyr)
library(sf)
library(tidyverse)

readRenviron(paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/.Renviron"))

# read variables from Renviron
import_folder <- Sys.getenv("export_folder") 
export_folder <- Sys.getenv("export_folder") 


pattern_time_matrix <- read.csv(paste0(export_folder,"/pattern_time_matrix.csv"))

pattern_time_matrix <- pattern_time_matrix %>%
  mutate(stops_id = id) %>%
  separate(id, into = c("from_stop", "to_stop"), sep = "_to_")

# get septa points for the specific route:

septa_pts <- read_sf(paste0(import_folder,"/septa_stops_pnts.shp")) %>% select(stopid)

septa_pts$stopid <- as.character(septa_pts$stopid)

pattern_time_matrix_with_geom <- pattern_time_matrix %>%
  left_join(septa_pts, by = c("from_stop" = "stopid")) %>%
  rename(geometry_a = geometry) %>%
  left_join(septa_pts, by = c("to_stop" = "stopid")) %>%
  rename(geometry_b = geometry)

pattern_time_matrix_with_geom <- unique(pattern_time_matrix_with_geom)

# create the lines:

matrix_with_geom_filtered <- pattern_time_matrix_with_geom %>% filter(!is.na(to_stop)) %>% filter(!is.na(from_stop)) #drop na if exists or the code won't run

create_linestring <- function(geometry_a, geometry_b) {
  st_sfc(st_linestring(rbind(st_coordinates(geometry_a), st_coordinates(geometry_b))))
  }

matrix_with_geom_filtered <- matrix_with_geom_filtered %>%
  rowwise() %>%
  mutate(line_geometry = create_linestring(geometry_a, geometry_b)) %>%
  ungroup()

matrix_with_geom_filtered <- matrix_with_geom_filtered %>% select(-to_stop,-from_stop,-geometry_a,-geometry_b)

#upload abnormal mapping by reviewing team:
flagged_dict <- read.csv(paste0(export_folder,"/pattern_dictionary.csv")) %>% filter(flagged_pattern == TRUE)

matrix_with_geom_filtered$early_am_t <- ifelse(matrix_with_geom_filtered$early_am %in% flagged_dict$pattern_dict,TRUE,FALSE)
matrix_with_geom_filtered$am_rush_t <- ifelse(matrix_with_geom_filtered$am_rush %in% flagged_dict$pattern_dict,TRUE,FALSE)
matrix_with_geom_filtered$midday_t <- ifelse(matrix_with_geom_filtered$midday %in% flagged_dict$pattern_dict,TRUE,FALSE)
matrix_with_geom_filtered$pm_rush_t <- ifelse(matrix_with_geom_filtered$pm_rush %in% flagged_dict$pattern_dict,TRUE,FALSE)
matrix_with_geom_filtered$evening_t <- ifelse(matrix_with_geom_filtered$evening %in% flagged_dict$pattern_dict,TRUE,FALSE)

matrix_with_geom <- st_sf(matrix_with_geom_filtered, sf_column_name = "line_geometry")
matrix_without_geom <- matrix_with_geom %>% st_set_geometry(NULL)

# export files
write_sf(matrix_with_geom , paste0(export_folder,"/matrix_mapped.shp"))
write.csv(matrix_without_geom, paste0(export_folder,"/flagged_matrix.csv"),row.names=FALSE)
