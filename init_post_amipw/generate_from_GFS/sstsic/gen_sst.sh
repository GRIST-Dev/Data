res=G8
pathou='/fs2/home/zhangyi/wangym/data/fnl/G8-JJA/sstsic'
lev_type=pl

mkdir -p ${pathou}

for year in {2016..2016} ;do
for mon in {03..03} ;do
for day in {01..31} ;do

pathin='/fs2/home/zhangyi/wangym/data/fnl/G8-JJA'
echo ${year} ${mon} ${day} 

if true ;then
   ncks -v SKINTEMP,XICE ${pathin}/grist.gfs.initial.pl.G8_${year}${mon}${day}.00.nc ${pathou}/sst_sic_tmp.${year}${mon}${day}.nc
   ncrename -v XICE,sic -v SKINTEMP,sst ${pathou}/sst_sic_tmp.${year}${mon}${day}.nc ${pathou}/realNoMissGFSSstSic.daily.${year}${mon}${day}.GRIST.nc
   rm -rf ${pathou}/sst_sic_tmp*.nc   
fi

done
done
done

