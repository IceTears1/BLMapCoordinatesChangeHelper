//
//  MapVC.m
//  fangXianSen
//
//  Created by 冰泪 on 2017/4/5.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "MapVC.h"
#import "NavigationVC.h"

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
@interface MapVC ()
{
    BMKMapView* mapView;
    NSArray *listAry;
    BMKPoiSearch *_searcher;
    BMKNearbySearchOption *option;
    int curPage;
    int totalPage;
    NSMutableArray *dataSource;//搜索到的所有数据
    CLLocationCoordinate2D coor;//初始化位置
}
@end

@implementation MapVC
-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    mapView.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
}
- (void)createBottomView {
    UIScrollView *bottomVIew = [[UIScrollView alloc] initWithFrame:CGRectMake(0,DeviceMaxHeight-44 , DeviceMaxWidth, 44)];
    bottomVIew.backgroundColor  = [UIColor blackColor];
    bottomVIew.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bottomVIew];
    CGFloat btnWidth = 50;
    
    listAry = @[@"银行",@"公交",@"地铁",@"教育",@"医院",@"休闲",@"购物",@"健身",@"美食"];
    bottomVIew.contentSize = CGSizeMake(btnWidth*listAry.count, 44);
    for (NSInteger i = 0; i<listAry.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnWidth*i, 0,btnWidth, 44)];
        [btn setTitle:listAry[i] forState:UIControlStateNormal];
        [btn setTitle:listAry[i] forState:UIControlStateSelected];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(listBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bottomVIew addSubview:btn];
    }
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置及周边";
    self.view.backgroundColor = [UIColor whiteColor];
    coor.latitude = 31.233125;
    coor.longitude = 121.48586;
      [self createMapView];
    [self createBottomView];
   UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceMaxWidth-40, 27, 30, 30)];
    rightBtn.layer.cornerRadius = 15;
    rightBtn.backgroundColor = [UIColor blackColor];
//    [rightBtn setImage:[UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)rightBtnEvent{
    NavigationVC *navVC = [[NavigationVC alloc]init];
    [self.navigationController pushViewController:navVC animated:YES];
}
- (void)listBtnEvent:(UIButton *)btn {
    NSInteger i = btn.tag -100;
    NSString *typeName = listAry[i];
    NSLog(@"%@",typeName);
    curPage = 0;
    totalPage = 1;
    if (!option) {
        //发起检索
         option = [[BMKNearbySearchOption alloc]init];
    }
    if (!dataSource) {
        dataSource = [[NSMutableArray alloc]init];
    }
    
    
    option.keyword = typeName;
    
    [self createPOISearch];
}
#pragma mark 创建poi检索
- (void)createPOISearch {
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    
    option.pageCapacity = 10;
    //中心点坐标
    option.location = coor;
    //当前页
    option.pageIndex = curPage;
    //搜索关键词
//    option.keyword = @"银行";
    //搜索半径 单位 （米）
    option.radius = 1000;
    //排列顺序
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    
    BOOL flag = [_searcher poiSearchNearBy:option];

    if(flag)
    {
        NSLog(@"周边检索发送成功");
        
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
#pragma mark  实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
//        NSLog(@"结果总数：%d",poiResultList.totalPoiNum);
//         NSLog(@"当前页总条数%d",poiResultList.currPoiNum);
//         NSLog(@"搜索的总页数%d",poiResultList.pageNum);
//         NSLog(@"当前页的索引%d",poiResultList.pageIndex);

        totalPage = poiResultList.pageNum;
        if (curPage == 0) {
            //移除 除了标记点之外的所有 大头针
            NSMutableArray *ary = [[NSMutableArray alloc]initWithArray:mapView.annotations];
            [ary removeObjectAtIndex:0];
            [mapView removeAnnotations:ary];

        }
        for (NSInteger i = 0;i<poiResultList.poiInfoList.count; i++) {
          //检索到的点展示在地图上
            BMKPoiInfo *point = poiResultList.poiInfoList[i];
            //初始化一个点的注释 //只有三个属性
            BMKPointAnnotation *annotoation = [[BMKPointAnnotation alloc] init];
            //坐标
            annotoation.coordinate = point.pt;
            //title
            annotoation.title = point.name;
            //子标题
            annotoation.subtitle = point.address;
            //将标注添加到地图上
            [mapView addAnnotation:annotoation];
        }
    
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}//大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    //如果是注释点
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        //根据注释点,创建并初始化注释点视图
        BMKPinAnnotationView  *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"an"];
        //设置大头针的颜色
        newAnnotation.pinColor = BMKPinAnnotationColorPurple;
        //设置动画
        newAnnotation.animatesDrop = NO;
        
        
        newAnnotation.image = [UIImage imageNamed:@"交通"];   //把大头针换成别的图片
    
        return newAnnotation;
        
    }
    
    return nil;
}
#pragma mark  创建基础地图
- (void)createMapView {
    mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:mapView];
    //    mapView.mapType = BMKMapTypeStandard;//设置地图类型
    // 此处记得不用的时候需要置nil，否则影响内存的释放
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coor;
    [mapView addAnnotation:annotation];
    
    //设置手势
    mapView.gesturesEnabled = YES;
    //设置比例尺等级
    mapView.zoomLevel = 19;
    //设置中心点位置
    [mapView setCenterCoordinate:coor animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
