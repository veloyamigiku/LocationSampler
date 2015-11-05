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

@end

@interface LocationSampler : NSObject

@property id<LocationSamplerDelegate> delegate;

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
