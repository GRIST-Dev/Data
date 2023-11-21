import cdsapi
import sys
c = cdsapi.Client()

pathin =sys.argv[1] ; print('Path IN :  ' + pathin)
date = sys.argv[2] ;  print('Date    :  ' + date)
gribfile = pathin + '/ERA5.sf.'+ date + '.grib' ; print('GribFile :   '+ gribfile)
# date= 20200710.00
year = date[0:4] ; print('Year :   ' + year)
mon  = date[4:6] ; print('Month:   ' + mon)
day  = date[6:8] ; print('Day  :   ' + day)
hour = date[9:11]; print('Hour :   ' + hour)

c.retrieve(
    'reanalysis-era5-single-levels',
{
    'product_type':'reanalysis',
    'format':'grib',
    'variable':[
        'surface_pressure', 'Geopotential', 'sea_ice_cover',
        'skin_temperature', 'snow_density', 'snow_depth',
        'soil_temperature_level_1', 'soil_temperature_level_2', 'soil_temperature_level_3', 'soil_temperature_level_4',
        'volumetric_soil_water_layer_1', 'volumetric_soil_water_layer_2', 'volumetric_soil_water_layer_3', 'volumetric_soil_water_layer_4'
    ],
    'year':str(year),
    'month':str(mon),
    'day':[
        str(day),
    ],
    'time':[
        '00:00',
    ]
},
gribfile)


