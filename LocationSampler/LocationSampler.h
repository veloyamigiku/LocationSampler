//
//  LocationSampler.h
//  BleSample
//
//  Created on 2015/10/27.
//
//

#import <Foundation/Foundation.h>

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

@end

@interface LocationSampler : NSObject

@property id<LocationSamplerDelegate> delegate;

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 */
- (void)addBeaconRegionWithUUID:(NSString *)uuid;

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *  @param major majorです。
 */
- (void)addBeaconRegionWithUUID:(NSString *)uuid withMajor:(int)major;

/**
 *  ビーコンリージョンを追加します。
 *
 *  @param uuid  UUIDです。
 *  @param major majorです。
 *  @param minor minorです。
 */
- (void)addBeaconRegionWithUUID:(NSString *)uuid withMajor:(int)major withMinor:(int)minor;

/**
 *  ibeaconのサンプリングを開始します。
 *
 *  @return サンプリング開始の結果(YES:成功,NO:失敗)
 */
- (BOOL)startIbeaconSampling;

/**
 *  ibeaconのサンプリングを終了します。
 *
 *  @return サンプリング終了の結果(YES:成功,NO:失敗)
 */
- (BOOL)stopIbeaconSampling;

@end
