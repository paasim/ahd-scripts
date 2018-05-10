# Script for converting parts of exported Apple health data to tabular format

Currently contains functionality to converting parts of the activity summary and the workout data to a csv using Haskell and a bash script that exports heart rate data.

## Requirements

Haskell (stack lts 11.3). 

## Usage

The scripts assumes that the files named `export.xml` and `export_cda.xml` (as they should be when unzipped from the export file).

```bash
    # activity summaries
   ./app.hs export.xml act > act.csv

   # workout stats
   ./app.hs export.xml wrk > wrk.csv

   # heart rate
   ./hr.sh export_cda.xml > hr.txt
```

