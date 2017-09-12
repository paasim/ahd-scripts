# Scripts for transforming Apple health data to tabular format

The relevant data is first extracted from the xml-file with grep/awk and then processed with R.
For the scripts to work, the location of the exported xml-file must be specified in the makefile.

Usage
-----

Print all the 'available data sets' and the corresponding fields:

    make print_fields

Make a table with all the workout-data:
    
    make res/Workout.feather

