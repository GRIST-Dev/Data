#!/bin/bash

export indir=/THL8/home/zhangyi/fuzhen/run/exp_amipw_climate/amipw_climate_amip_era5_snow_2/h1_post/
export outdir=/THL8/home/zhangyi/fuzhen/script/amipw_climate_amip_era5_snow_2/

export invar=u
export outvar=uwnd
cd ${indir}
rm *-02-29.grid.nc*
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
var_1000=f1[:]->${invar}1000
var_950=f1[:]->${invar}950
var_900=f1[:]->${invar}900
var_850=f1[:]->${invar}850
var_800=f1[:]->${invar}800
var_700=f1[:]->${invar}700
var_600=f1[:]->${invar}600
var_500=f1[:]->${invar}500
var_400=f1[:]->${invar}400
var_300=f1[:]->${invar}300
var_250=f1[:]->${invar}250
var_200=f1[:]->${invar}200
var_150=f1[:]->${invar}150
var_100=f1[:]->${invar}100
printVarSummary(var_1000)

ntime=dimsizes(var_1000(:,0,0))
nlev=14
nlat=dimsizes(var_1000(0,:,0))
nlon=dimsizes(var_1000(0,0,:))

var=new((/ntime,nlev,nlat,nlon/), "float")
var(:,0,:,:)=var_1000
var(:,1,:,:)=var_950
var(:,2,:,:)=var_900
var(:,3,:,:)=var_850
var(:,4,:,:)=var_800
var(:,5,:,:)=var_700
var(:,6,:,:)=var_600
var(:,7,:,:)=var_500
var(:,8,:,:)=var_400
var(:,9,:,:)=var_300
var(:,10,:,:)=var_250
var(:,11,:,:)=var_200
var(:,12,:,:)=var_150
var(:,13,:,:)=var_100

;*****************************************************************
f2=addfile("/THL8/home/zhangyi/fuzhen/obs/time/time.nc","r")
time=f2->time
printVarSummary(time)
var!0="time"
var&time=time(0:ntime-1)

;*****************************************************************
var!1="lev"
lev=(/1000,950,900,850,800,700,600,500,400,300,250,200,150,100/)
lev@standard_name = "air_pressure"
lev@long_name = "isobaric level"
lev@units = "hPa"
lev@positive = "down"
lev@axis = "Z"
var&lev=lev

if(min(var&lon) .lt. 0)then
var=lonFlip(var)  
end if
printVarSummary(var)

;*****************************************************************
system ("/bin/rm -f ${outdir}${outvar}.nc")
b=addfile("${outdir}${outvar}.nc","c")
filedimdef(b,"time",-1,True)  
b->${outvar}=var

end
EOF

cat > file_${outvar}_anom.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 
begin

f1=addfile("${outdir}${outvar}.nc","r")
var=f1->${outvar}
printVarSummary(var)

nday=dimsizes(var&time)
nyear=nday/365
nlev=dimsizes(var&lev)
nlat=dimsizes(var&lat)    
nlon=dimsizes(var&lon) 

var_day=new((/365,nlev,nlat,nlon/),"float")
do n=0,364
var_day(n,:,:,:)=dim_avg_n_Wrap(var(n::365,:,:,:),0)
end do
var_anom=new((/nday,nlev,nlat,nlon/),"float")
do n=0,nyear-1
var_anom(n*365:364+n*365,:,:,:)=var(n*365:364+n*365,:,:,:)-var_day
end do
copy_VarCoords(var,var_anom)
printVarSummary(var_anom)

system ("/bin/rm -f ${outdir}${outvar}_anom.nc")
b=addfile("${outdir}${outvar}_anom.nc","c")
filedimdef(b,"time",-1,True)  
b->${outvar}=var_anom

end
EOF

cat > file_${outvar}_iso.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 
begin

f1=addfile("${outdir}${outvar}.nc","r")                           
var=f1->${outvar}

sigma=1.0         
nWgt=201          
fca=1./90.                
fcb=1./20.               
wgt_iso=filwgts_lanczos(nWgt,2,fca,fcb,sigma)   
 
var_iso=wgt_runave_n_Wrap(var,wgt_iso,0,0)  

system ("/bin/rm -f ${outdir}${outvar}_iso.nc")
b1=addfile("${outdir}${outvar}_iso.nc","c")                  
filedimdef(b1,"time",-1,True)                  
b1->${outvar}=var_iso                      

end
EOF

cat > file_${outvar}_winter.ncl << EOF
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 
begin

f1=addfile("${outdir}${outvar}.nc","r")
f2=addfile("${outdir}${outvar}_anom.nc","r")
f3=addfile("${outdir}${outvar}_iso.nc","r")
var1=f1->${outvar}
var2=f2->${outvar}
var3=f3->${outvar}
;*************************************************
date1=cd_calendar(var1&time,0)
mm=toint(date1(:,1))
iwinter=ind((mm.ge.1 .and. mm.le.4).or.(mm.ge.11 .and. mm.le.12))

var1_winter=var1(iwinter,:,:,:) 
var2_winter=var2(iwinter,:,:,:) 
var3_winter=var3(iwinter,:,:,:) 

nday=dimsizes(var1_winter&time)
print(nday)
;*************************************************
system ("/bin/rm -f ${outdir}${outvar}_winter.nc")
b1=addfile("${outdir}${outvar}_winter.nc","c")
filedimdef(b1,"time",-1,True)    

system ("/bin/rm -f ${outdir}${outvar}_anom_winter.nc")
b2=addfile("${outdir}${outvar}_anom_winter.nc","c")
filedimdef(b2,"time",-1,True)    

system ("/bin/rm -f ${outdir}${outvar}_iso_winter.nc")
b3=addfile("${outdir}${outvar}_iso_winter.nc","c")
filedimdef(b3,"time",-1,True)    

b1->${outvar}=var1_winter
b2->${outvar}=var2_winter
b3->${outvar}=var3_winter

end
EOF

ncl file_${outvar}.ncl
ncl file_${outvar}_anom.ncl
ncl file_${outvar}_iso.ncl
ncl file_${outvar}_winter.ncl

rm file_${outvar}.ncl
rm file_${outvar}_anom.ncl
rm file_${outvar}_iso.ncl
rm file_${outvar}_winter.ncl