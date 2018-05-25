#!/bin/bash
#SBATCH -N  25
#SBATCH -J  vc_relax
#SBATCH -C  knl,quad,cache
#SBATCH -q  regular
#SBATCH -A  m1700
#SBATCH -t  30:00:00
#OpenMP settings:
export OMP_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread


module load espresso/6.1


# run from directory where this script is
WORK_DIR='/global/cscratch1/sd/jiahaoz/X-PEA2PbI4/serial_result'
############################################################################
mkdir -p $WORK_DIR
############################################################################
# set the needed environment variables

BIN_DIR='/global/cscratch1/sd/jiahaoz/X-PEA2PbI4/ecuttest'
path=`pwd`
PARA_PREFIX="srun -n 1600 -c 4  --cpu_bind=cores"
PARA_POSTFIX="-input"
############################################################################

# how to run executables
PW_COMMAND="$PARA_PREFIX  pw.x -npool 4  $PARA_POSTFIX"
########################################################################
mkdir  -p $WORK_DIR/relax
###########################################################



rm  -r $WORK_DIR/*
cd $WORK_DIR
PSEUDO_DIR='/global/cscratch1/sd/jiahaoz/X-PEA2PbI4/psps_from_Steve'
cp $PSEUDO_DIR/c_srl_gga.upf ./C.UPF  
cp $PSEUDO_DIR/h_frl_gga.upf ./H.UPF  
cp $PSEUDO_DIR/cl_srl_gga.upf ./Cl.UPF 
cp $PSEUDO_DIR/i_srl_gga.upf ./I.UPF
cp $PSEUDO_DIR/n_srl_gga.upf ./N.UPF
cp $PSEUDO_DIR/pb_srl_gga.upf ./Pb.UPF
cp $path/vcrelax.sh .
cp $path/serial.sh .
./vcrelax.sh
cp $path/relax.out .
declare -a forc_conv_thr_all
forc_conv_thr_all=( 5 6 7 8 )
etot_conv_thr_all=( 6 7 8 9 )
length=${#forc_conv_thr_all[@]};
echo $length
for i in `seq 0 $( expr $length - 1 )`
do
	./serial.sh ${forc_conv_thr_all[${i}]} ${etot_conv_thr_all[${i}]}
	./newvcrelax.sh
	cp relax.in relax${i}.in
	${PW_COMMAND} relax${i}.in >relax${i}.out
	cp relax${i}.out relax.out
done
