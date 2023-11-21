#res=G8X16L4EA
#pathin='../raw/'
#pathou='../data/'
lev_type=pl
lvname1=plev
lvname2=nSoilLevels
filein=gfs_fnl00_${res}_pl_${YYYYMMDD}.nc
fileou=grist.gfs.initial.pl.${res}_${YYYYMMDD}.00.nc

echo 'Step 3:   Initial Data From:  '  $pathin/${filein}
echo 'Step 3:   Grist   Data To  :  '  $pathou/${fileou}


if [ ! -d ${pathou} ]; then
        mkdir -p ${pathou}
else
        rm -rf ${pathou}/${fileou}
fi

echo ${YYYYMMDD}${hh}
#2d
ncks -x -v SoilMoist,SoilTemp ${pathin}/${filein} ${pathou}/tmp1.nc
ncks    -v SoilMoist,SoilTemp ${pathin}/${filein} ${pathou}/tmp2.nc

ncpdq -a ncells,${lvname1} ${pathou}/tmp1.nc ${pathou}/tmp1_1.nc
ncpdq -a ncells,${lvname2} ${pathou}/tmp2.nc ${pathou}/tmp2_1.nc
ncks -A ${pathou}/tmp1_1.nc ${pathou}/tmp2_1.nc 

mv ${pathou}/tmp2_1.nc ${pathou}/${fileou}
rm -rf ${pathou}/tmp*nc

echo ' Please check:  ' ${pathou}/${fileou}

