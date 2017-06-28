//
//  MapVC.h
//  fangXianSen
//
//  Created by 冰泪 on 2017/4/5.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
@interface MapVC : UIViewController<BMKMapViewDelegate,BMKPoiSearchDelegate>

@end
