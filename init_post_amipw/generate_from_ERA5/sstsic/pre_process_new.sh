#pathin='../download/grib/'
#pathou='../download/netcdf/'

#  2006-12-21 2006-12-22 86400
export res=G8
export cdo_grid_file=/fs2/home/zhangyi/gaoj/GRISTMOM/TOOLS/gendata-GRIST/${res}/grist_scrip_*.nc
echo "Print YYYY-MM-DD"
YYYYMMDD_s=$1
HHSS_s=00:00
YYYYMMDD_e=$2
HHSS_e=00:00
deltT=86400

INFO='-'${YYYYMMDD_s:0:4}${YYYYMMDD_s:5:2}

YYYYMMDDHH_s=${YYYYMMDD_s}' '${HHSS_s}
YYYYMMDDHH_e=${YYYYMMDD_e}' '${HHSS_e}
echo $YYYYMMDDHH_s $YYYYMMDDHH_e
ts=`/bin/date -d "$YYYYMMDDHH_s" +%s`
te=`/bin/date -d "$YYYYMMDDHH_e" +%s`
nt=$(((te-ts)/deltT))
echo 'Start From:  '`/bin/date -d @"$ts" +"%Y-%m-%d %H:%M.%S"`
echo 'End   to  :  '`/bin/date -d @"$te" +"%Y-%m-%d %H:%M.%S"`
echo 'Delt   T  :  '${deltT}   '    (Unit:s)'
echo 'Number T  :  '${nt}      

echo 'Downloading -----------'
export option_download=0

pathin=../download${INFO}/grib
if [ ! -d ${pathin} ]; then
         mkdir -p  ${pathin}
fi

tmp=$ts
while [ $tmp -le $te ]
do
        echo 'Downloading  :  '`/bin/date -d @"$tmp" +"%Y-%m-%d %H:%M.%S"`
        YYYYMMDD=`/bin/date -d @"$tmp" +"%Y%m%d"`
        if [ $option_download -eq 1 ]; then
                 echo 'Python'
                 python get_era5_sstsic_MCS.py ${pathGrib} ${YYYYMMDD}
        else 
                NCfile='/fs2/home/zhangyi/data/ERA5_DATA/'${YYYYMMDD:0:4}'/ERA5.sf.'${YYYYMMDD}'00.nc'
                echo 'Copy From :   ' ${NCfile}
                echo 'Copy To   :   ' ${pathin}'/ERA5.sf.'${YYYYMMDD}'.nc'
                cp ${NCfile} ${pathin}'/ERA5.sf.'${YYYYMMDD}'.nc'
        fi
        #.${hh}
        tmp=$((tmp + deltT))
done
echo "Finish Download ERA5 Data From Website"
echo '----------------------------------'

tmp=$ts
while [ $tmp -le $te ]
do
        export YYYYMMDD=`/bin/date -d @"$tmp" +"%Y%m%d"`
        #"%Y-%m-%d %H:%M.%S"`
        # ${year}${mon}${day}   
#
        echo '#  ========================================== # '
        echo 'Time:' $YYYYMMDD
        echo 'STEP 0 +++++'

        export pathin=../download${INFO}/grib
        export pathou=../download${INFO}/netcdf-${res}
        ./step0_convet_rename_sstsic.sh

        echo 'STEP 1 +++++' # use ncl
        pathin=../download${INFO}/netcdf-${res}
        pathou=${pathin}
        ./step1_poisson.sh 
 
        echo 'STEP 2 +++++'
        pathin=../download${INFO}/netcdf-${res}
        pathou=../sstsic-${res}${INFO}
        ./step2_remaps.sh

        tmp=$((tmp + deltT))
        sleep 10
        echo '# =============================== #'
done

echo "Check File in "  $pathou
