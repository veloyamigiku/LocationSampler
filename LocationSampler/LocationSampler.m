//
//  LocationSampler.m
//  BleSample
//
//  Created on 2015/10/27.
//
//

#import "LocationSampler.h"
#import "DeviceUtils.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationSampler () <CLLocationManagerDelegate>

@property CLLocationManager *manager;

@property CLBeaconRegion *region;

@end

@implementation LocationSampler

@synthesize manager;

@synthesize region;

/**
 *  本オブジェクトを初期化します。
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        manager = [[CLLocationManager alloc] init];
        if ([DeviceUtils getIosVersion] >= 8.0) {
            [manager requestAlwaysAuthorization];
        }
        // あとで修正する対象です。
        NSString *uuid = @"AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA";
        region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]
                                                    identifier:uuid];
    }
    return self;
}

/**
 *  ibeaconのサンプリングを開始します。
 *
 *  @return サンプリング開始の結果(YES:成功,NO:失敗)
 */
- (BOOL)startIbeaconSampling
{
    // 位置情報取得(システム設定)が有効か確認します。
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"%@", @"LocationService is disable.");
        return NO;
    }
    
    // 位置情報取得の確認が完了しているかチェックします。
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status <= kCLAuthorizationStatusDenied) {
        NSLog(@"%@", @"CLAuthorizationStatus is negative.");
        return NO;
    }
    
    //
    if (![CLLocationManager isRangingAvailable]) {
        NSLog(@"%@", @"Device is not support of bluetooth beacon.");
        return NO;
    }
    
    manager.delegate = self;
    [manager startRangingBeaconsInRegion:region];
    return YES;
}

/**
 *  ibeaconのサンプリングを終了します。
 *
 *  @return サンプリング終了の結果(YES:成功,NO:失敗)
 */
- (BOOL)stopIbeaconSampling
{
    BOOL result = YES;
    [manager stopRangingBeaconsInRegion:region];
    manager.delegate = nil;
    return result;
}

/**
 *  ビーコン受信時の処理です。
 *
 *  @param manager ロケーションマネージャです。
 *  @param beacons 受信したビーコンです。
 *  @param region  受信したビーコンのリージョンです。
 */
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        NSLog(@"%@,%@,%@",
              beacon.proximityUUID,
              beacon.major,
              beacon.minor);
    }
}

@end
