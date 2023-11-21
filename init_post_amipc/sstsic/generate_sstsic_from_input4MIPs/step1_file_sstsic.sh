#!/bin/bash

for ((year=1980; year<=2010; year+=10))
do 

cat > file_${year}.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
begin

f1=addfile("siconc_input4MIPs_SSTsAndSeaIce_CMIP_PCMDI-AMIP-1-1-8_gn_187001-202112.nc","r")
f2=addfile("tos_input4MIPs_SSTsAndSeaIce_CMIP_PCMDI-AMIP-1-1-8_gn_187001-202112.nc","r")

twStrt = $((year-1))12        
twLast = $((year+10))01
date  = cd_calendar(f1->time, 1)   
iStrt = ind(date.eq.twStrt)        
iLast = ind(date.eq.twLast) 

sic=f1->siconc(iStrt:iLast,:,:)
sst=f2->tos(iStrt:iLast,:,:)

sic=sic/100
copy_VarCoords(f1->siconc(iStrt:iLast,:,:), sic)
sst=sst+273.15
copy_VarCoords(f2->tos(iStrt:iLast,:,:), sst)

;************************************************
system ("/bin/rm -f sst_sic_${year}.nc")
b1=addfile("sst_sic_${year}.nc", "c")
b1->sic=sic
b1->sst=sst

end
EOF

ncl file_${year}.ncl
rm  file_${year}.ncl

done

