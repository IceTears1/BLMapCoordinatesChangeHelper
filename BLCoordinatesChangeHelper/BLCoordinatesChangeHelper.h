//
//  coordinatesChangeHelper.h
//
//  Created by 冰泪 on 2017/4/10.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import "coordinatesChange.h"

@interface BLCoordinatesChangeHelper : NSObject
@property (nonatomic,assign) float  x_PI;
@property (nonatomic,assign) float  PI;
@property (nonatomic,assign) float  a;
@property (nonatomic,assign) float  ee;
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

@end
