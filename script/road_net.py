
import osmnx as ox
#import smopy
from distancerasters import rasterize, export_raster
import fiona
import geopandas as gpd
import rasterio
import numpy as np



inf = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/tanzania_groad.shp"
inf1 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/osm/tanzania-latest-free.shp/gis.osm_railways_free_1.shp"
inf2 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/Tan_esa_lc.tif"
inf3 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/TAN_SRTM_500m_ele.tif"
inf4 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/TAN_SRTM_500m_slope.tif"

output = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/tanRoad_rst.tif"
output1 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/tanRailrd_rst.tif"
output2 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/tan_esalc_speed.tif"
output3 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/TAN_SRTM_500m_ele_factor.tif"
output4 = r"/Users/miranda/Documents/AidData/projects/Tanzania/dataset/roads/TanRoad_raster/TAN_SRTM_500m_slp_factor.tif"


# ------------------------------------------
# processing road layer downloaed from groad (was clipped by Tanzania ADM0)

gdf = gpd.read_file(inf)
count = len(gdf)
speedlist = [10.0,60.0,120.0] * (count/3) # not replicable by other shapefile layer

gdf['randomspeed'] = speedlist

psize = 0.005

xmin = gdf.bounds['minx'].min()
xmax = gdf.bounds['maxx'].max()
ymin = gdf.bounds['miny'].min()
ymax = gdf.bounds['maxy'].max()

bounds = (xmin,ymin,xmax,ymax)

rst,_= rasterize(gdf,pixel_size=psize,bounds=bounds,output=output, attribute='randomspeed')



# ------------------------------
# processing railroad shapefile downloaded from osm

railroad = fiona.open(inf1)
railbound = railroad.bounds
psize1 = 0.5
print type(railroad)
#railroad = railroad * 40.0 # 40 is the speed 40km/hr of using railroad
rst,_= rasterize(railroad,pixel_size=psize1,bounds=railbound,output=output1)



# ------------------------------
# processing landcover

with rasterio.open(inf2) as src:

    profile = src.profile
    profile.update(count=1)

    esalc = src.read(1)

    # unit is min per km
    esalc[np.where((esalc == 10))] = 60.0/36
    esalc[np.where((esalc == 20))] = 60.0/36
    esalc[np.where((esalc == 30))] = 60.0/36
    esalc[np.where((esalc == 110))] = 60.0/36
    esalc[np.where((esalc == 120))] = 60.0/36
    esalc[np.where(esalc == 50)] = 60.0/48
    esalc[np.where(esalc == 140)] = 60.0/24
    esalc[np.where(esalc == 180)] = 60.0/60
    esalc[np.where(esalc == 190)] = 60.0/2
    esalc[np.where(esalc == 200)] = 60.0/24
    esalc[np.where(esalc == 210)] = 60.0/3
    esalc[np.where(esalc == 220)] = 60.0/48
    #esalc[np.where(esalc == 0)] = 80 # this is a guess

    with rasterio.open(output2, 'w', **profile) as dst:
        dst.write(esalc, 1)


# ----------------------------
# processing elevation and create a factor layer

with rasterio.open(inf3) as src:

    profile = src.profile
    profile.update(count=1)

    ele = src.read(1)

    ele[np.where(ele <= 2000)] = 0
    ele[np.where((ele > 2000))] = np.exp(ele[np.where(ele > 2000)] * 0.0007) * 0.15

    with rasterio.open(output3, 'w', **profile) as dst:
        dst.write(ele, 1)


# --------------------------
# processing slope and create a factor layer

with rasterio.open(inf4) as src:

    profile = src.profile
    profile.update(count=1)

    slp = src.read(1)

    slp[np.where((slp > 2000))] = np.exp(slp[np.where(slp > 2000)] * 0.0007) * 0.15
    v0 = 5
    k = 3
    v = v0 * np.exp(-(3 * slp))
    factor = v/v0

    with rasterio.open(output4, 'w', **profile) as dst:
        dst.write(factor, 1)



