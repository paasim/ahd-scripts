# location of the exported xml-file.
EXPORT=export.xml
TARGETS=Record Stand Workout ActivitySummary
TDIR=res/
RES=$(addprefix $(TDIR), $(addsuffix .feather, $(TARGETS)))

.PHONY : print_fields
print_fields : fields.sh $(EXPORT)
	./$< $(EXPORT)

.PHONY : print_datasets
print_datasets : datasets.sh $(EXPORT)
	./$< $(EXPORT)

$(TDIR)%.feather : proc.sh scripts/%.sh R/%.R $(EXPORT)
	mkdir -p $(TDIR)
	./$< $(@F) $(EXPORT)

.PHONY : all
all : $(RES)

.PHONY: clean
clean:
	rm -rf res/*

