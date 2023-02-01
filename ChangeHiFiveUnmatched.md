# How to Change Clock Freq and L2 Size on the HiFive Unmatched

## Clock Freq

Source: [SiFive Forums](https://forums.sifive.com/t/setting-the-clock-to-1-2-ghz-for-ubuntu-21-04/4763), [perf Tutorial for RISC-V](https://arch.cs.ucdavis.edu/blog/2022-09-15-perf-hifive)

1. Navigate to `u-boot/arch/riscv/dts/fu740-c000-u-boot.dtsi`

2. Edit this line: `assigned-clock-rates = <1200000000>;`

3. Run the following commands:

    ``` shell
    make sifive_unmatched_defconfig

    make -j4
    ```

4. Format the SD card with U-Boot and OpenSBI.

    ``` shell
    sudo sgdisk -g --clear -a 1 \
    --new=1:34:2081         --change-name=1:spl --typecode=1:5B193300-FC78-40CD-8002-E86C45580B47 \
    --new=2:2082:10273      --change-name=2:uboot  --typecode=2:2E54B353-1271-4842-806F-E436D6AF6985 \
    --new=3:16384:282623    --change-name=3:boot --typecode=3:0x0700 \
    --new=4:286720:13918207 --change-name=4:root --typecode=4:0x8300 \
    /dev/mmcblk0

    sudo mkfs.vfat /dev/mmcblk0p3
    sudo mkfs.ext4 /dev/mmcblk0p4
    ```

5. Program the SD card with U-Boot.

    ``` shell
    sudo dd if=spl/u-boot-spl.bin of=/dev/mmcblk0 seek=34

    sudo dd if=u-boot.itb of=/dev/mmcblk0 seek=2082
    ```

6. Reboot.

## L2 Size

[IN PROGRESS]
