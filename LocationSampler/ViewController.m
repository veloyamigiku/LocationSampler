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

@interface ViewController () <LocationSamplerDelegate>

@property LocationSampler *locationSampler;

- (IBAction)switchStartStop:(id)sender;

- (IBAction)switchStandardLocationSampling:(id)sender;

- (IBAction)switchSignificantLocationSampling:(id)sender;

@end

@implementation ViewController

@synthesize locationSampler;

- (void)viewDidLoad {
    // ロケーションサンプラを初期化します。
    locationSampler = [[LocationSampler alloc] init];
    locationSampler.delegate = self;
    NSString *uuid = @"AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA";
    [locationSampler addBeaconRegionWithUUID:uuid];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)switchStartStop:(id)sender {
    UISwitch *startStopSwitch = (UISwitch *)sender;
    
    if (startStopSwitch.on) {
        // ビーコンサンプリングを開始します。
        if ([locationSampler startIbeaconSamplingWithRangingOn:YES]) {
            startStopSwitch.on = NO;
        }
    } else {
        // ビーコンサンプリングを終了します。
        [locationSampler stopIbeaconSampling];
    }
    
}

- (IBAction)switchStandardLocationSampling:(id)sender {
    UISwitch *startStopSwitch = (UISwitch *)sender;
    
    if (startStopSwitch.on) {
        // 標準位置情報サンプリングを開始します。
        if ([locationSampler startStandardLocationSampling]) {
            startStopSwitch.on = NO;
        }
    } else {
        // 標準位置情報サンプリングを終了します。
        [locationSampler stopStandardLocationSampling];
    }
}

- (IBAction)switchSignificantLocationSampling:(id)sender
{
    UISwitch *startStopSwitch = (UISwitch *)sender;
    
    if (startStopSwitch.on) {
        // 大幅位置情報サンプリングを開始します。
        if ([locationSampler startSignificantLocationSampling]) {
            startStopSwitch.on = NO;
        }
    } else {
        // 大幅位置情報サンプリングを終了します。
        [locationSampler stopSignificantLocationSampling];
    }
}

- (void)enterBeaconRegion:(CLBeaconRegion *)region
{
    NSLog(@"enter:%@", region.proximityUUID.UUIDString);
}

- (void)recvBeacon:(NSArray<CLBeacon *> *)beacons region:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        NSLog(@"%@,%@,%@",
              beacon.proximityUUID,
              beacon.major,
              beacon.minor);
    }
}

- (void)exitBeaconRegion:(CLBeaconRegion *)region
{
    NSLog(@"exit:%@", region.proximityUUID.UUIDString);
}

- (void)bluetoothStatePowerOn
{
    NSLog(@"%@", @"bluetoothOn");
}

- (void)bluetoothStatePowerOff
{
    NSLog(@"%@", @"bluetoothOff");
}

- (void)locationAuthorizationStatusAuthorized
{
    NSLog(@"%@", @"locationAuthorizationStatusAuthorized");
}

- (void)locationAuthorizationStatusDenied
{
    NSLog(@"%@", @"locationAuthorizationStatusDenied");
}

- (void)didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%f,%f", locations[0].coordinate.latitude, locations[0].coordinate.longitude);
}

- (void)didFailWithError:(NSError *)error
{
    NSLog(@"[Standard Location Sampling Error] %@", error.description);
}

@end
