# Convert Apple health data to tabular format

Contains functionality for converting parts of the activity summary and the workout data to a csv using Haskell and a bash script that exports the heart rate data.

## Requirements

Haskell (tested on stack LTS 11.3). 

## Usage

The scripts assume that the files named `export.xml` and `export_cda.xml` (as they should be when unzipped from the export file).

```bash
    # activity summaries
   ./app.hs export.xml act > act.csv

   # workout stats
   ./app.hs export.xml wrk > wrk.csv

   # heart rate
   ./hr.sh export_cda.xml > hr.txt
```

