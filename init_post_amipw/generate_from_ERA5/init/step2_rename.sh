#res=G6
#pathin=../download/netcdf/
#pathou=../raw
echo 'Step 2:   NC Data from   :  '  $pathin
echo 'Step 2:   Initial Data To:  '  $pathou
if [ ! -d ${pathou} ]; then
  mkdir -p ${pathou}
else
  rm -rf ${pathou}/*.nc
fi


echo '2.1: PL file: '${fileou2d}
lev_type=pl
filein2d=${pathin}/ERA5.${lev_type}.${YYYYMMDD}.00.grib.${res}.nc
fileou2d=${pathou}/initial_${res}_${lev_type}_${YYYYMMDD}.nc

if [ -e ${filein2d} ]; then

        cdo chname,var130,T,var131,U,var132,V,var133,Q ${filein2d} ${fileou2d}
else
        echo "NO FILE :  "${filein2d} 
        exit
fi



echo '2.2: SF file: '${fileou1d}

lev_type=sf
filein1d=${pathin}/ERA5.${lev_type}.${YYYYMMDD}.00.grib.${res}.nc
filetmp=${pathou}/initial_${res}_${lev_type}_${YYYYMMDD}.tmp.nc
fileou1d=${pathou}/initial_${res}_${lev_type}_${YYYYMMDD}.nc

if [ -e ${filein1d} ]; then
    
        cdo chname,var134,PS,var129,SOILH,var235,SKINTEMP,var31,XICE,\
var39,SoilMoist_lv1,var40,SoilMoist_lv2,var41,SoilMoist_lv3,var42,SoilMoist_lv4,\
var139,SoilTemp_lv1,var170,SoilTemp_lv2,var183,SoilTemp_lv3,var236,SoilTemp_lv4,\
var33,SNOW,var141,SNOWH \
${filein1d} ${filetmp}

        ncks -v SNOW          ${filetmp} ${pathou}/snow.nc
        ncks -v SNOWH         ${filetmp} ${pathou}/snowh.nc
        ncks -v SOILH         ${filetmp} ${pathou}/soilh.nc
        ncks -x -v SNOW,SOILH ${filetmp} ${pathou}/newbase.nc 

        cdo mul ${pathou}/snow.nc      ${pathou}/snowh.nc ${pathou}/snow1.nc
        cdo expr,'SOILH=SOILH/9.80616' ${pathou}/soilh.nc ${pathou}/soilh1.nc 
        mv ${pathou}/snow1.nc  ${pathou}/snow.nc
        mv ${pathou}/soilh1.nc ${pathou}/soilh.nc

        ncks -A ${pathou}/snow.nc ${pathou}/newbase.nc
        ncks -A ${pathou}/soilh.nc ${pathou}/newbase.nc

        mv ${pathou}/newbase.nc ${fileou1d}

        rm -rf ${filetmp} ${pathou}/snow.nc ${pathou}/snowh.nc ${pathou}/soilh.nc

else
        echo "NO FILE :  "${filein1d} 
        exit 2
fi



