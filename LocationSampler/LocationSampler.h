//
//  LocationSampler.h
//  BleSample
//
//  Created on 2015/10/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    kLocationSamplerErrorNotError = 0,
    kLocationSamplerErrorDoubleStart,
    kLocationSamplerErrorDoubleStop,
    kLocationSamplerErrorLocationServiceDisabled,
    kLocationSamplerErrorAuthorizationStatusDenied,
    kLocationSamplerErrorBeaconSamplingNotSupport,
    kLocationSamplerErrorBeaconSamplingNgOperation
} LocationSamplerError;

@protocol LocationSamplerDelegate <NSObject>

/**
 *  ブルートゥースの状態がoffに変わった時の処理です。
 */
- (void)bluetoothStatePowerOff;

/**
 *  ブルートゥースの状態がonに変わった時の処理です。
 */
- (void)bluetoothStatePowerOn;

/**
 *  位置情報取得が許可された時の処理です。
 */
- (void)locationAuthorizationStatusAuthorized;

/**
 *  位置情報取得が拒否された時の処理です。
 */
- (void)locationAuthorizationStatusDenied;

/**
 *  ビーコンリージョンに入った時の処理です。
 *
 *  @param manager 位置情報マネージャです。
 *  @param state   状態です。
 *  @param region  リージョンです。
 */
- (void)enterBeaconRegion:(CLBeaconRegion *)region;

/**
 *  ビーコン受信時の処理です
 *
 *  @param manager  位置情報マネージャです。
 *  @param beacons  受信したビーコンです。
 *  @param inRegion リージョンです。
 */
- (void)recvBeacon:(NSArray<CLBeacon *> *)beacons region:(CLBeaconRegion *)region;

/**
 *  ビーコンリージョンから出た時の処理です。
 *
 *  @param manager 位置情報マネージャです。
 *  @param state   状態です。
 *  @param region  リージョンです。
 */
- (void)exitBeaconRegion:(CLBeaconRegion *)region;

@end

@interface LocationSampler : NSObject

@property id<LocationSamplerDelegate> delegate;

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *
 *  @return 処理結果。
 */
- (LocationSamplerError)addBeaconRegionWithUUID:(NSString *)uuid;

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *  @param major majorです。
 *
 *  @return 処理結果。
 */
- (LocationSamplerError)addBeaconRegionWithUUID:(NSString *)uuid withMajor:(int)major;

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *  @param major majorです。
 *  @param minor minorです。
 *
 *  @return 処理結果。
 */
- (LocationSamplerError)addBeaconRegionWithUUID:(NSString *)uuid withMajor:(int)major withMinor:(int)minor;

/**
 *  ibeaconのサンプリングを開始します。
 *
 *  @param rangingOn レンジング処理実施フラグです。
 *
 *  @return サンプリング開始の結果(YES:成功,NO:失敗)
 */
- (LocationSamplerError)startIbeaconSamplingWithRangingOn:(BOOL)rangingOn;

/**
 *  ibeaconのサンプリングを終了します。
 *
 *  @return サンプリング終了の結果(YES:成功,NO:失敗)
 */
- (LocationSamplerError)stopIbeaconSampling;

@end
