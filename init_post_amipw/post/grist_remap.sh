#atm1d-ai
cdo remapdis,r360x180 ../ai-phys/GRIST.ATM.G6UR.amipw.2020-01-29-00000.1d.h1.nc remap.atm1d-ai.nc  #直接插值

#atm2d-ai u,v
ncks -v lon_nv,lat_nv,prectDiag ../ai-phys/GRIST.ATM.G6UR.amipw.2020-01-29-00000.1d.h1.nc tmp.nc #选取lat_nv,lon_nv到tmp.nc
cp ../ai-phys/GRIST.ATM.G6UR.amipw.2020-01-29-00000.2d.h1.nc tmp1.nc #拷贝2d文件
#ncks -v uPC,vPC tmp1.nc tmp2.nc #选取uPC，vPC到tmp2.nc
ncks -A tmp1.nc tmp.nc #将tmp2.nc和tmp.nc合并
cdo remapdis,r360x180 tmp.nc remap.atm2d-ai.nc #插值
rm -rf tmp*.nc #删除中间文件

#atm3d-ai 
ncks -v lon_nv,lat_nv,precl  ../ai-phys/GRIST.ATM.G6UR.amipw.2020-01-29-00000.1d.h1.nc tmp.nc
ncwa -a ntracer ../ai-phys/GRIST.ATM.G6UR.amipw.2020-01-29-00000.3d.h1.nc tmp1.nc #选取3d文件的第0维
#ncks -d ntracer,0 ${pathin}/${file3dname} 3d.nc #当ntracer大于1时需要先提取其中一维再做平均
#ncwa -a ntracer 3d.nc -O 3d.nc
ncks -A tmp1.nc tmp.nc
cdo remapdis,r360x180 tmp.nc remap.atm3d-ai.nc
rm -rf tmp*.nc

#lnd1d
#ncks -v lon_nv,lat_nv,precl ../ai-phys/GRIST-HG8L30-Beg201606../ai-phys/GRIST.ATM.G8UR.amipw.2016-06-21-03600.1d.h1.nc tmp.nc
#cp ../ai-phys/GRIST-HG8L30-Beg201606../ai-phys/GRIST.LND.G8UR.amipw.2016-06-21-03600.1d.h1.nc tmp1.nc
#ncks -A tmp1.nc tmp.nc
#cdo remapdis,r360x180 tmp.nc remap.lnd1d.nc
#rm -rf tmp*.nc

