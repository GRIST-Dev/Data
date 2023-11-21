import cdsapi
import sys

c = cdsapi.Client()

# for year in range(2021, 2021 + 1):
# for imon in range(7,8):
# st = 17
# en = 25
# if (imon==2):
# en=29
# elif (imon==4):
# en=30
                            
# for iday in range (st, en+1):
# mon  = "%02d" % imon
# day  = "%02d" % iday

# date = str(year)+'-'+str(mon)+'-'+str(day)+'/to/'+str(year)+'-'+str(mon)+'-'+str(day)
# print(date)
pathin =sys.argv[1] ; print('Path IN :  ' + pathin)
date = sys.argv[2] ;  print('Date    :  ' + date)
gribfile = pathin + '/ERA5.pl.'+ date + '.grib' ; print('GribFile :   '+ gribfile)
# date= 20200710.00
year = date[0:4] ; print('Year :   ' + year)
mon  = date[4:6] ; print('Month:   ' + mon)
day  = date[6:8] ; print('Day  :   ' + day)
hour = date[9:11]; print('Hour :   ' + hour)
c.retrieve(
    'reanalysis-era5-pressure-levels',
{
    'product_type':'reanalysis',
    'format':'grib',
    'variable':[
        'specific_humidity','temperature','u_component_of_wind',
        'v_component_of_wind'
    ],
    'pressure_level':[
        '1','2','3','5','7','10',
        '20', '30','50','70','100','125',
        '150','175','200','225','250','300',
        '350','400','450','500','550','600',
        '650','700','750','775','800','825',
        '850','875','900','925','950','975',
        '1000'
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
