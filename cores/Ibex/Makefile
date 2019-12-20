CONTAINER_IMAGE=sby-sv
RUN_TOOL=podman

.PHONY: check
check:
	${RUN_TOOL} run -it --volume `pwd`/../../:/project ${CONTAINER_IMAGE} /bin/bash -c 'cd cores/Ibex && make -C checks -j`nproc` ${CHECK}'

.PHONY: generate
generate:
	${RUN_TOOL} run -it --volume `pwd`/../../:/project ${CONTAINER_IMAGE} /bin/bash -c 'cd cores/Ibex && python3 ../../checks/genchecks.py'

.PHONY: create
create:
	${RUN_TOOL} run -it --volume `pwd`/../../:/project ${CONTAINER_IMAGE} /bin/bash -c 'cd cores/Ibex/src/syn/ && ./syn_yosys.sh'
