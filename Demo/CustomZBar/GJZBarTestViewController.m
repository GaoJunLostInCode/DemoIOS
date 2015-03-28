//
//  GJZBarTestViewController.m
//  Demo
//
//  Created by 高 军 on 15/3/18.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJZBarTestViewController.h"
#import "GJCustomZBarViewController.h"

@interface GJZBarTestViewController ()<GJCustomZBarViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelZBarCode;

@end

@implementation GJZBarTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)onScanButtonClicked:(id)sender
{
    GJCustomZBarViewController *controller = [[GJCustomZBarViewController alloc] initWithNibName:@"GJCustomZBarViewController" bundle:nil];
    [controller setCustomZBarViewControllerDelegate:self requestCode:1];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (void)onZBarResultReturned:(NSDictionary *)result requestCode:(NSInteger)requestCode
{
    [_labelZBarCode setText:result[@"code"]];
}

@end
