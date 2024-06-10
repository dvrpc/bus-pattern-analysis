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
export_folder=="path/to/export_folder"
  ```
  The .Renviron file can be created in R studio through Files -> New Files -> Text File (and set up the .Renviron as type when saving.) <br>Alternatively, download the *.Renviron.Example* file to the folder from the repository, edit the secrets, and rename the file to *.Renviron*.<br>

  The beginning of each code file calls on the Renviron within its folder, then calls the relevant secrets:
  ```cmd
  readRenviron(paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/.Renviron"))

  password1 <- Sys.getenv("password1")
  ```
  
- Install all libraries before runnning them for the first time:
  ```cmd
  install.packages("name_of_package")
  ```
### Dependencies

- **Tidycensus** <br>
  This code utilized the get_acs function from *tidycensus* library. <br>
  To start working with tidycensus, users to set their Census API key. Request a key through [http://api.census.gov/data/key_signup.html.](https://api.census.gov/data/key_signup.html) ,<br>
  After obtaining a key, install/call these two libraries and the key:

  ```cmd
  
  # install.packages("tidycensus")
  # install.packages("tidyverse")
  
  library(tidycensus)
  library(tidyverse)
  
  census_api_key("YOUR API KEY GOES HERE")
  ```
  R studio saves the key for future use, so unless you wish to change the key, you don't have to run the census_api_key line every time. 

## Usage

MISSING EXPLANATION

## Contributing

NA

## Credits

NA

