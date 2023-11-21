load "/fs2/software/ncl/6.6.2/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/fs2/software/ncl/6.6.2/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/fs2/software/ncl/6.6.2/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/fs2/software/ncl/6.6.2/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

f1=addfile("../download-202106/netcdf-G8/ERA5.sf.20210801.grib.nc","r")
sic    = f1->sic
sst    = f1->sst
tsk    = f1->tsk

guess     = 1                ; use zonal means
is_cyclic = True             ; cyclic [global]
nscan     = 1500             ; usually much less than this
eps       = 0.001            ; variable dependent
relc      = 0.6              ; relaxation coefficient
opt       = 0                ; not used
poisson_grid_fill( sst, is_cyclic, guess, nscan, eps, relc, opt)

b1=addfile("../download-202106/netcdf-G8/realNoMissCDOYconsstsic.daily20210801.G8.nc", "c")

b1->sic=sic
b1->sst=sst
b1->tsk=tsk

end
