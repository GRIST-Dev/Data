import cdsapi
import sys
c = cdsapi.Client()

pathin =sys.argv[1] ; print('Path IN :  ' + pathin)
date = sys.argv[2] ;  print('Date    :  ' + date)
gribfile = pathin + '/ERA5.sf.'+ date[0:8] + '.grib' ; print('GribFile :   '+ gribfile)
# date= 20200710
year = date[0:4] ; print('Year :   ' + year)
mon  = date[4:6] ; print('Month:   ' + mon)
day  = date[6:8] ; print('Day  :   ' + day)
#hour = date[9:11]+':00'; print('Hour :   ' + hour)
hour = '00:00'   ; print('Hour :   ' + hour)
print('Daily Data , do not use Hour ')

c.retrieve(
    'reanalysis-era5-single-levels',
{
    'product_type':'reanalysis',
    'format':'grib',
    'variable':[
        'sea_surface_temperature', 'skin_temperature','sea_ice_cover',
    ],
    'year':str(year),
    'month':str(mon),
    'day':str(day),
    'time':str(hour)
#        ['00:00','06:00','12:00','18:00']
},
gribfile)
