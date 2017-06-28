//
//  ViewController.m
//  fangXianSen
//
//  Created by 冰泪 on 2017/4/1.
//  Copyright © 2017年 冰泪. All rights reserved.
//
#import "ViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "MapVC.h"
#import <MapKit/MapKit.h>
#import <UIImageView+WebCache.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import "BLCoordinatesChangeHelper.h"

@interface ViewController ()<BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView* mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch* _searcher;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
}



//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"我的位置 lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
}
- (void)getCurrentLocation{
    
    //获取自身所在位置的 经纬度
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
}


- (void)positionCode{
    
    //地里位置编码
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= @"上海市";
    geoCodeSearchOption.address = @"青浦区徐泾镇龙联路208弄164号";
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //地里编码成功
        NSLog(@"%@-坐标-%f--%f",result.address,result.location.latitude,result.location.longitude);
    }
    else {
        NSLog(@"抱歉，未找到结果1");
    }
}



- (void)positionContraryCode{
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){37.51614,-121.99291};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      NSLog(@"-%f--%f-坐标位置-%@",result.location.latitude,result.location.longitude,result.address);
  }
  else {
      NSLog(@"抱歉，未找到结果2");
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMapView];//创建地图
//    [self createStaticMapView];//创建静态地图
    
    [self getCurrentLocation];
    [self positionCode];
    [self positionContraryCode];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, 100, 30)];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(jumpMapEvent2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.tag = 0;
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(120,64, 100, 30)];
    [btn1 setTitle:@"跳转1" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 addTarget:self action:@selector(jumpMapEvent2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    btn1.tag = 1;
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(240,64, 100, 30)];
    [btn2 setTitle:@"跳转2" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor blueColor]];
    [btn2 addTarget:self action:@selector(jumpMapEvent2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    btn2.tag = 2;
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(0,64+40, 70, 30)];
    [btn3 setTitle:@"百度" forState:UIControlStateNormal];
    btn3.tag = 3;
    [btn3 setBackgroundColor:[UIColor blueColor]];
    [btn3 addTarget:self action:@selector(jumpMapEvent2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(80,64+40, 70, 30)];
    [btn4 setTitle:@"高德" forState:UIControlStateNormal];
    btn4.tag = 4;
    [btn4 setBackgroundColor:[UIColor blueColor]];
    [btn4 addTarget:self action:@selector(jumpMapEvent2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(160,64+40, 70, 30)];
    [btn5 setTitle:@"谷歌" forState:UIControlStateNormal];
    btn5.tag = 5;
    [btn5 setBackgroundColor:[UIColor blueColor]];
    [btn5 addTarget:self action:@selector(jumpMapEvent2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [[UIButton alloc]initWithFrame:CGRectMake(240,64+40, 70, 30)];
    [btn6 setTitle:@"自带" forState:UIControlStateNormal];
    btn6.tag = 6;
    [btn6 setBackgroundColor:[UIColor blueColor]];
    [btn6 addTarget:self action:@selector(jumpMapEvent2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
   
}
- (NSString *)changeCodeToUtf8:(NSString *)str{
    if ([[UIDevice currentDevice] systemVersion].doubleValue >=9.0) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else{
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}
- (void)jumpMapEvent2:(UIButton *)btn{
    CLLocationCoordinate2D coor;
    coor.latitude = 31.201079;
    coor.longitude = 121.299152;
    switch (btn.tag) {
        case 0:
        {//跳转
            MapVC *map = [[MapVC alloc]init];
            [self.navigationController pushViewController:map animated:YES];
        }
            break;
        case 1:
        {//跳转1
         
            
            
        }
            break;
        case 2:
        {//跳转2
            CLLocationCoordinate2D coor1;
            coor1.latitude = 31.2327317388;
            coor1.longitude = 121.4866902973;
            
            CLLocationCoordinate2D coor2=[[BLCoordinatesChangeHelper shared] bl_bd09togcj02:coor1.longitude andLat:coor1.latitude];
            NSLog(@"bd->gc   %f--%f",coor2.latitude,coor2.longitude);
            
            CLLocationCoordinate2D coor3=[[BLCoordinatesChangeHelper shared] bl_gcj02tobd09:coor2.longitude andLat:coor2.latitude];
            NSLog(@"gc->bd   %f--%f",coor3.latitude,coor3.longitude);
            
            CLLocationCoordinate2D coor4=[[BLCoordinatesChangeHelper shared] bl_gcj02towgs84:coor2.longitude andLat:coor2.latitude];
            NSLog(@"gc->wgs   %f--%f",coor4.latitude,coor4.longitude);
            
            CLLocationCoordinate2D coor5=[[BLCoordinatesChangeHelper shared] bl_wgs84togcj02:coor4.longitude andLat:coor4.latitude];
            NSLog(@"wgs->gc   %f--%f",coor5.latitude,coor5.longitude);
            
        }
            break;
        case 3:
        {//百度
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
                NSLog(@"安装了百度地图");
                /*
                 
                 origin 	起点名称或经纬度，或者可同时提供名称和经纬度，此时经纬度优先级高，将作为导航依据，名称只负责展示。 	
                 1、名称：天安门
                 2、经纬度：39.98871<纬度>,116.43234<经度>。 3、名称和经纬度：name:天安门|latlng:39.98871,116.43234
                 
                 destination 	终点名称或经纬度，或者可同时提供名称和经纬度，此时经纬度优先级高，将作为导航依据，名称只负责展示。
                 mode 	导航模式，固定为transit、driving、navigation、walking，riding分别表示公交、驾车、导航、步行和骑行 	必选
                 region 	城市名或县名 	当给定region时，认为起点和终点都在同一城市，除非单独给定起点或终点的城市。
                 origin_region 	起点所在城市或县 	同上
                 destination_region 	终点所在城市或县 	同上
                 coord_type 	坐标类型，可选参数，默认为bd09ll。 	可选 	允许的值为bd09ll、bd09mc、gcj02、wgs84。bd09ll表示百度经纬度坐标，bd09mc表示百度墨卡托坐标，gcj02表示经过国测局加密的坐标，wgs84表示gps获取的坐标。
                 zoom 	展现地图的级别，默认为视觉最优级别。 	可选 	
                 src 	调用来源，规则：webapp.navi.yourCompanyName.yourAppName 	必选
                 */
                NSString *str = [NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京111&mode=driving&coord_type=bd09ll",coor.latitude, coor.longitude];
                NSString *urlString =[self changeCodeToUtf8:str];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }else{
                NSLog(@"没有安装百度地图");
            }
            
        }
            break;
        case 4:
        {//高德
            
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
                NSLog(@"安装了高德地图");
                
                CLLocationCoordinate2D coor1 = coor;//原始坐标
                coor1.latitude =31.195030;
                coor1.longitude = 121.292670;
                
                /*
                 navib服务类型
                 sourceApplication第三方调用应用名称。如applicationName
                 backScheme 第三方调回使用的scheme,如applicationScheme (第三方iOS客户端需要注册该scheme)
                 poiname POI名称
                 poiid 对应sourceApplication 的POI ID
                 lat纬度
                 lon经度
                 dev是否偏移(0:lat和lon是已经加密后的,不需要国测加密;1:需要国测加密)
                 style导航方式：(0：速度最快，1：费用最少，2：距离最短，3：不走高速，4：躲避拥堵，5：不走高速且避免收费，6：不走高速且躲避拥堵，7：躲避收费和拥堵，8：不走高速躲避收费和拥堵)
                 */
                
                
                NSString *str = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"滴滴地图",@"91ailishi",coor1.latitude, coor1.longitude];
                NSString *urlString = [self changeCodeToUtf8:str];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
                
            }else{
                NSLog(@"没有安装高德地图");
            }
        }
            break;
        case 5:
        {//谷歌
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
                NSLog(@"安装了谷歌地图");
                NSString *str = [NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"滴滴地图",@"91ailishi",coor.latitude, coor.longitude];
                NSString *urlString = [self changeCodeToUtf8:str];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }else{
                NSLog(@"没有安装谷歌地图");
            }
        }
            break;
        case 6:
        {//自带
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];//自己位置
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor addressDictionary:nil]];//终点位置
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
            break;
            
        default:
            break;
    }
}

- (void)createMapView {
    CLLocationCoordinate2D coor;
    coor.latitude = 31.233125;
    coor.longitude = 121.48586;
    /*
     加载地图地图
     */
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    [self.view addSubview:mapView];
    
    //    mapView.mapType = BMKMapTypeStandard;//设置地图类型
    // 此处记得不用的时候需要置nil，否则影响内存的释放
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    
    annotation.coordinate = coor;
    //    annotation.title = @"这里是北京";
    [mapView addAnnotation:annotation];
    
    //设置手势
    mapView.gesturesEnabled = NO;
    //设置比例尺等级
    mapView.zoomLevel = 18;
    //设置中心点位置
    [mapView setCenterCoordinate:coor animated:YES];
    
}
- (void)createStaticMapView {
    CLLocationCoordinate2D coor;
    coor.latitude = 31.233125;
    coor.longitude = 121.48586;
    /*
     加载静态地图
     
     @ ak 百度地图的key    U4AnQU8D0FmRMz1Ys6ITs3s7V8EYHxbP
     @ mcode 安全码   binglei.fangXianSen
     @ zoom  地图等级  3--21
     @ dpiType=ph  设置生成高清图
     @ scale=2 返回的图片分辨率为 width*scale   hight*scale
     @ width=400&height=200  图片的宽高
     @ center=121.48586,31.233125  中心点坐标
     @ markers=中心 &markerStyles=s,A,0xff0000"  大头针的坐标和样式
     */
    
    
    UIImageView * mapView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    mapView1.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:mapView1];
    
    NSString *str = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage/v2?ak=U4AnQU8D0FmRMz1Ys6ITs3s7V8EYHxbP&mcode=binglei.fangXianSen&zoom=17&dpiType=ph&scale=2&width=%f&height=%f&center=%f,%f&markers=%f,%f&markerStyles=l,,0xff0000",mapView1.frame.size.width,mapView1.frame.size.height,coor.longitude,coor.latitude,coor.longitude,coor.latitude] ;
    NSLog(@"%@",str);
    
    [mapView1 sd_setImageWithURL:[NSURL URLWithString:str]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
