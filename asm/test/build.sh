#!/usr/bin/env sh

for prog in decimal_add_test nop_test
do
    asl -cpu sc/mp ${defs} -L ${prog}.asm &&
    p2bin ${prog} &&
    p2hex ${prog} ${prog}.ihx -F Intel -l 32 &&
    hexdump -v -e '1/1 "%02x\n"' ${prog}.bin > ${prog}.hd
    rm ${prog}.p
    # Hack into a BASIC loader
    echo
    echo CUT AND PASTE INTO NIBL
    od -Ad -tx1 -w1 -v ${prog}.bin | \
        head -n -1 | \
        cut -c5- | \
        tr "a-f" "A-F" | \
        awk '{print $1 " @(TOP+" $1 ")=#"  $2}'
    echo RUN
    echo
    echo to run test:
    echo LINK TOP
done
