//
//  LocationSampler.m
//  BleSample
//
//  Created on 2015/10/27.
//
//

#import "LocationSampler.h"
#import "DeviceUtils.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface LocationSampler () <CLLocationManagerDelegate, CBCentralManagerDelegate>

@property CLLocationManager *manager;

@property CBCentralManager *bluetoothManager;

@property NSMutableArray *regionAry;

@property BOOL ibeaconSamplingOn;

@property BOOL beaconRangingOn;

@end

@implementation LocationSampler

@synthesize delegate;

@synthesize manager;

@synthesize bluetoothManager;

@synthesize regionAry;

@synthesize ibeaconSamplingOn;

@synthesize beaconRangingOn;

/**
 *  本オブジェクトを初期化します。
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        ibeaconSamplingOn = NO;
        
        beaconRangingOn = NO;
        
        // 位置情報取得マネージャを初期化します。
        manager = [[CLLocationManager alloc] init];
        if ([DeviceUtils getIosVersion] >= 8.0) {
            [manager requestAlwaysAuthorization];
        }
        manager.delegate = self;
        
        // 監視するビーコンリージョンを初期化します。
        regionAry = [NSMutableArray array];
        
        // ブルートゥースマネージャを初期化します。
        bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *
 *  @return 処理結果。
 */
- (BOOL)addBeaconRegionWithUUID:(NSString *)uuid
{
    if (![self isAvailableIbeaconSampling]) {
         return NO;
    }
    
    if (ibeaconSamplingOn) {
        return NO;
    }
    
    [regionAry addObject:[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]
                                                                identifier:uuid]];
    return YES;
}

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *  @param major majorです。
 *
 *  @return 処理結果。
 */
- (BOOL)addBeaconRegionWithUUID:(NSString *)uuid withMajor:(int)major
{
    if (![self isAvailableIbeaconSampling]) {
        return NO;
    }
    
    if (ibeaconSamplingOn) {
        return NO;
    }
    
    [regionAry addObject:[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]
                                                                 major:major
                                                            identifier:uuid]];
    return YES;
}

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *  @param major majorです。
 *  @param minor minorです。
 *
 *  @return 処理結果。
 */
- (BOOL)addBeaconRegionWithUUID:(NSString *)uuid withMajor:(int)major withMinor:(int)minor
{
    if (![self isAvailableIbeaconSampling]) {
        return NO;
    }
    
    if (ibeaconSamplingOn) {
        return NO;
    }
    
    [regionAry addObject:[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]
                                                                 major:major
                                                                 minor:minor
                                                            identifier:uuid]];
    return YES;
}

/**
 *  ibeaconのサンプリングを開始します。
 *
 *  @param rangingOn レンジング処理実施フラグです。
 *
 *  @return サンプリング開始の結果(YES:成功,NO:失敗)
 */
- (BOOL)startIbeaconSamplingWithRangingOn:(BOOL)rangingOn
{
    // サンプリング状態を確認します。
    if (ibeaconSamplingOn) {
        NSLog(@"%@", @"Double Start is NG.");
        return NO;
    }
    
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
    
    // Ibeaconのサンプリングが可能か確認します。
    if (![self isAvailableIbeaconSampling]) {
        NSLog(@"%@", @"Device is not support of bluetooth beacon.");
        return NO;
    }
    
    beaconRangingOn = rangingOn;
    for (int i = 0; i < regionAry.count; i++) {
        [manager startMonitoringForRegion:regionAry[i]];
    }
    
    ibeaconSamplingOn = YES;
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
    
    // サンプリング状態を確認します。
    if (!ibeaconSamplingOn) {
        NSLog(@"%@", @"Double Stop is NG.");
        return NO;
    }
    
    for (int i = 0; i < regionAry.count; i++) {
        if (beaconRangingOn) {
            [manager stopRangingBeaconsInRegion:regionAry[i]];
        }
        [manager stopMonitoringForRegion:regionAry[i]];
    }
    ibeaconSamplingOn = NO;
    return result;
}

/**
 *  ビーコンモニタリング開始時の処理です。
 *
 *  @param manager マネージャです。
 *  @param region  リージョンです。
 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    // リージョンステータス確認を要求します。
    [self.manager requestStateForRegion:region];
}

/**
 *  リージョンステータス確認時の処理です。
 *
 *  @param manager マネージャです。
 *  @param state   状態です。
 *  @param region  リージョンです。
 */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
                [delegate enterBeaconRegion:(CLBeaconRegion *)region];
                [self.manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
            }
            break;
        case CLRegionStateOutside:
            break;
        case CLRegionStateUnknown:
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [delegate enterBeaconRegion:(CLBeaconRegion *)region];
    if (beaconRangingOn) {
        [self.manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if (beaconRangingOn) {
        [self.manager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
    [delegate exitBeaconRegion:(CLBeaconRegion *)region];
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
    [delegate recvBeacon:beacons region:region];
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
        case kCLAuthorizationStatusAuthorizedAlways:
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

/**
 *  (試験用)
 */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    switch (error.code) {
        case kCLErrorRegionMonitoringDenied:
            break;
        case kCLErrorRegionMonitoringFailure:
            break;
        case kCLErrorRegionMonitoringResponseDelayed:
            break;
        case kCLErrorRegionMonitoringSetupDelayed:
            break;
        default:
            break;
    }
    NSLog(@"error.code=%ld", (long)error.code);
}

/**
 *  ビーコンサンプリングが可能な端末か確認します。
 *
 *  @return YES：可能、NO：不可。
 */
- (BOOL)isAvailableIbeaconSampling
{
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]] &&
        [CLLocationManager isRangingAvailable]) {
        return YES;
    } else {
        return NO;
    }
}

@end
