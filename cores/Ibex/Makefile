## The variable CHECK can be used to restrict running only a subset of the
## checks.

IBEX_SRC 		?= src/formal/ibex.v
CONTAINER_TOOL 		?= docker
CONTAINER_IMAGE 	?= towoe/sby-sv
CONTAINER_RUN_ARGS 	?= -i -t --rm --volume `pwd`/../../:/riscv-formal

IBEX_CMD := make -C src/formal
GEN_CMD := python3 ../../checks/genchecks.py
RUN_CMD := make -C checks -j`nproc` $(CHECK)

## Run the checks locally. The required tools must be installed and available.
## The README.md for details.

## Using the default target all will force a rerun of all checks.
all: build run

.PHONY: $(IBEX_SRC)
$(IBEX_SRC):
	$(IBEX_CMD)

.PHONY: build
build: $(IBEX_SRC)
	$(GEN_CMD)

.PHONY: run
run:
	$(RUN_CMD)


## Targets for running the check inside of a container

all-container: ibex-src-container build-container run-container

.PHONY: ibex-src-container
ibex-src-container:
	$(CONTAINER_TOOL) run -i -t --rm --volume `pwd`:/Ibex \
		$(CONTAINER_IMAGE) /bin/bash -c 'cd /Ibex && $(IBEX_CMD)'

.PHONY: build-container
build-container:
	$(CONTAINER_TOOL) run $(CONTAINER_RUN_ARGS) \
		$(CONTAINER_IMAGE) /bin/bash -c 'cd riscv-formal/cores/Ibex && \
		$(GEN_CMD)'

.PHONY: run-container
run-container:
	$(CONTAINER_TOOL) run $(CONTAINER_RUN_ARGS) \
		$(CONTAINER_IMAGE) /bin/bash -c 'cd riscv-formal/cores/Ibex && \
		$(RUN_CMD)'
