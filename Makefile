# location of the exported xml-file.
EXPORT=export.xml
TARGETS=Record Stand Workout ActivitySummary
RES=$(addprefix res/, $(addsuffix .feather, $(TARGETS)))

.PHONY : print_fields
print_fields : fields.sh $(EXPORT)
	./$< $(EXPORT)

.PHONY : print_datasets
print_datasets : datasets.sh $(EXPORT)
	./$< $(EXPORT)

res/%.feather : proc.sh scripts/%.sh R/%.R $(EXPORT)
	./$< $(@F) $(EXPORT)

.PHONY : all
all : $(RES)

.PHONY: clean
clean:
	rm -rf res/*

