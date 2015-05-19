//
//  GJBlueToothAdvertiserViewController.m
//  Demo
//
//  Created by 高 军 on 15/4/1.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBlueServerViewController.h"
#import "GJBlueToothCopyViewController.h"
#import "GJBlueToothCopier.h"
#import "GJImageUtils.h"
#import "NSArray_Ext.h"

@interface GJBlueServerViewController ()<CBPeripheralManagerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;
@property (strong, nonatomic) IBOutlet UITextField *mTextField;
@property (nonatomic) CBPeripheralManager * mPeripheralManager;
@property (nonatomic) CBMutableCharacteristic *mCharacteristic;
@property (nonatomic) CBMutableService *mService;
@property (nonatomic) UIImagePickerController *mImagePicker;
@property (nonatomic) NSMutableSet *mCentrals;
@end

@implementation GJBlueServerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        self.mImagePicker = [[UIImagePickerController alloc] init];
        self.mImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.mImagePicker.delegate = self;
    });
    
    [self.mTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.mCentrals = [NSMutableSet set];
    
//    [self setUpService];
}

- (void)setUpService
{
    self.labelStatus.text = @"starting...";
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:(NSString*)UUID_SERVICE];
    self.mService = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    
    CBUUID *characterUUID = [CBUUID UUIDWithString:(NSString*)UUID_CHARACTER];
    self.mCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characterUUID properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    self.mService.characteristics = @[self.mCharacteristic];
    
    [self.mPeripheralManager addService:self.mService];
    if([self.mPeripheralManager isAdvertising])
    {
        [self.mPeripheralManager stopAdvertising];
    }
    [self.mPeripheralManager startAdvertising:
               @{CBAdvertisementDataLocalNameKey : @"BlueToothTest",
              CBAdvertisementDataServiceUUIDsKey : @[self.mService.UUID] }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CBPeripheralManager Delegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        [self setUpService];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSString *strInfo = @"add service success";
    if (error == nil)
    {
//        [self.mPeripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[service.UUID] }];
    }else
    {
        strInfo = [NSString stringWithFormat:@"add service failed : %@", error];
    }
    
    NSLog(@"%@:%@", strInfo, service.UUID);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }else
    {
        [self.labelStatus setText:@"success"];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"didReceiveReadRequest ....%@", request);
    CBATTError resultStatus = CBATTErrorAttributeNotFound;
//    if ([request.characteristic.UUID isEqual:self.mCharacteristic.UUID])
//    {
//        if (request.offset > self.mCharacteristic.value.length)
//        {
//            resultStatus = CBATTErrorInvalidOffset;
//        }else
//        {
//            resultStatus = CBATTErrorSuccess;
//            request.value = [self.mCharacteristic.value subdataWithRange:NSMakeRange(request.offset, self.mCharacteristic.value.length - request.offset)];
//        }
//    }
    
//    CBCharacteristic *characteristic = [GJBlueToothCopier readFromLocalFile:request.characteristic.UUID];
//    if (request.offset > characteristic.value.length)
//    {
//        resultStatus = CBATTErrorInvalidOffset;
//    }else
//    {
//        resultStatus = CBATTErrorSuccess;
//        request.value = [characteristic.value subdataWithRange:NSMakeRange(request.offset, characteristic.value.length - request.offset)];
//    }
    
    if ([request.characteristic.UUID isEqual:[CBUUID UUIDWithString:(NSString*)UUID_CHARACTER]])
    {
        [request setValue:[self.mTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSLog(@"didReceiveReadRequest ....%@", request);
    
    [self.mPeripheralManager respondToRequest:request withResult:resultStatus];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    for (CBATTRequest *request in requests)
    {
        NSLog(@"request : %@", request);
    }
    
    self.mCharacteristic.value = ((CBATTRequest*)requests[0]).value;
    [self.mPeripheralManager respondToRequest:[requests objectAtIndex:0] withResult:CBATTErrorSuccess];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:(NSString*)UUID_CHARACTER]])
    {
        [self.mCentrals addObject:central];
    }
}

- (IBAction)onButtonSendClicked:(id)sender
{
    [self.mPeripheralManager updateValue:[self.mTextField.text dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.mCharacteristic onSubscribedCentrals:[NSArray arrayWithSet:self.mCentrals]];
}

#pragma mark UIImagePickerViewController delegate
/**
 *
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
    
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidChanged:(UITextField*)textField
{
//    [self.mPeripheralManager updateValue:[textField.text dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.mCharacteristic onSubscribedCentrals:[self.mCentrals toArray]];
}


@end








