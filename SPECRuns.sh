for n in 1;
do
    for bench in perlbench bzip2 GemsFDTD astar bwaves cactusADM calculix povray gobmk gromacs h264ref hmmer lbm leslie3d libquantum mcf milc namd omnetpp sjeng specrand sphinx3;
    do
        for test in ref train;
        do
            echo "running $bench $n $test"
            perfv stat runspec --iteration 1 --config riscv --size $test --noreportable --nobuild $bench > $bench$n$test.out 2>> $bench$n$test.perf
        done;
    done;
done

mkdir $1_perf_data
mv *.perf $1_perf_data