#res=G6
#pathin=../raw/
#pathou=../$res/
echo 'Step 3:   Initial Data From:  '  $pathin
echo 'Step 3:   Grist   Data To  :  '  $pathou

lvname=plev
filein2d=${pathin}/initial_${res}_pl_${YYYYMMDD}.nc
fileou2d=${pathou}/grist.era5.ini.pl.${res}_${YYYYMMDD}.nc
filein1d=${pathin}/initial_${res}_sf_${YYYYMMDD}.nc
fileou1d=${pathou}/grist.era5.ini.sf.${res}_${YYYYMMDD}.nc

if [ ! -d $pathou ]; then
   mkdir -p $pathou 
else
  rm -rf ${fileou1d} ${fileou2d}
fi 

echo ${YYYYMMDD}

#2d

if [ -e ${filein2d} ]; then

        rm -rf ${pathin}/initial_${res}.dim1.nc
        ncks -d time,0 ${filein2d}  ${pathin}/initial_${res}.dim2.nc
        ncwa -a time ${pathin}/initial_${res}.dim2.nc ${pathin}/tmp.nc
        ncpdq -a ncells,${lvname} ${pathin}/tmp.nc ${fileou2d}
        rm -rf ${pathin}/initial_${res}.dim2.nc ${pathin}/tmp.nc

else 
        echo "NO FILE :  "${filein2d}
        exit
fi


#1d

if [ -e ${filein1d} ]; then

        ncks -d time,0  ${filein1d}  initial_${res}.dim1.nc
        ncwa -a time initial_${res}.dim1.nc ${fileou1d}
        #append
        ncks -A ${fileou1d} ${fileou2d}
        rm -rf initial_${res}.dim1.nc ${fileou1d}

else
        echo "NO FILE :  "${filein1d}
        exit
fi
