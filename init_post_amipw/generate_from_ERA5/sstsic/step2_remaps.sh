#pathin='../download/grib/20210720/'
#pathin=../download/grib
#pathou=../download/netcdf
if [ ! -d ${pathou} ];then
   mkdir -p ${pathou}
fi
   
echo 'Step 2:   NC   Data from:  '  $pathin
echo 'Step 2:   NC   Data To  :  '  $pathou
#res=G6
#lev_type=sf

#cdo_grid_file=/fs2/home/zhangyi/gaoj/GRISTMOM/TOOLS/gendata-GRIST/${res}/grist_scrip_*.nc

filein=${pathin}/realNoMissCDOYconsstsic.daily${YYYYMMDD}.${res}.nc
fileou=${pathou}/realNoMissCDOYconsstsic.daily${YYYYMMDD}.${res}.nc
filetmp=${pathou}/realNoMissCDOYconsstsic.daily${YYYYMMDD}.${res}.tmp.nc

if [ -f ${filein} ]; then
    echo 'Remaps  :  '${filein} 

    rm -rf  ${fileou}
    cdo -P 6 remapycon,${cdo_grid_file} ${filein} ${filetmp}
    cdo setmisstoc,0    ${filetmp} ${fileou}
    rm -rf ${filetmp} 

echo "Done"
else
    echo 'NO file in '${filein}
    exit 2
fi

#done
