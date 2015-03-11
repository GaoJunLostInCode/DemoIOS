//
//  GJExpendTableViewCell.h
//  Demo
//
//  Created by 高 军 on 15/2/18.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJCellInfo;

@interface GJExpendTableViewCell : UITableViewCell

@property (nonatomic) GJCellInfo* cellInfo;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;


- (void)showCellInfo:(GJCellInfo*)cellInfo;

@end
