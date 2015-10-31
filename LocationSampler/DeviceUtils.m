//
//  DeviceUtils.m
//  BleSample
//
//  Created on 2015/10/27.
//
//

#import "DeviceUtils.h"
#import <UIKit/UIKit.h>

@implementation DeviceUtils

+ (float)getIosVersion
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

@end
