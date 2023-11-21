#res=G8UR
lev_type=pl
#pathin=../download/netcdf-${res}
#pathou='../raw/'

filein=gdas1.fnl0p25.${YYYYMMDD}${hh}.f00.${res}.nc
fileou=gfs_fnl00_${res}_${lev_type}_${YYYYMMDD}.nc
echo 'Step 2:   NC Data From   :  '  $pathin/${filein}
echo 'Step 2:   Initial Data To:  '  $pathou/${fileou}
echo ${YYYYMMDD}${hh}


if [ ! -d ${pathou} ]; then
        mkdir -p ${pathou}
else
        rm -rf ${pathou}/${fileou}
fi
#
#cdo change name
cdo chname,t,T,u_2,U,v_2,V,q,Q,sp,PS,orog,SOILH,t_2,SKINTEMP,ci,XICE,soilw,SoilMoist,st,SoilTemp,sdwe,SNOW,sde,SNOWH \
${pathin}/${filein} ${pathou}/tmp.nc

# calculaete mid-level soil level
# cdo expr,'lv_DBLL11_l0=(lv_DBLL11_l0+lv_DBLL11_l1)/2;' ${pathou}/tmp.nc ${pathou}/tmp1.nc
# cdo cannot change dim name, use ncrename
# ncrename -d lv_DBLL11,nSoilLevels -v lv_DBLL11_l0,nSoilLevels ${pathou}/tmp1.nc ${pathou}/tmp2.nc
# ncrename -d lv_ISBL0,plev -d lv_DBLL11,nSoilLevels -v lv_ISBL0,plev ${pathou}/tmp.nc ${pathou}/tmp3.nc
# ncks -A tmp2.nc tmp3.nc

ncrename -d depth,nSoilLevels ${pathou}/tmp.nc ${pathou}/tmp3.nc
# cut
ncks -v U,V,T,Q,PS,SKINTEMP,XICE,SoilMoist,SoilTemp,SNOW,SNOWH,SOILH ${pathou}/tmp3.nc ${pathou}/${fileou}
#ncks -A ${pathou}/tmp2.nc ${pathou}/gfs_initial_${res}_${lev_type}_${year}${mon}${day}.nc 
rm -rf ${pathou}/tmp.nc ${pathou}/tmp1.nc ${pathou}/tmp2.nc ${pathou}/tmp3.nc
