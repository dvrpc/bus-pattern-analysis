library(dplyr)

readRenviron(paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/.Renviron"))

# upload folder variable from Renviron
import_folder <- Sys.getenv("import_folder")
export_folder <- Sys.getenv("export_folder")

# Export the relevant by-hour or time of day file:
early_am <- read.csv(paste0(import_folder,"/early_am.csv"))
am_rush <- read.csv(paste0(import_folder,"/am_rush.csv"))
midday <- read.csv(paste0(import_folder,"/midday.csv"))
pm_rush <- read.csv(paste0(import_folder,"/pm_rush.csv"))
evening <- read.csv(paste0(import_folder,"/evening.csv"))

# Add the speed text definition (the one below is based on Swiftly fixed thresholds for median):

add_speed_med_def <- function(df) {
  df$speed_med_def <- ifelse(df$speed_percentile_50 < 6, 'slow2',
                             ifelse(df$speed_percentile_50 < 9, 'slow1',
                                    ifelse(df$speed_percentile_50 < 12, 'med2',
                                           ifelse(df$speed_percentile_50 < 15, 'med1',
                                                  ifelse(df$speed_percentile_50 < 25, 'fast2', 'fast1')))))
  return(df)
}

early_am <- add_speed_med_def(early_am)
am_rush <- add_speed_med_def(am_rush)
midday <- add_speed_med_def(midday)
pm_rush <- add_speed_med_def(pm_rush)
evening <- add_speed_med_def(evening)

times_of_day <- function(time_data, time_data_name){

  patterns <- data.frame() # create an initial empty frame

  # create a function to map the patterns for each path:
  get_pattern <- function(data,id,col_name){
  
    subset_1 <- data %>% filter(stop_path_id == id) %>% 
    dplyr::select(stop_path_id,segment_index,speed_med_def)

    # Use dplyr to filter the rows where the speed value changes
    result <- rbind(
      subset_1 %>% filter(segment_index == 0),
      subset_1 %>%
      arrange(segment_index) %>%  # Order by segment
      mutate(previous_speed = lag(speed_med_def, default = first(speed_med_def))) %>%
      filter(speed_med_def != previous_speed) %>%
      select(-previous_speed) # remove the temporary 'previous_speed' column
    )

    combined_text <- paste(result$speed_med_def, collapse = "-")

    final_row <- cbind(id,combined_text)
  
    colnames(final_row)[2] <- col_name
  
    patterns <- rbind(patterns,final_row)

  }

  unique_paths <- unique(time_data[["stop_path_id"]]) # get unique values to loop through

  # Loop through each value in the list
  for (path in unique_paths) {
    patterns <- get_pattern(time_data, path,time_data_name)
  }

  return(patterns)

}

early_am_table <- times_of_day(early_am,"early_am")
am_rush_table <- times_of_day(am_rush,"am_rush")
midday_table <- times_of_day(midday,"midday")
pm_rush_table <- times_of_day(pm_rush,"pm_rush")
evening_table <- times_of_day(evening,"evening")

# create the full matrix:

# select ALL stop_to_stop unique id:

unique_paths <- unique(rbind(early_am_table[1],
                             am_rush_table[1],
                             midday_table[1],
                             pm_rush_table[1],
                             evening_table[1])) # this part is to account for changes between tables

tables <- list(unique_paths, early_am_table, am_rush_table, midday_table, pm_rush_table, evening_table)

pattern_time_matrix <- Reduce(function(x, y) merge(x, y, by = 'id', all = TRUE), tables)

# get table of unique patterns for review:

colnames(early_am_table) <- c("id","pattern_dict")
colnames(am_rush_table) <- c("id","pattern_dict")
colnames(midday_table) <- c("id","pattern_dict")
colnames(pm_rush_table) <- c("id","pattern_dict")
colnames(evening_table) <- c("id","pattern_dict")

pattern_dict <- unique(rbind(early_am_table[2],
                             am_rush_table[2],
                             midday_table[2],
                             pm_rush_table[2],
                             evening_table[2]))

# add an empty column for manual tagging to the dictionary
pattern_dict$flagged_pattern <- ''

# export the dictionary and matrix to a folder:
write.csv(pattern_time_matrix, paste0(export_folder,"/pattern_time_matrix.csv"),row.names=FALSE)
write.csv(pattern_dict, paste0(export_folder,"/pattern_dictionary.csv"),row.names=FALSE)
