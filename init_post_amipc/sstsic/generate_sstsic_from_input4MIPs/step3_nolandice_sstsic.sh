#!/bin/bash

for ((year=1980; year<=${year}; year+=10))
do 

cat > nolandice_${year}.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
begin

f0=addfile("static_g6.nc","r")
MASK=f0->MASK
printVarSummary(MASK)

iland =ind(MASK .eq. 1)
isea  =ind(MASK .eq. 0)

f1=addfile("realNoMissingNewSstSic.${year}.grist.g6.nc", "r")
sic      =f1->sic
sst      =f1->sst
lon      =f1->lon
lon_bnds =f1->lon_bnds
lat      =f1->lat
lat_bnds =f1->lat_bnds
printVarSummary(sic)
sic(:,iland)=0

system ("/bin/rm -f realNoMissingNewSstSic.${year}.grist.g6.nc")
b1=addfile("realNoMissingNewSstSic.${year}.grist.g6.nc", "c")
b1->sic=sic
b1->sst=sst
b1->lon=lon
b1->lon_bnds=lon_bnds
b1->lat=lat
b1->lat_bnds=lat_bnds

end
EOF

ncl nolandice_${year}.ncl
rm  nolandice_${year}.ncl

done