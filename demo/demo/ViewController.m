//
//  ViewController.m
//  调用地图
//
//  Created by haoqianbiao on 2022/2/22.
//

#import "ViewController.h"
#import <MapKit/MKMapItem.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _appName = @"demo";
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(150, 200, 100, 60);
    [button addTarget:self action:@selector(touchTiaoZhuan) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"导航" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
}
- (void)touchTiaoZhuan {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]) {
        UIAlertAction* appleMap = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpAppleMap];
        }];
        [alert addAction:appleMap];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction* gaodeMap = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpGaoDeMap];
        }];
        [alert addAction:gaodeMap];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        UIAlertAction* qqMap = [UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpQQMap];
        }];
        [alert addAction:qqMap];
    }
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)jumpAppleMap {
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
           
           //地理编码器
           CLGeocoder *geocoder = [[CLGeocoder alloc] init];
           //我们假定一个终点坐标，上海嘉定伊宁路2000号报名大厅:121.229296,31.336956
           [geocoder geocodeAddressString:@"上海嘉定伊宁路2000号" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
               CLPlacemark *endPlacemark  = placemarks.lastObject;
               
               //创建一个地图的地标对象
               MKPlacemark *endMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:endPlacemark];
               
               //在地图上标注一个点(终点)
               MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:endMKPlacemark];
               
               //MKLaunchOptionsDirectionsModeKey 指定导航模式
               //NSString * const MKLaunchOptionsDirectionsModeDriving; 驾车
               //NSString * const MKLaunchOptionsDirectionsModeWalking; 步行
               //NSString * const MKLaunchOptionsDirectionsModeTransit; 公交
               [MKMapItem openMapsWithItems:@[currentLocation, endMapItem] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
           }];
}


- (void)jumpGaoDeMap {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"上海嘉定伊宁路2000号" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *placemark in placemarks){
                        //坐标（经纬度)
            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                        
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&dlat=%f&dlon=%f&dname=上海嘉定伊宁路2000号&dev=0&t=0",self->_appName,coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) { NSLog(@"scheme调用结束"); }];
        }
    }];
}

- (void)jumpQQMap {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"上海嘉定伊宁路2000号" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *placemark in placemarks){
            //坐标（经纬度)
            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                        
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&to=上海嘉定伊宁路2000号&tocoord=%f,%f&referer=5PIBZ-6E6WU-UQYVA-2DAQK-VMHGH-V4BFP",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) { NSLog(@"scheme调用结束"); }];
        }
    }];
}
@end

