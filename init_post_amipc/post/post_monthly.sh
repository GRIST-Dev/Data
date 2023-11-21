#!/bin/bash

export model=amipc

cdo gendis,global_1 ../h0/GRIST.ATM.G6.${model}.MonAvg.2001-01.1d.h0.nc weight_global_1.nc
for ((jr=2001; jr<=2010;jr++))
do
for mn in {01..12}
do

export filehead=GRIST.ATM.G6.${model}.MonAvg.${jr}-${mn}

cp ../h0/${filehead}.1d.h0.nc 1d.nc
#ncks -d ntracer,0 ${filehead}.3d.nc a.nc;
#ncwa -a ntracer a.nc 3da.nc;
cp ../h0/${filehead}.2d.h0.nc 2da.nc;
ncpdq -a nlev,location_nv 2da.nc 2db.nc;
ncpdq -a nlevp,location_nv 2db.nc 2d.nc;
#ncks 3da.nc 2d.nc<<EOF
#a
#EOF
ncks 2d.nc 1d.nc <<EOF
a
EOF
cdo -f nc copy 1d.nc 1d_new.nc
cdo -P 6 remap,global_1,weight_global_1.nc 1d_new.nc ${filehead}.grid.nc;
rm -rf 1d.nc 2d.nc 2da.nc 2db.nc 3da.nc a.nc 1d_new.nc;

done
done
