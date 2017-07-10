//
//  JCLocation.m
//  AbellStar_Light
//
//  Created by apple on 2017/7/7.
//  Copyright © 2017年 xjc. All rights reserved.
//

#import "JCLocation.h"

@interface JCLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;

@property (nonatomic, strong) CLGeocoder *coder;

@property (nonatomic, strong) CLLocation *previousLocation;

@end

@implementation JCLocation

+(instancetype)shareInstance
{
    static id locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!locationManager) {
            locationManager = [[JCLocation alloc] init];
        }
    });
    return locationManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initManager];
    }
    return self;
}

-(void) initManager
{
    _locManager = [[CLLocationManager alloc] init];
    _coder      = [[CLGeocoder alloc] init];
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locManager requestWhenInUseAuthorization];
    }
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locManager.distanceFilter = 1.0;
    _locManager.pausesLocationUpdatesAutomatically = NO; // 设置是否允许系统自动暂停定位---6/23 def
   // [_locManager startUpdatingHeading];
}

+(void)getUserLocationMsg:(void (^)(NSString *, NSString *, NSString *))block
{
    [[JCLocation shareInstance] getUserLocationMsg:block];
}

-(void)getUserLocationMsg:(void (^)(NSString *ll, NSString *address, NSString *distance))msg
{
    if ([CLLocationManager locationServicesEnabled] == FALSE) {
        NSLog(@"123");
        return;
    }
    SaveUserLocMsg = [msg copy];
    [self.locManager stopUpdatingLocation];
    [self.locManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"456...");
    if (locations.count > 0) {
        CLLocation *loc = [locations lastObject];
        CLLocationCoordinate2D coord = loc.coordinate;
        [self reverseGeocodeLocationWith:coord cllocation:loc];
        self.previousLocation = loc;
    }
}

-(void)reverseGeocodeLocationWith:(CLLocationCoordinate2D)coord cllocation:(CLLocation *)loc
{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
    NSString *coordll = [NSString stringWithFormat:@"%f,%f",coord.longitude,coord.latitude];
    [_coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *pmark = [placemarks firstObject];
        if (self.previousLocation != nil) {
            CLLocationDistance distance = [loc distanceFromLocation:self.previousLocation];
            NSString  *addressMsg = pmark.thoroughfare;
            NSString *connectDistance = [NSString stringWithFormat:@"%.f",distance];
            if (SaveUserLocMsg) {
                SaveUserLocMsg(coordll,addressMsg,connectDistance);
            }
            NSLog(@"_coordll = %@  _addressmsg = %@ _connectdistance = %@",coordll,addressMsg,connectDistance);
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"ccccc error = %@",error);
}

+(void) stopGetUserLoc
{
    [[JCLocation shareInstance] stopLocation];
}

-(void) stopLocation
{
    [self.locManager stopUpdatingHeading];
}

@end
