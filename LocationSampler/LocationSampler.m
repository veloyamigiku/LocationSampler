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
#import <CoreBluetooth/CoreBluetooth.h>

@interface LocationSampler () <CLLocationManagerDelegate, CBCentralManagerDelegate>

@property CLLocationManager *manager;

@property CBCentralManager *bluetoothManager;

@property CLBeaconRegion *region;

@end

@implementation LocationSampler

@synthesize delegate;

@synthesize manager;

@synthesize bluetoothManager;

@synthesize region;

/**
 *  本オブジェクトを初期化します。
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 位置情報取得マネージャを初期化します。
        manager = [[CLLocationManager alloc] init];
        if ([DeviceUtils getIosVersion] >= 8.0) {
            [manager requestAlwaysAuthorization];
        }
        manager.delegate = self;
        
        // あとで修正する対象です。
        NSString *uuid = @"AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA";
        region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]
                                                    identifier:uuid];
        
        // ブルートゥースマネージャを初期化します。
        bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
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

/**
 *  ブルートゥースの状態が変化した時のイベント処理です。
 *
 *  @param central セントラルです。
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (bluetoothManager.state) {
        case CBCentralManagerStatePoweredOff:
            [delegate bluetoothStatePowerOff];
            break;
        case CBCentralManagerStatePoweredOn:
            [delegate bluetoothStatePowerOn];
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            [delegate locationAuthorizationStatusAuthorized];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
        case kCLAuthorizationStatusDenied:
            [delegate locationAuthorizationStatusDenied];
            break;
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

@end
