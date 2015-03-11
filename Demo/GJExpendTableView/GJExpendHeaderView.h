//
//  GJExpendHeaderView.h
//  Demo
//
//  Created by 高 军 on 15/2/17.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJExpendHeaderView;
@class GJSectionInfo;

@protocol GJExpendHeaderViewDelegate <NSObject>

- (void)expendHeaderClicked:(GJExpendHeaderView*)header sectionInfo:(GJSectionInfo*)sectionInfo isOpen:(BOOL)open;

@end

@interface GJExpendHeaderView : UITableViewHeaderFooterView

@property (nonatomic) id<GJExpendHeaderViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnExpend;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (nonatomic) GJSectionInfo *sectionInfo;

- (void)showSectionInfo:(GJSectionInfo*)sectionInfo;

@end
