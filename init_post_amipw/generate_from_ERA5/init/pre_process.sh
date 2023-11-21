
export res=G8
export INFO='-200608'
export cdo_grid_file=../../${res}/grist_scrip_*.nc

#year=2006
#mon=08
#day=20
#export YYYYMMDD=${year}${mon}${day}
export YYYYMMDD=$1

echo "YYYYMMDD = " ${YYYYMMDD}
hh=00
# Step 0  Download Data

export pathin=../download${INFO}/grib

if [ ! -d ${pathin} ]; then
        mkdir -p  ${pathin} 
fi
python get_era5_pres.py ${pathin} ${YYYYMMDD}.${hh}
python get_era5_surf.py ${pathin} ${YYYYMMDD}.${hh}        

echo "Finish Download ERA5 Data From Website"


export pathin=../download${INFO}/grib
export pathou=../download${INFO}/netcdf-${res}
./step1_convert.sh

export pathin=../download${INFO}/netcdf-${res}
export pathou=../raw
./step2_rename.sh

export pathin=../raw
export pathou=../${res}${INFO}
        ./step3_post.sh

export pathou=../${res}${INFO}
./step4_postLnd.sh

#rm -rf ../../f00/${mon}/netcdf/gdas1.fnl0p25.${year}${mon}${day}00.f00.${res}UR.nc
#rm -rf ../raw/gfs_fnl00_${res}UR_pl_${year}${mon}${day}.nc
echo "Check:" "../"${res}${INFO}"/grist.era5.ini.pl."${res}"_"${YYYYMMDD}".new.nc"

echo "done"
