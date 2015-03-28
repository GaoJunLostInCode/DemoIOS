//
//  CustomZBarViewController.h
//  Push
//
//  Created by 高 军 on 15/2/11.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@protocol GJCustomZBarViewControllerDelegate <NSObject>

- (void)onZBarResultReturned:(NSDictionary *)result requestCode:(NSInteger)requestCode;

@end

@interface GJCustomZBarViewController : UIViewController<ZBarReaderViewDelegate>
{
    @private BOOL upOrdown;
    @private IBOutlet ZBarReaderView *_readerView;
//    @private IBOutlet UIImageView *_readLine;
    
    UIView *_QrCodeline;
    
    NSTimer *_timer;
    
    //设置扫描画面
    
    @private IBOutlet UIView *_overlayView;
    @private id<GJCustomZBarViewControllerDelegate> _delegate;
    
}

- (IBAction)onCancelClick:(id)sender;
- (void)setCustomZBarViewControllerDelegate:(id<GJCustomZBarViewControllerDelegate>)delegate requestCode:(NSInteger)requestCode;

@end
