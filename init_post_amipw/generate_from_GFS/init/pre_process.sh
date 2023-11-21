
export res=G8
export INFO=JJA
export cdo_grid_file=/fs2/home/zhangyi/gaoj/GRISTMOM/TOOLS/gendata-GRIST/${res}/grist_scrip_*.nc
echo 'CDO_GRID_FILE =  ' $cdo_grid_file
#export cdo_grid_file=remapFile/grist_scrip_655362.G8X16L4EA.nc # or scrip grid file

for year in {2016..2016}; do
for mon in 3 ; do
#{8..8} ;do
#de=(00 31 29 31 30 31 30 31 31 30 31 30 31)
#for day in `seq -w 10 ${de[mon]}` ;do
for day in {01..31} ;do
        export hh=00
        # hh can be {00, 06, 12, 18}
        # hour is set in  step0  ; hour=000  
        # hour can be {000...384}
        echo ${#mon}  
        if [ ${#mon} -eq 1 ];then
                export YYYYMMDD=${year}'0'${mon}${day}
        else
                export YYYYMMDD=${year}${mon}${day}
        fi

#        export YYYYMMDD=${year}${mon}${day} #printf '%05d\n'
        echo $YYYYMMDD$hh
#        export pathou=../download${INFO}/grib
#        ./step0_download.sh

        export pathin=../raw/00
        export pathou=../download/${INFO}/netcdf-${res}
        mkdir -p ${pathou}
        ./step1_convert-n.sh

        export pathin=../download/${INFO}/netcdf-${res}
        export pathou=../download/raw
        mkdir -p ${pathou}
        ./step2_rename.sh

        export pathin=../download/raw
        export pathou=../${res}-${INFO}
        mkdir -p ${pathou}
         ./step3_post.sh


        echo "done"

done
done
done
