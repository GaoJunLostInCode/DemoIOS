//
//  GJCoreDataTabViewController.m
//  Demo
//
//  Created by 高 军 on 15/4/15.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJCoreDataTabViewController.h"
#import "GJBookTableViewController.h"
#import "GJAuthorTableViewController.h"

@interface GJCoreDataTabViewController ()

@end

@implementation GJCoreDataTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GJBookTableViewController *bookController = [[GJBookTableViewController alloc] initWithNibName:@"GJBookTableViewController" bundle:nil];
    GJAuthorTableViewController *authorController = [[GJAuthorTableViewController alloc] initWithNibName:@"GJAuthorTableViewController" bundle:nil];
    
    [self setViewControllers:@[bookController, authorController]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
