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

MISSING EXPLANATION

## Contributing

NA

## Credits

NA

