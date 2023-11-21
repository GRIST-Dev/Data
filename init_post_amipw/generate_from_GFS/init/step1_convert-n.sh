#cdo_grid_file=gris://www.chinapostdoctor.org.cn/ds/ssjinchuzhan/shenqing/submit.html?ShiwuId=59d3dcd3-9f39-4515-86a9-c5378d65dee5t_scrip_655362.nc # or scrip grid file
#res="G8UR"

#pathin=
#pathou=
gdas1.fnl0p25.2016060100.f00.grib2
file_in=gdas1.fnl0p25.${YYYYMMDD}${hh}.f${hh}.grib2
file_nc=gfs.${YYYYMMDD}.${hh}.grib.nc
file_ou=gdas1.fnl0p25.${YYYYMMDD}${hh}.f00.${res}.nc
file_tmp=gfs.${YYYYMMDD}.${hh}.grib.tmp.nc

#file_ou=W_NAFP_C_KWBC_2021${mon}${day}000000_P_gfs.t00z.pgrb2.0p25.f000.nc

echo 'Step 1:   GRIB Data From   :  '  $pathin/${file_in}
echo 'Step 2:   NC   Data To     :  '  $pathou/${file_ou}
echo ${YYYYMMDD}${hh}

if [ ! -d ${pathou} ]; then
        mkdir -p ${pathou}
else
        #echo ' OK '
        rm -rf ${pathou}/*.nc
fi

if [ ! -e ${file_in} ]; then 
        ###
        echo '0) convert to nc   '${file_nc}
        cdo  -f nc2 copy ${pathin}/${file_in}  ${pathou}/${file_nc}

        echo '1) extract to nc   '${file_tmp}
        ncks -v u_2,v_2,t,sp,orog,t_2,ci,soilw,sdwe,sde,depth ${pathou}/${file_nc} ${pathou}/tmp00.nc
        ncks -v t,plev,r ${pathou}/${file_nc} ${pathou}/tmp.sh00.nc
        ncwa -a time ${pathou}/tmp.sh00.nc ${pathou}/tmp.sh.nc
        cat > poisson.ncl << EOF
        
        begin
        
        f1=addfile("${pathou}/tmp.sh.nc","r")
        p    = dble2flt(f1->plev)
        p=p/100
        t    = f1->t
        r    = f1->r
        printVarSummary(p)
        printVarSummary(t)
        pr=conform_dims(dimsizes(t),p,0)
        q = mixhum_ptrh(pr,t,r,2)
        q=where(q.lt.0,0,q)
        copy_VarCoords(t,q)
  

        b1=addfile("${pathou}/tmp.q.nc", "c")
        b1->q=q

        end
        
EOF
        
        ncl poisson.ncl
        rm  poisson.ncl


        ncwa -a time ${pathou}/tmp00.nc ${pathou}/tmp0.nc
        rm -rf ${pathou}/tmp00.nc
        echo `ls ${pathou}`
        # set missing to 0, only 4 land vars have missing values (soilmoist, snow,snowh, soiltemp), soiltemp will be specially handled, so not included here
        cdo setmisstoc,0            ${pathou}/tmp0.nc ${pathou}/${file_tmp}

        # soiltNoMiss.nc
        # special handl soil temp, set its missing to skintemp
        # cut variable
        ncks -v st   ${pathou}/${file_nc}  ${pathou}/soilt1.nc
        ncwa -a time ${pathou}/soilt1.nc  ${pathou}/soilt.nc
        rm -rf ${pathou}/soilt1.nc
        # remove fillvalue
        ncatted -O -a missing_value,,d,,  ${pathou}/soilt.nc
        ncatted -O -a _FillValue,,d,,     ${pathou}/soilt.nc
        # cut ts
        ncks -v t_2 ${pathou}/${file_nc}   ${pathou}/skintemp.nc
        # rename to soil temp
        ncrename -v t_2,st          ${pathou}/skintemp.nc      ${pathou}/skintemp.0.nc
        cdo duplicate,4             ${pathou}/skintemp.0.nc    ${pathou}/skintemp.L4.nc
        ncks --fix_rec_dmn time     ${pathou}/skintemp.L4.nc   ${pathou}/skintemp.L4.1.nc
        ncrename -d time,depth      ${pathou}/skintemp.L4.1.nc ${pathou}/skintemp.L4.2.nc
        ncks -x -v time             ${pathou}/skintemp.L4.2.nc ${pathou}/skintemp.L4.3.nc
        # missing is -9e33 
        cdo ifthenelse -ltc,-1000000  ${pathou}/soilt.nc  ${pathou}/skintemp.L4.3.nc ${pathou}/soilt.nc ${pathou}/soiltNoMiss.nc
        #   st

        ncks -A ${pathou}/soiltNoMiss.nc ${pathou}/${file_tmp}
        ncks -A ${pathou}/tmp.q.nc ${pathou}/${file_tmp}
        #echo `nd ${pathou}/${file_tmp}`

        rm -rf ${pathou}/skintemp.nc
        rm -rf ${pathou}/skintemp.0.nc
        rm -rf ${pathou}/skintemp.L4.nc
        rm -rf ${pathou}/skintemp.L4.1.nc
        rm -rf ${pathou}/skintemp.L4.2.nc
        rm -rf ${pathou}/skintemp.L4.3.nc
        rm -rf ${pathou}/soilt.nc
        rm -rf ${pathou}/soiltNoMiss.nc
        rm -rf ${pathou}/tmp.*.nc



        echo "2) convert lat-lon to unstructured  " ${file_ou}

        cdo -P 6 remapycon,${cdo_grid_file} ${pathou}/${file_tmp} ${pathou}/${file_ou}

        echo "3) clean"
        
        rm -rf ${pathou}/tmp0.nc 
        rm -rf ${pathou}/${file_tmp}

        echo "done"
else
        echo "NO this File: " ${pathin}/${file_ou}

fi
