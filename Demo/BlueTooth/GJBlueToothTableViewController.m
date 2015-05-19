//
//  GJBlueToothTableViewController.m
//  Demo
//
//  Created by 高 军 on 15/3/31.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBlueToothTableViewController.h"
#import "GJBlueClientViewController.h"
#import "GJBlueToothCopyViewController.h"

@interface GJBlueToothTableViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic) NSMutableArray *mArrPeripherals;
@property (nonatomic) CBCentralManager *mCentralManager;
@property (nonatomic) CBPeripheral *mPeripheralConnected;
@end

@implementation GJBlueToothTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.mArrPeripherals = [[NSMutableArray alloc] init];
    self.mCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.mCentralManager.state == CBCentralManagerStatePoweredOn)
    {
        [self.mArrPeripherals removeAllObjects];
        [self.mCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.mCentralManager.state == CBCentralManagerStatePoweredOn)
    {
        [self.mCentralManager stopScan];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mArrPeripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *peripheral = self.mArrPeripherals[indexPath.row];
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@:%@", peripheral.name, peripheral.identifier.UUIDString]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    GJBlueToothDetailViewController *detailViewController = [[GJBlueToothDetailViewController alloc] initWithNibName:@"GJBlueToothDetailViewController" bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
    CBPeripheral *peripheral = self.mArrPeripherals[indexPath.row];
    [self.mCentralManager connectPeripheral:peripheral options:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark CBCentralManager Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSMutableString* nsmstring=[NSMutableString stringWithString:@"UpdateState:"];
    BOOL isWork=FALSE;
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            [nsmstring appendString:@"Unknown\n"];
            break;
        case CBCentralManagerStateUnsupported:
            [nsmstring appendString:@"Unsupported\n"];
            break;
        case CBCentralManagerStateUnauthorized:
            [nsmstring appendString:@"Unauthorized\n"];
            break;
        case CBCentralManagerStateResetting:
            [nsmstring appendString:@"Resetting\n"];
            break;
        case CBCentralManagerStatePoweredOff:
            [nsmstring appendString:@"PoweredOff\n"];

            if (self.mPeripheralConnected != nil)
            {
                [central cancelPeripheralConnection:self.mPeripheralConnected];
            }
            break;
        case CBCentralManagerStatePoweredOn:
            [nsmstring appendString:@"PoweredOn\n"];
            isWork=TRUE;
            break;
        default:
            [nsmstring appendString:@"none\n"];
            break;
    }
    NSLog(@"%@",nsmstring);

}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    [self.mArrPeripherals addObject:peripheral];
    [self.tableView reloadData];
    NSLog(@"Discovered %@", peripheral.name);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.mPeripheralConnected = peripheral;
    
    GJBlueClientViewController *detailViewController = [[GJBlueClientViewController alloc] initWithNibName:@"GJBlueClientViewController" bundle:nil];
//    GJBlueToothCopyViewController *detailViewController = [[GJBlueToothCopyViewController alloc] initWithNibName:@"GJBlueToothCopyViewController" bundle:nil];
    
    detailViewController.mPeripheral = peripheral;

    [self.navigationController pushViewController:detailViewController animated:YES];
}



@end





