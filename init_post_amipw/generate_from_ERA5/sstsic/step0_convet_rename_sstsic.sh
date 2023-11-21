#pathin='../download-202107/grib'
#pathou=../download/netcdf
#res=G6
#cdo_grid_file=/fs2/home/zhangyi/gaoj/GRISTMOM/TOOLS/gendata-GRIST/${res}/grist_scrip_*.nc
if [ ! -d ${pathou} ];then
    mkdir -p ${pathou}
fi
if [ $option_download -eq 1 ];
then   
    echo 'Step 1:   Grib Data from:  '  $pathin
    echo 'Step 1:   NC   Data To  :  '  $pathou

    file=ERA5.sf.${YYYYMMDD}.grib
    if [ -f ${pathin}/${file} ]; then
    #    file=${fileL##*/}
    #    if [ "${file##*.}"x = "grib"x ] ;then
        echo 'Work on :'${file}
        echo "1) convert grib to netcdf"
        cdo -f nc copy ${pathin}/${file} ${pathou}/${file}.tmp0.nc
    # only sea ice fraction has missing, just set to 0
        #cdo setmisstoc,0     ${pathou}/${file}.tmp0.nc ${pathou}/${file}.tmp.nc

        echo "2) rename sst tsk sic"
#        cdo chname,var34,sst,var235,tsk,var31,sic ${pathou}/${file}.tmp0.nc  ${pathou}/${file}.nc
        cdo chname,var34,sst,var31,sic ${pathou}/${file}.tmp0.nc  ${pathou}/${file}.nc
        #    cdo setmisstoc,-1e30  ${pathou}/tmp.nc  ${pathou}/realNoMissCDOYconsstsic.daily${YYYYMMDD}.${res}.nc
        #    cdo -P 6 remapycon,${cdo_grid_file} ${pathou}/${file}.tmp1.nc ${pathou}/${file}.${res}.nc

        echo "3) clean"
        rm -rf ${pathou}/${file}.tmp0.nc
        echo "Done"
    else
        echo 'NO file in '${pathin}/${file}
        exit 1
    fi
else
    echo 'Step 1:   NC Data from:  '  $pathin
    echo 'Step 1:   NC Data To  :  '  $pathou
    
    file=ERA5.sf.${YYYYMMDD}.nc
    if [ -f ${pathin}/${file} ]; then
        echo 'Work on :'${file%.*}.grib.nc
        echo "1) extract sst sic"
        ncks -b F64 -v sst,siconc  ${pathin}/${file}  ${pathou}/${file}.tmp0.nc
        echo "2) rename siconc,sic"
        cdo -b F64 chname,siconc,sic ${pathou}/${file}.tmp0.nc  ${pathou}/${file%.*}.grib.nc
        #cdo setmisstoc,-1e30  ${pathou}/${file}.tmp1.nc          ${pathou}/${file}
        
        echo "3) clean"
        rm -rf ${pathou}/${file}.tmp0.nc # ${pathou}/${file}.tmp1.nc
        echo "Done"
    else
        echo 'NO file in '${pathin}/${file}
        exit 1
    fi
fi
    #done
