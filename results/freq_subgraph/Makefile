GRAPH_FILE='../../data/freq_subgraph.txt'
LOG_FILE='log.txt'
NUMBER_OF_GRAPHS := $(shell echo "$$(cat $(GRAPH_FILE) | grep t | tail -1 | sed 's/t # //g') + 1" |bc)

results.txt: support.txt
	java -jar ~/Downloads/spmf.jar run GSPAN $(GRAPH_FILE) results.txt $$(cat support.txt) 1000 false > @(LOG_FILE)

support.txt: support_number/support_experiment.csv
	./support_number/elbow.R support_number/support_experiment.csv $(NUMBER_OF_GRAPHS) > support.txt

support_number/support_experiment.csv:
	./support_number/support.sh ../../data/freq_subgraph.txt | uniq | awk '{ print $$2 ";" $$1 }' > support_number/support_experiment.csv

clean:
	rm -f support_number/support_experiment.csv
	rm -f support.txt
	rm -f results.txt
	rm -f log.txt

