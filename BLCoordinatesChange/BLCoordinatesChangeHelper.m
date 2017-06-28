//
//  coordinatesChangeHelper.m
//
//  Created by 冰泪 on 2017/4/10.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLCoordinatesChangeHelper.h"

@implementation BLCoordinatesChangeHelper
/**
 * 百度坐标系 (BD-09) 与 火星坐标系 (GCJ-02)的转换
 * 即 百度 转 谷歌、高德
 */
- (CLLocationCoordinate2D)bl_bd09togcj02:(double) lng andLat:(double) lat {
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = lng - 0.0065;
    double y = lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double bl_lng = z * cos(theta);
    double bl_lat = z * sin(theta);
    CLLocationCoordinate2D coor;
    coor.longitude = bl_lng;
    coor.latitude = bl_lat;
    return coor;
}
/**
 * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换
 * 即谷歌、高德 转 百度
 */
- (CLLocationCoordinate2D)bl_gcj02tobd09:(double)lng andLat:(double) lat {
    double z = sqrt(lng * lng + lat * lat) + 0.00002 * sin(lat * _x_PI);
    double theta = atan2(lat, lng) + 0.000003 * cos(lng * _x_PI);
    double bl_lng = z * cos(theta) + 0.0065;
    double bl_lat = z * sin(theta) + 0.006;
    CLLocationCoordinate2D coor;
    coor.longitude = bl_lng;
    coor.latitude = bl_lat;
    return coor;
}

/**
 * WGS84转GCj02
 */
- (CLLocationCoordinate2D)bl_wgs84togcj02:(double)lng andLat:(double) lat {
    if ([self out_of_china:lng andLat:lat ]) {
        CLLocationCoordinate2D coor;
        coor.longitude = lng;
        coor.latitude = lat;
        return coor;
    }else {
        double dlat = [self transformlat:lng - 105.0 andLat:lat - 35.0];
        double dlng = [self transformlng:lng - 105.0 andLat:lat - 35.0];
        double radlat = lat / 180.0 * _PI;
        double magic = sin(radlat);
        magic = 1 - _ee * magic * magic;
        double sqrtmagic = sqrt(magic);
        dlat = (dlat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtmagic) * _PI);
        dlng = (dlng * 180.0) / (_a / sqrtmagic * cos(radlat) * _PI);
        double bl_lat = lat + dlat;
        double bl_lng = lng + dlng;
        
        CLLocationCoordinate2D coor;
        coor.longitude = bl_lng;
        coor.latitude = bl_lat;
        return coor;
    }
}

/**
 * GCJ02 转换为 WGS84
 */
- (CLLocationCoordinate2D)bl_gcj02towgs84:(double)lng andLat:(double)lat {
   if ([self out_of_china:lng andLat:lat ]) {
        CLLocationCoordinate2D coor;
        coor.longitude = lng;
        coor.latitude = lat;
        return coor;
    }
    else {
        double dlat = [self transformlat:lng - 105.0 andLat:lat - 35.0];
        double dlng = [self transformlng:lng - 105.0 andLat:lat - 35.0];
        double radlat = lat / 180.0 * _PI;
        double magic = sin(radlat);
        magic = 1 - _ee * magic * magic;
        double sqrtmagic = sqrt(magic);
        dlat = (dlat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtmagic) * _PI);
        dlng = (dlng * 180.0) / (_a / sqrtmagic * cos(radlat) * _PI);
        double bl_lat = lat + dlat;
        double bl_lng = lng + dlng;
        CLLocationCoordinate2D coor;
        coor.longitude = bl_lng;
        coor.latitude = bl_lat;
        return coor;
    }
}

- (double)transformlat:(double)lng andLat:(double)lat {
    double ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * sqrt(fabs(lng));
    ret += (20.0 * sin(6.0 * lng * _PI) + 20.0 * sin(2.0 * lng * _PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(lat * _PI) + 40.0 * sin(lat / 3.0 * _PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(lat / 12.0 * _PI) + 320 * sin(lat * _PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

- (double)transformlng:(double)lng andLat:(double)lat{
    double ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * sqrt(fabs(lng));
    ret += (20.0 * sin(6.0 * lng * _PI) + 20.0 * sin(2.0 * lng * _PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(lng * _PI) + 40.0 * sin(lng / 3.0 * _PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(lng / 12.0 * _PI) + 300.0 * sin(lng / 30.0 * _PI)) * 2.0 / 3.0;
    return ret;
}

/**
 * 判断是否在国内，不在国内则不做偏移
 */
- (BOOL)out_of_china:(double)lng andLat:(double)lat {
    return (lng < 72.004 || lng > 137.8347) || ((lat < 0.8293 || lat > 55.8271) || false);
}
-(instancetype)init{
    _x_PI = 3.14159265358979324 * 3000.0 / 180.0;
    _PI = 3.1415926535897932384626;
    _a = 6378245.0;
    _ee = 0.00669342162296594323;
    return self;
}
+ (instancetype)shared {
    static BLCoordinatesChangeHelper *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BLCoordinatesChangeHelper alloc] init];
    });
    return manager;
}

@end
