//
//  AppDelegate.m
//  fangXianSen
//
//  Created by 冰泪 on 2017/4/1.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "AppDelegate.h"
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


@interface AppDelegate ()
{
//    UIWindow *window;
//    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
//    
//    [self.window addSubview:navigationController.view];
//    [self.window makeKeyAndVisible];
//    
    
    /*
     @初始化地图部分
     */
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"U4AnQU8D0FmRMz1Ys6ITs3s7V8EYHxbP"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
