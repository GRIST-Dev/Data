#pathin=../download/grib/
#pathou=../download/netcdf/
echo 'Step 1:   Grib Data from:  '  $pathin
echo 'Step 1:   NC   Data To  :  '  $pathou
if [ ! -d ${pathou} ]; then
  mkdir -p ${pathou}
else
  rm -rf ${pathou}/*.nc
fi
#res=G6
#cdo_grid_file=/THL8/home/zhangyi/gaoj/gendata-GRIST/${res}/grist_scrip_*.nc
echo 'CDO_GRID_FILE =  ' $cdo_grid_file

#cd $pathin

ls ${pathin}/ERA5*${YYYYMMDD}.00.grib

for fileL in `ls ${pathin}/ERA5*${YYYYMMDD}.00.grib` ;do
        file=${fileL##*/}

if [ "${file##*.}"x = "grib"x ] ;then

        echo ${file}
        echo "1) convert grib to netcdf"
        cdo -f nc copy ${pathin}/${file} ${pathou}/${file}.tmp0.nc
# only sea ice fraction has missing, just set to 0
        cdo setmisstoc,0                 ${pathou}/${file}.tmp0.nc ${pathou}/${file}.tmp.nc

        echo "2) convert lat-lon to unstructured"
        cdo -P 6 remapycon,${cdo_grid_file} ${pathou}/${file}.tmp.nc ${pathou}/${file}.${res}.nc

        echo "3) clean"
        rm -rf ${pathou}/${file}.tmp.nc ${pathou}/${file}.tmp0.nc
        echo "done"

else
        echo 'NO grib file in  :  '${pathin}
        exit 1
fi
done
