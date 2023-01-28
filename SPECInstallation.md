# Steps I followed to install SPEC2006 (RISC-V) on the HiFive Unmatched

Sources:

[Notes on GitHub from Zhantong Qiu](https://github.com/studyztp/some-notes/blob/main/SPEC2006_RISCV_ubuntu20.04.4_issue_note.md)

[GQBBB](https://GQBBBB/GQBBBB.github.io/issues/10)

[riscv.cfg Instructions](https://github.com/ccelio/Speckle)

[Basic Installation and some common bugs](https://sjp38.github.io/post/spec_cpu2006_install/)

[ryotta](https://ryotta-205.tistory.com/48)

[Pengfei Zuo](http://pfzuo.github.io/2016/06/12/Compile-and-debug-spec-cpu-2006-in-linux/)

## To mount and unmount the .iso file

    ``` bash
    mkdir tmnt
    sudo mount -o loop SPEC_CPU2006v1.1.iso ./tmnt
    ls tmnt
    ```

    ``` bash
    mkdir SPEC_CPU2006v1.1
    cp -R ./tmnt/* SPEC_CPU2006v1.1/
    sudo umount ./tmnt && rm -fr ./tmnt
    sudo chown -R <username> SPEC_CPU2006v1.1
    sudo chmod -R 755 SPEC_CPU2006v1.1
    cd SPEC_CPU2006v1.1
    ```

## Building the Tools

    ``` bash
        cd tools/src
    ```

Navigate to:

    ``` bash
    tools/src/expat-1.95.8/conftools/
    tools/src/tar-1.15.1/config/
    tools/src/specinvoke/
    tools/src/make-3.80/config/
    ```

Run these commands in every folder above:

    ``` bash
    wget -O config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git a=blob_plain;f=config.guess;hb=HEAD'
    wget -O config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
    ```

Navigate to `tools/src/make-3.80/glob/glob.c` and do the following:

1. Change `#if _GNU_GLOB_INTERFACE_VERSION == GLOB_INTERFACE_VERSION` to
`#if _GNU_GLOB_INTERFACE_VERSION >=GLOB_INTERFACE_VERSION`

2. Change `#if !defined __alloca && !defined GNU_LIBRARY` to `#if !defined __alloca && defined GNU_LIBRARY`

Navigate to `tools/src/specmd5sum/md5sum.c`. Comment out `#include "getline.h"`

Navigate to `tools/src/perl-5.87/makedepend.SH`. Find `-e '/^#.*<command line>/d'` and add `-e '/^#.*<command-line>/d' \` after it.

Navigate to `tools/src/perl-5.8.7/ext/IPC/SysV/SysV.xs` and comment out `#include <asm/page.h>`.

Create a `my_source.sh` in `tools/src` with the following code:

    ```bash
    #!/bin/bash
    PERLFLAGS=-Uplibpth=
    for i in `gcc -print-search-dirs | grep libraries | cut -f2- -d= | tr ':' '\n' | grep -v /gcc`; do
        PERLFLAGS="$PERLFLAGS -Aplibpth=$i"
    done
    export PERLFLAGS
    echo $PERLFLAGS
    export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
    ```

Run `source my_setup.sh`.

Build with `sudo PERLFLAGS="-A libs=-lm -A libs=-ldl" ./buildtools`.

## Running the Install Script

Move up to `SPEC_CPU2006v1.1`. Run `install.sh` with: `sudo PERLFLAGS="-A libs=-lm -A libs=-ldl" ./install.sh`

## Building with RISC-V Config

1. Go into the config directory with `cd config`. Run the following command:

        ```bash
        wget https://raw.githubusercontent.com/ccelio/Speckle/master/riscv.cfg
        ```

2. Navigate to the "Compiler selection" section and edit the CC, CXX and FC flag such that they read the following:

        ```bash
        CC  = riscv64-linux-gnu-gcc -static -Wl,-Ttext-segment,0x10000
        CXX = riscv64-linux-gnu-g++ -static -Wl,-Ttext-segment,0x10000
        FC  = riscv64-linux-gnu-gfortran -static -Wl,-Ttext-segment,0x10000
        ```

3. Build the benchmarks using:

        ``` bash
        . ./shrc
        runspec --config=riscv.cfg --action=build perlbench bzip2 GemsFDTD astar bwaves cactusADM calculix povray gobmk gromacs h264ref hmmer lbm leslie3d libquantum mcf milc namd omnetpp sjeng specrand sphinx3
        ```
    NOTE: Consider adding a `nohup` to the runspec command because compilation takes a long time. Also, the aforementioned 22 benchmarks are the only ones that fully compile on the board as of 27th Jan 2023.
