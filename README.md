# A Haskell script for converting parts of exported Apple health data to tabular format

Currently contains functionality to converting parts of the activity summary and the workout data to a csv.

## Requirements

Haskell (stack lts 11.3). 

## Usage

The script assumes that the file is named 'export.xml'.

```bash
    # obtain the activity summaries
   ./app.hs export.xml act > act.csv

   # obtain workout stats
   ./app.hs export.xml wrk > wrk.csv
```


