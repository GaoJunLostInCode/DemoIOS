//
//  GJExpendTableViewCell.m
//  Demo
//
//  Created by 高 军 on 15/2/18.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJExpendTableViewCell.h"
#import "GJCellInfo.h"

@implementation GJExpendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showCellInfo:(GJCellInfo*)cellInfo
{
    self.cellInfo = cellInfo;
    
    [self.labelTitle setText:cellInfo.title];
}

@end
