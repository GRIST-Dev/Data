#!/bin/bash

export indir=/THL8/home/zhangyi/fuzhen/run/exp_amipw_climate/amipw_climate_amip_era5/h0_global1/
export outdir=/THL8/home/zhangyi/fuzhen/script/amipw_climate_amip_era5/mon/
export invar=prect
export outvar=precip
cd ${outdir}

cat > file_${outvar}.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 
begin

fils=systemfunc("ls ${indir}*GRIST.ATM.G6.*")
f1=addfiles(fils, "r")        
ListSetType (f1, "join")       
var=f1[:]->${invar}
printVarSummary(var)

var1=var*24*3600*1000
copy_VarCoords(var, var1)
var1@units="mm/day"
printVarSummary(var1)

;*****************************************************************
f2=addfile("/THL8/home/zhangyi/fuzhen/obs/time/time_mon.nc","r")
time=f2->time
printVarSummary(time)

var1!0="time"
ntime=dimsizes(var1(:,0,0))
var1&time=time(0:ntime-1)
printVarSummary(var1)

if(min(var1&lon) .lt. 0)then
var1=lonFlip(var1)  
end if

var1_clm=clmMonTLL(var1)
printVarSummary(var1_clm)

;*****************************************************************
system ("/bin/rm -f ${outdir}${outvar}_clm.nc")
b=addfile("${outdir}${outvar}_clm.nc","c")
filedimdef(b,"time",-1,True)  
b->${outvar}_clm=var1_clm
b->${outvar}=var1

end
EOF

ncl file_${outvar}.ncl
rm file_${outvar}.ncl
