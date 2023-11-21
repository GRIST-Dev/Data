pathin='/THL8/home/zhangyi/fuzhen/inputdata/amip_cmip6_ini'
pathou='/THL8/home/zhangyi/fuzhen/inputdata/amip_cmip6_ini'
cdo_grid_file=/THL8/home/zhangyi/fuzhen/gendata-GRIST/G6/grist_scrip_40962.nc

for ((year=1980; year<=2010; year+=10))
do 

cdo setmisstoc,0 ${pathin}sst_sic_${year}.nc ${pathou}sst_sic_${year}_temp.nc
cdo -P 6 remapycon,${cdo_grid_file} ${pathou}sst_sic_${year}_temp.nc realNoMissingNewSstSic.${year}.grist.g6.nc
rm ${pathou}sst_sic_${year}_temp.nc

ncatted -a _FillValue,,m,f,-1e30 realNoMissingNewSstSic.${year}.grist.g6.nc
ncatted -a missing_value,,m,f,-1e30 realNoMissingNewSstSic.${year}.grist.g6.nc

done