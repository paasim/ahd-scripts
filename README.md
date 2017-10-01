# Scripts for transforming Apple health data to tabular format

The relevant data is first extracted from the xml-file and split into smaller chucks, which are to R which transforms the data into tibbles.

## Requirements
`xml2`, `2xml`, `awk` in path.
`R` with relatively new versions of the libraries `tidyverse`, `stringr`, `lubridate`, `forcats`, `feather` and `xml2`.

## Usage

The following extracts elements of type Record, ActivitySummary and Workout into separate tibbles. The results are stored in the folder `res/`

    ./process export.xml

