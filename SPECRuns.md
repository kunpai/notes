# Running SPECRuns.sh

## Pre-Requisites

1. Make sure you have completed [installing SPEC2006 on the HiFive Unmatched](https://github.com/kunpai/notes/blob/main/SPECInstallation.md)

2. Run `. ./shrc` in your base SPEC directory.

## Running

1. Run `chmod 777 SPECRuns.sh` to enable the script to run.

2. Run using `./SPECRuns.sh default`. The $1 parameter in this script is to categorize the run of the system, for example, lowerclk or lowercachesize, which will be used to name the folder all your data will be transferred to.

3. The output of the program itself will be stored in a .out file. The perf run will be stored in a .perf file.

## Additional Information

The naming convention of both `.out` ans `.perf` files is `[bench][number][test]`.

`[bench]`: Name of the benchmark. _perlbench_, _mcf_, etc.
`[number]`: Number of iterations each test is run. 2 means the test has been run on that benchmark 2 times.
`[test]`: Test sizes. For SPEC2006, it is _test_, _ref_, and _train_.
