# Tanzania_road

Data source:
- elevation: geoquery
- slope: geoquery
- landcover: ESA landcover dataset
- road: gRoad
- road: open street map (select the road type that you want to include in your a$

Create factor layers:
1. Cut above data layers to your study area country to save data processing time
2. Add the road speed limit to each road type layer (This has to be done in QGIS or ArcGIS, for example, open the road layer and add a field named "speed" or whatever name you prefer, and give the speed limit based on your knowledge of local country rule/policy)
3. Run the "road_net.py" (You might have to install a few requirements to run this code);
4. Above script create a factor layer for each type layer, then you should aggregate all factor layers into one layer (refer to link in 5 to see why)
5. Refer to http://forobs.jrc.ec.europa.eu/products/gam/sources.php
Note: I have not done the factor layer aggregation part, but it's very straigtforward

Road network:
1. Create a list of starting point;
2. Create a list of ending point;
3. Use gdistance function in R to produce the network using above starting/ending points and above aggregated factor layer;


