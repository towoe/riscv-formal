riscv-formal proofs for Ibex
============================

**This is work in progress**

The checks which are supported are configured in [checks.cfg](checks.cfg).
This is a limited of subset of the standard checks.
More checks need to be activated, this is work in progress.
See [Status](README.md#Status) for more details.
The activated checks should run successfully with Ibex.

## Prerequisites

### Ibex source

The following sections assume that the folder `src` contains a copy of the Ibex repository.
This can be achieved by the following.

```console
$ git clone https://github.com/lowRISC/ibex.git src
```

If an Ibex git clone is already available at another location, `git worktree add` can be used from this copy to create a `src` folder here.

### Utilities

The checks can either be run with the tools installed locally or by using a container.

#### Install tools locally

First install the riscv-formal requirements Yosys, SymbiYosys, and the solvers.
See [here](http://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing) for instructions.

Install [sv2v](https://github.com/zachjs/sv2v) as described [here](https://github.com/zachjs/sv2v#installation).

#### Container

Either Docker or Podman must be installed.

The image can be obtained from [docker.io](https://hub.docker.com/r/towoe/sby-sv) or created from the [github](https://github.com/towoe/sby-sv) source.
Make sure the image is available as **sby-sv**.

## Run all checks

Riscv-formal has a script which will create the checks depending on the configuration specified in `checks.cfg`.
The results contain paths to different locations and are specific to the way they were generated.
Therefore, locally create checks will not work with a container and the over way around.

### Run with tools installed locally

The default target of the `Makefile` depends on the required tools to be available.
The following command will create a Verilog source of Ibex, which will be used in the check, generate the checks, and finally run all checks.

```console
$ make
```

### Run with container

Run the following to first create the Verilog source, create the checks and then run the checks.
This will remove an existing `checks` folder, run the generate script and then run the checks.

```console
$ make all-container
```

## Run specific checks

To run only one or more checks the environment variable `CHECK` can be used to specify the checks which should be executed.
The corresponding folders in *checks* have to be removed first.
This can either be done by manually removing specific folders:

```console
$ rm -rf checks/insn_add_ch0 checks/insn_sw_ch0
```

Or by generating the checks, which will overwrite the existing folder and remove all results.

```console
$ make build-container
```

Run the checks with the tools provided by the container.

```console
$ CHECK="insn_add_ch0 insn_bne_ch0" make run-container
```

## Status

### Active checks

Currently enabled and working checks:

  - Instruction Checks
  - Register Checks
  - Causality
  - Uniqueness
  - Program counter backward check
  - Liveness

#### Restrictions for memory interface

For instruction and data memory interface assumptions are made in order to restrict the range of possible responses.
The restrictions applied are very strict and could be further enhanced to increase coverage.

### Inactive checks

A summary for each of the non-working checks.

#### PC forward check

The `pc_fwd` check is not working because the signal `rvfi_intr` is not checked.
`rvfi_intr` must be set for instructions which have different program counters than reported in the step before.
This can happen for example for trap handling.
The check does not respect this signal and will fail for Ibex.
This is a [known problem](https://github.com/SymbioticEDA/riscv-formal/issues/9).
