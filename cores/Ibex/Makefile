CONTAINER_TOOL       ?= podman
CONTAINER_IMAGE      ?= towoe/sby-sv
CONTAINER_IMAGE_SV2V ?= towoe/sv2v

# Run checks

.PHONY: container-check
container-check:
	${CONTAINER_TOOL} run -i -t --rm --volume `pwd`/../../:/riscv-formal \
		${CONTAINER_IMAGE} /bin/bash -c 'cd riscv-formal/cores/Ibex && make -C checks -j`nproc` \
		${CHECK}'

.PHONY: local-check
local-check:
	make -C checks ${CHECK}


# Generate checks

.PHONY: container-generate
container-generate:
	${CONTAINER_TOOL} run -i -t --rm --volume `pwd`/../../:/riscv-formal \
		${CONTAINER_IMAGE} /bin/bash -c 'cd riscv-formal/cores/Ibex && \
		python3 ../../checks/genchecks.py'

.PHONY: local-generate
local-generate:
	python3 ../../checks/genchecks.py


# Create Ibex Verilog sources

.PHONY: container-create-ibex
container-create-ibex:
	${CONTAINER_TOOL} run -i -t --rm --volume `pwd`/src/:/ibex \
		${CONTAINER_IMAGE_SV2V} /bin/bash -c 'cd /ibex/syn/ && \
		./syn_yosys.sh'

.PHONY: local-create-ibex
local-create-ibex:
	cd ./src/syn && ./syn_yosys.sh
