//
//  GJiBeanconTestViewController.m
//  Demo
//
//  Created by 高 军 on 15/3/27.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJiBeanconTestViewController.h"
#import "GJiBeaconManager.h"
#import "GJBeaconBroadcaster.h"
#import "GJBeaconDetector.h"

@interface GJiBeanconTestViewController ()<CLLocationManagerDelegate, CBPeripheralManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labeliBeacon;
@property (strong, nonatomic) IBOutlet UILabel *labelLocation;
@property (nonatomic) GJBeaconBroadcaster *beaconBroadcaster;
@property (nonatomic) GJBeaconDetector *beaconDetector;

@end

@implementation GJiBeanconTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.beaconBroadcaster = [[GJBeaconBroadcaster alloc] init];
    self.beaconDetector = [[GJBeaconDetector alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onButtonStartiBeanClicked:(id)sender
{
    [self.beaconBroadcaster startAdvertiseBeacon];
}

- (IBAction)onButtonDetectiBeanconClicked:(id)sender
{
    [self.beaconDetector detectBeaconWithLocationManagerDelegate:self];
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0)
{
    NSString *strLocation = [NSString stringWithFormat:@"updateLocation:%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    [self.labelLocation setText:strLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_2)
{
    if(status == kCLAuthorizationStatusAuthorized || status==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
//        [self.locationManager startUpdatingLocation];
    }
    else if(status == kCLAuthorizationStatusDenied)
    {
//        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion*)region;

    NSString *string = [NSString stringWithFormat:@"enter region: %@, major:%@, minor:%@, meter:%@", beaconRegion.proximityUUID.UUIDString, beaconRegion.major, beaconRegion.minor, beaconRegion];
    [self.labeliBeacon setText:string];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion*)region;
    NSString *string = [NSString stringWithFormat:@"exist region: %@, major:%@, minor:%@", beaconRegion.proximityUUID.UUIDString, beaconRegion.major, beaconRegion.minor];
    [self.labeliBeacon setText:string];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] > 0)
    {
        CLBeacon *nearestExhibit = [beacons firstObject];
        
        // Present the exhibit-specific UI only when
        // the user is relatively close to the exhibit.
        if (CLProximityNear == nearestExhibit.proximity)
        {
            NSString *strLog = [NSString stringWithFormat:@"accuracy :%f", nearestExhibit.accuracy];
            [self.labeliBeacon setText:strLog];
        } else
        {
            
        }
    }
}

@end
