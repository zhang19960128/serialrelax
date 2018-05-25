#!/bin/bash
cat >relax.in<<EOF
&control
    calculation  	= 'vc-relax'
    restart_mode 	= 'from_scratch',
    wf_collect   	= .FALSE.
    tstress      	= .true.
    tprnfor      	= .true.
		verbosity     = high
		forc_conv_thr = 1.0d-5
		etot_conv_thr = 1.0d-4
		nstep         = 1000
    prefix       	= 'organic'
    pseudo_dir   	= './',
    outdir       	= './'
 /
 &system
    ibrav   = 0
    nat     = 94
    ntyp    = 6
    ecutwfc = 60 
!   nbnd    = 80
    occupations = 'fixed'
/
 &electrons
    conv_thr = 1.0d-8
		startingwfc='random'
		diagonalization='david'
/
&ions
    ion_dynamics = 'bfgs'
    upscale = 10
 /
&CELL
!  cell_factor = 3
   press = 0.0
   cell_dynamics = 'bfgs',
!  press_conv_thr = 0.1,
   cell_dofree = 'all' 
/
ATOMIC_SPECIES
 Pb 207.2 Pb.UPF
 I 126.90 I.UPF
 Cl 35.45  Cl.UPF
 N 14.007 N.UPF
 H 1.008   H.UPF
 C 12.011  C.UPF
K_POINTS automatic
4 4 2 0 0 0
EOF
