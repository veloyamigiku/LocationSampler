//
//  LocationSampler.h
//  BleSample
//
//  Created on 2015/10/27.
//
//

#import <Foundation/Foundation.h>

@interface LocationSampler : NSObject

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
