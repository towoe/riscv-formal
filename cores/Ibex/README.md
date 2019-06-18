
riscv-formal proofs for Ibex
============================

**This is not tested. It will not work with yosys SystemVerilog front-end, but might with verific.**

Quickstart guide:

First install Yosys, SymbiYosys, and the solvers. See
[here](http://symbiyosys.readthedocs.io/en/latest/quickstart.html#installing)
for instructions.  Then download the core, generate the formal checks and run them:

```
git clone https://github.com/lowRISC/ibex.git src
python3 ../../checks/genchecks.py
make -C checks -j$(nproc)
```

