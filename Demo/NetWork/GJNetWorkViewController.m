//
//  GJNetWorkViewController.m
//  Demo
//
//  Created by 高 军 on 15/3/7.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJNetWorkViewController.h"
#import "GJHttpClient.h"
#import "GJParamTest.h"


@interface GJNetWorkViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgvDown;

- (IBAction)onDownloadClicked:(id)sender;
- (IBAction)onUploadClicked:(id)sender;
- (IBAction)onTestJsonClicked:(id)sender;

@end

@implementation GJNetWorkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
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
- (NSString*)getFileDownloadedPath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"abcd.png"];
    
    return filePath;
}

- (IBAction)onDownloadClicked:(id)sender
{
    GJHttpClient *client = [[GJHttpClient alloc] init];
    [client download:@"" completedHandler:
        ^(NSURLResponse *response, NSData *data, NSError *error)
        {
            UIImage *image = [[UIImage alloc] initWithData:data];
            [_imgvDown setImage:image];
        }];
}

- (IBAction)onUploadClicked:(id)sender
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFileDownloadedPath]];
    GJHttpClient *client = [[GJHttpClient alloc] init];
    
    [client upload:@"" postParams:nil data:data fileName:@"abcd.png" completedHandler:
        ^(NSURLResponse *response, NSData *data, NSError *error)
        {
            NSLog(@"upload response:%@ error:%@", response, error);
        }];
}

- (IBAction)onTestJsonClicked:(id)sender
{
    GJParamTest *param = [[GJParamTest alloc] init];
    GJHttpClient *client = [[GJHttpClient alloc] init];
    [client post:[param toDictionary] toUrl:nil completedHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error){
         NSLog(@" post response:%@", response);
     }];
}


@end
