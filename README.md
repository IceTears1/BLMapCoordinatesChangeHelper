# BLMapCoordinatesChangeHelper
地图坐标转换
博客地址：https://my.oschina.net/iceTear/blog/876670 

提供BD-09  GCJ-02 WGS84 之间的互相转换
+ (instancetype)shared;
/**
* 百度坐标系 (BD-09) 与 火星坐标系 (GCJ-02)的转换
* 即 百度 转 谷歌、高德
*/
- (CLLocationCoordinate2D)bl_bd09togcj02:(double) lng andLat:(double) lat ;
/**
* 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换
* 即谷歌、高德 转 百度
*/
- (CLLocationCoordinate2D)bl_gcj02tobd09:(double)lng andLat:(double) lat ;

/**
* WGS84转GCj02
*/
- (CLLocationCoordinate2D)bl_wgs84togcj02:(double)lng andLat:(double) lat;

/**
* GCJ02 转换为 WGS84
*/
- (CLLocationCoordinate2D)bl_gcj02towgs84:(double)lng andLat:(double)lat ;
