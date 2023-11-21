#!/bin/bash

export model=amipc

# cdo gendis,global_1 ../h1/GRIST.ATM.G6.${model}.2001-01-01-00000.1d.h1.nc weight_global_1.nc
for ((jr=2009; jr<=2009;jr++))
do
for mn in {01..12}
do

for day in {01..31}
do
export filehead=GRIST.ATM.G6.${model}.${jr}-${mn}-${day}

cp ../h1/${filehead}-00000.1d.h1.nc 1d.nc
#ncks -d ntracer,0 ${filehead}.3d.nc a.nc;
#ncwa -a ntracer a.nc 3da.nc;
#cp ../${filehead}.2d.h0.nc 2da.nc;
#ncpdq -a nlev,location_nv 2da.nc 2db.nc;
#ncpdq -a nlevp,location_nv 2db.nc 2d.nc;
#ncks 3da.nc 2d.nc<<EOF
#a
#EOF
#ncks 2d.nc 1d.nc <<EOF
#a
#EOF
#cdo -f nc copy 1d.nc 1d_new.nc
cdo -P 6 remap,global_1,weight_global_1.nc 1d.nc ${filehead}.grid.nc;
rm -rf 1d.nc;

done
done
done
