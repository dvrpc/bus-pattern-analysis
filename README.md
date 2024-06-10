# bus-pattern-analysis

Missing intro about this project to be added. 

## Installation/Setup

- Clone the repository
- Download and install R from https://www.r-project.org/
- Download and install R Studio from https://www.rstudio.com/products/rstudio/#Desktop
- Open the code files directly in R studio. If needed, push commits through GitHub desktop.
- Create the *.Renviron* files <br>
  The *.Renviron* file includes these two secret paths in this format:
  ```cmd
  import_folder="path/to/import_folder/with_files"
  export_folder="path/to/export_folder"
  ```
  The .Renviron file can be created in R studio through Files -> New Files -> Text File (and set up the .Renviron as type when saving.) <br>Alternatively, download the *.Renviron.Example* file to the folder from the repository, edit the secrets, and rename the file to *.Renviron*.<br>

  The beginning of each code file calls on the Renviron within its folder, then calls the relevant secrets:
  ```cmd
  readRenviron(paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/.Renviron"))
  import_folder <- Sys.getenv("import_folder")
  export_folder <- Sys.getenv("export_folder")
  ```
  
- Install all libraries before running them for the first time:
  ```cmd
  install.packages("name_of_package")
  library(name_of_package)
  ```
### Dependencies

These two code files utilize these three R packages:
- **dplyr**
- **sf**
- **tidyverse**

## Usage

1. Set up (create) the import and export folders for each specific bus route and direction reviewed<br><br>
2. Populate the import folder with these files:<br><br>
   - **Five CSV files**
     Download five CSV files (per direction, per route) from the Swift.ly speed map page. Each file should align with the preferred time-intervals buckets. This step requires an active Swift.ly         user. For further instructions regarding manual Swift.ly downloads and/or time intervals, please review the attached full how-to guide (**PAGES TO REFER TO MISSING**)<br>
     Name the files   early_am, am_rush, midday, pm_rush & evening.<br><br>
   - **Septa routes points shapefile**<br>
     Can be downloaded from the DVRPC data catalog at: https://catalog.dvrpc.org/dataset/septa-transit-stops <br><br>
4. Follow the setup steps above, including cloning the repository and creating the .Renviron file.<br><br>
5. Run ‘part 1’ R code:<br>
   - Open *part1_patterns_time_matrix_and_dict.r* from the cloned repository directly in Rstudio
   - Run the code
   - Expected output to export folder: pattern_time_matrix.csv, pattern_dictionary.csv<br><br>
6. Manually flag abnormal patterns in the exported pattern dictionary CSV file. Write 'T' under the *flagged_pattern* column to flag a pattern, then save the file.<br><br>
7. Run ‘part 2’ R code:<br>
   - aa
   - bb
   - ccc to get the tagged matrix and shapefile

## Reviewing pattern analysis output

MISSING TEXT HERE

## Contributing

NA

## Credits

NA

