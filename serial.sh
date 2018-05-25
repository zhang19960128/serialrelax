#!/bin/bash
flag="CELL_PARAMETERS";
atom_num=96;
resultfile="relax.out"
replacefile="vcrelax.sh";
newshell="newvcrelax.sh";
lines=$( expr 3 + $atom_num );
match_number=`grep -nr $flag $replacefile | cut -d : -f 1`;
grep -v "EOF" $replacefile > $newshell
echo $flag" (angstrom)" >> $newshell
grep -A $lines $flag $resultfile | tac | sed -n "1,${lines}p" | tac >> $newshell
echo "EOF" >> $newshell
sed -i "2i cat >relax.in <<EOF" $newshell
chmod +x $newshell
forc_conv_thr=$1;
etot_conv_thr=$2;
num1=`grep -nr "forc_conv_thr" $newshell | cut -d : -f 1`;
sed -i "${num1}d" $newshell;
sed -i "${num1}i \ \ \ \ forc_conv_thr=1.0d-$forc_conv_thr" $newshell;
num2=`grep -nr "etot_conv_thr" $newshell | cut -d : -f 1`;
sed -i "${num2}d" $newshell;
sed -i "   ${num2}i \ \ \ \ etot_conv_thr=1.0d-$etot_conv_thr" $newshell;
