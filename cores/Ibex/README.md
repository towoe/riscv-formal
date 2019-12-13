riscv-formal proofs for Ibex
============================

**This is work in progress**

Quickstart guide:

First install Yosys, SymbiYosys, and the solvers. See
[here](http://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing)
for instructions. Then download the core:

```
git clone https://github.com/towoe/ibex.git --branch syn-rvfi src
```

Create Verilog sources: (Follow the install instructions in `syn/syn_yosys.sh` first)

```
cd src/syn && ./syn_yosys.sh
cd -
```

Generate and run the checks:

```
python3 ../../checks/genchecks.py
make -C checks -j$(nproc)
```
