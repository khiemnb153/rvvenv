## Environment Structure

| File/Directory             | Description                                                        |
| -------------------------- | ------------------------------------------------------------------ |
| `.`                        | Root                                                               |
| `├── rtl`                  | Contain designs (`*.v`, `*.sv` file)                               |
| `├── verif/`               | Verification                                                       |
| `│   ├── testbench.sv`     |                                                                    |
| `│   └── results/`         | Results generated after running `simulate_rtl.py`                  |
| `│       └── <test_name>/` | Contains changlogs of PC, DMEM, XReg and VReg for each test        |
| `│           ├── PC.log`   |                                                                    |
| `│           ├── DMEM.log` |                                                                    |
| `│           ├── XReg.log` |                                                                    |
| `│           └── VReg.log` |                                                                    |
| `├── tests/`               | Contains tests generated after running `generate_tests.py`         |
| `│   └── <test_name>/`     | Each test contains assembly and conresponding binary code and data |
| `│       ├── IMEM.mem`     |                                                                    |
| `│       ├── DMEM.mem`     |                                                                    |
| `│       └── assembly.S`   |                                                                    |
| `├── golden_model/`        | Results generated after running `simulate_model.py`                |
| `│   └── <test_name>/`     |                                                                    |
| `│       ├── PC.log`       |                                                                    |
| `│       ├── DMEM.log`     |                                                                    |
| `│       ├── XReg.log`     |                                                                    |
| `│       └── VReg.log`     |                                                                    |
| `├── result/`              | Result of running `compare.py`                                     |
| `│   ├── overall.log`      | Each test is passed or failed                                      |
| `│   └── <test_name>.log`  | How a test failed                                                  |
| `├── configs.json`         | Configurations                                                     |
| `├── generate_tests.py`    | Script to generate tests                                           |
| `├── simulate_model.py`    | Script to generate golden model                                    |
| `├── simulate_rtl.tcl`     | Script to run the testbench                                        |
| `└── compare.py`           | Script to compare testbench and golden model results               |

## How to use?

### Prerequisite

- Install Python.
- Install `rvvsuite` package.
- Install Vivado.
- Add path to vivado to system environment.

### Step-by-Step

- Step 1. Write a `configs.json`.
- Step 2. Run `generate_tests.py`.
- Step 3. Run `simulate_model.py`.
- Step 4. Write a `params.txt` that specify parameters for top module (testbench).
- Step 5. Run `vivado.bat -mode tcl -script simulate_rtl.tcl`.
- Step 6. Run `compare.py`.
- Step 7. Inspect `result/`.
