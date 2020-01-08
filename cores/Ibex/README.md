riscv-formal proofs for Ibex
============================

**This is work in progress**

The checks which are supported are configured in [checks.cfg](checks.cfg).
This is a limited of subset of the standard checks.
More checks need to be activated, this is work in progress.
The activated checks should run successfully with Ibex.

## Tools installed locally

Quickstart guide:

First install Yosys, SymbiYosys, and the solvers. See
[here](http://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing)
for instructions. Then download the core:

```console
$ git clone https://github.com/towoe/ibex.git --branch syn-rvfi src
```

Create Verilog sources: (Follow the install instructions in `syn/syn_yosys.sh` first)

```console
$ cd src/syn && ./syn_yosys.sh
$ cd -
```

Generate and run the checks:

```console
$ python3 ../../checks/genchecks.py
$ make -C checks -j$(nproc)
```

## Container flow

Either pull the image from [docker.io](https://hub.docker.com/r/towoe/sby-sv) or create it from the [github](https://github.com/towoe/sby-sv) source.
Make sure the image is available as **sby-sv**.

Download the Ibex core:

```console
$ git clone https://github.com/towoe/ibex.git --branch syn-rvfi src
```

Run the following to first create the Verilog source, create the checks and then run the checks.
This is split into different targets without dependencies as a regeneration of the checks will delete the previous checks, and it might not always be necessary to create the Ibex Verilog source.

```console
$ make container-create-ibex
$ make container-generate
$ make container-check
```

To run only one or more checks the environment variable `CHECK` can be set accordingly.
The corresponding folders in *checks* have to be removed first.

```console
$ rm -rf checks/insn_add_ch0 checks/liveness_ch0

$ CHECK="insn_add_ch0 \
liveness_ch0" make container-check
```
