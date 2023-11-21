#!/bin/bash
#year=2020

filein=${pathin}/ERA5.sf.${YYYYMMDD}.grib.nc 
fileou=${pathou}/realNoMissCDOYconsstsic.daily${YYYYMMDD}.${res}.nc
rm -rf ${fileou}
echo 'Step 1: possion inte to :  ' ${fileou}

cat > poisson_.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

f1=addfile("${filein}","r")
sic    = f1->sic
sst    = f1->sst
;tsk    = f1->tsk

guess     = 1                ; use zonal means
is_cyclic = True             ; cyclic [global]
nscan     = 6000             ; usually much less than this
eps       = 0.001            ; variable dependent
relc      = 1.6              ; relaxation coefficient
opt       = 0                ; not used
poisson_grid_fill( sst, is_cyclic, guess, nscan, eps, relc, opt)

b1=addfile("${fileou}", "c")

b1->sic=sic
b1->sst=sst
;b1->tsk=tsk

end
EOF

ncl poisson_.ncl
#rm  poisson_.ncl

