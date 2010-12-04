#/bin/bash
# Author: Ronald van Elburg  (RonaldAJ at vanElburg eu)
#
# Bash script for the paper:
#
#     R.A.J. van Elburg and Arjen van Ooyen (2010) `Impact of dendritic size and
#     dendritic topology on burst firing in pyramidal cells', 
#     PLoS Comput Biol 6(5): e1000781. doi:10.1371/journal.pcbi.1000781.
#
# Please consult readme.txt or instructions on the usage of this file.
#
# This software is released under the GNU GPL version 3: 
# http://www.gnu.org/copyleft/gpl.html


NRNHOME=/usr/local/bin
BINDIR=/bin

# Run slices

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan0.ses
$NRNHOME/nrngui -c MRC_Slice=0 simplifiedTopologiesGKCaGActScan0.ses &

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan1.ses
$NRNHOME/nrngui -c MRC_Slice=1 simplifiedTopologiesGKCaGActScan1.ses &

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan2.ses
$NRNHOME/nrngui -c MRC_Slice=2 simplifiedTopologiesGKCaGActScan2.ses &

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan3.ses
$NRNHOME/nrngui -c MRC_Slice=3 simplifiedTopologiesGKCaGActScan3.ses &

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan4.ses
$NRNHOME/nrngui -c MRC_Slice=4 simplifiedTopologiesGKCaGActScan4.ses &

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan5.ses
$NRNHOME/nrngui -c MRC_Slice=5 simplifiedTopologiesGKCaGActScan5.ses &

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan6.ses
$NRNHOME/nrngui -c MRC_Slice=6 simplifiedTopologiesGKCaGActScan6.ses &

$BINDIR/cp simplifiedTopologiesGKCaGActScan.ses simplifiedTopologiesGKCaGActScan7.ses
$NRNHOME/nrngui -c MRC_Slice=7 simplifiedTopologiesGKCaGActScan7.ses &


