//
//  NavigationVC.m
//  fangXianSen
//
//  Created by 冰泪 on 2017/4/7.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "NavigationVC.h"


@interface NavigationVC ()
{
    UIWebView *webView;
}
@end

@implementation NavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.map.baidu.com/direction/v2/transit?origin=40.056878,116.30815&destination=31.222965,121.505821&ak=U4AnQU8D0FmRMz1Ys6ITs3s7V8EYHxbP"]]];
    [self.view addSubview:webView];
//    NSString *htmlStr = @"<heade>"
//    [webView loadHTMLString:@"www.baidu.com" baseURL:nil];
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
