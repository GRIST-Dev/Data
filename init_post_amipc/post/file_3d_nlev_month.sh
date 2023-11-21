#!/bin/bash

export indir=/THL8/home/zhangyi/fuzhen/run/exp_amipw_climate/amipw_climate_amip_era5/h0_global1/
export outdir=/THL8/home/zhangyi/fuzhen/script/amipw_climate_amip_era5/mon/
export invar=qc
export outvar=qc
cd ${outdir}

cat > file_${outvar}.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"    
load "/THL8/home/zhangyi/fuzhen/script/amipw_climate_amip_era5/mon/diagnostics_cam.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 
begin

fils=systemfunc("ls ${indir}*GRIST.ATM.G6.*")
f1=addfiles(fils, "r")        
ListSetType (f1, "join")       
var1=f1[:]->${invar}
printVarSummary(var1)
var2=f1[:]->mpressureFace
printVarSummary(var2)

ntime=dimsizes(var1(:,0,0,0))
nlev=dimsizes(var1(0,:,0,0))
nlat=dimsizes(var1(0,0,:,0))
nlon=dimsizes(var1(0,0,0,:))

var3=new((/ntime,nlev,nlat,nlon/), "float")
do n=0,nlev-1
var3(:,n,:,:)=dim_avg_n_Wrap(var2(:,n:n+1,:,:), 1)
end do
var3 = var3 * 0.01 
copy_VarCoords(var1, var3)
var3!1="nlevp"
printVarSummary(var3)

varnew=new((/ntime,22,nlat,nlon/), "float")
do n=0,ntime-1
varnew(n,:,:,:)=getpvar(var1(n,:,:,:),var3(n,:,:,:))
end do
printVarSummary(varnew)

;*****************************************************************
f2=addfile("/THL8/home/zhangyi/fuzhen/obs/time/time_mon.nc","r")
time=f2->time
printVarSummary(time)

varnew!0="time"
varnew&time=time(0:ntime-1)
printVarSummary(varnew)

if(min(varnew&lon) .lt. 0)then
varnew=lonFlip(varnew)  
end if

varnew_clm=clmMonTLLL(varnew)
printVarSummary(varnew_clm)

;*****************************************************************
system ("/bin/rm -f ${outdir}${outvar}_clm.nc")
b=addfile("${outdir}${outvar}_clm.nc","c")
filedimdef(b,"time",-1,True)  
b->${outvar}_clm=varnew_clm
b->${outvar}=varnew

end
EOF

ncl file_${outvar}.ncl
rm file_${outvar}.ncl
