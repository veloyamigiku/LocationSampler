//
//  ViewController.m
//  LocationSampler
//
//  Created on 2015/10/31.
//
//
#import "ViewController.h"
#import "LocationSampler.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property LocationSampler *locationSampler;

- (IBAction)switchStartStop:(id)sender;

@end

@implementation ViewController

@synthesize locationSampler;

- (void)viewDidLoad {
    // ロケーションサンプラを初期化します。
    locationSampler = [[LocationSampler alloc] init];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)switchStartStop:(id)sender {
    UISwitch *startStopSwitch = (UISwitch *)sender;
    
    if (startStopSwitch.on) {
        // ビーコンサンプリングを開始します。
        [locationSampler startIbeaconSampling];
    } else {
        // ビーコンサンプリングを終了します。
        [locationSampler stopIbeaconSampling];
    }
    
}

@end
