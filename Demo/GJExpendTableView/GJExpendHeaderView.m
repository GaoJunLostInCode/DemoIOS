//
//  GJExpendHeaderView.m
//  Demo
//
//  Created by 高 军 on 15/2/17.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJExpendHeaderView.h"
#import "GJSectionInfo.h"

@interface GJExpendHeaderView()


@end



@implementation GJExpendHeaderView

- (IBAction)onExpendClicked:(id)sender
{
    self.sectionInfo.open = !self.sectionInfo.open;
    self.btnExpend.selected = self.sectionInfo.isOpen;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(expendHeaderClicked:sectionInfo:isOpen:)])
    {
        [self.delegate expendHeaderClicked:self sectionInfo:self.sectionInfo isOpen:self.sectionInfo.isOpen];
    }
}

- (void)showSectionInfo:(GJSectionInfo*)sectionInfo
{
    self.sectionInfo = sectionInfo;
    self.btnExpend.selected = sectionInfo.isOpen;
    
    [self.labelName setText:sectionInfo.sectionName];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
