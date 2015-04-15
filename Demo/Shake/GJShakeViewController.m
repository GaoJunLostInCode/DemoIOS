//
//  GJShakeViewController.m
//  Demo
//
//  Created by 高 军 on 15/4/15.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJShakeViewController.h"

@interface GJShakeViewController ()
@property (strong, nonatomic) IBOutlet UIView *mViewTop;
@property (strong, nonatomic) IBOutlet UIView *mViewBottom;
@property (strong, nonatomic) IBOutlet UILabel *mLabel;
@property (strong, nonatomic) AVAudioPlayer *mPlayer;
@end

@implementation GJShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"摇一摇"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    self.mPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (self.mPlayer.isPlaying)
    {
        [self.mPlayer stop];
    }
    
    if (event.type == UIEventSubtypeMotionShake)
    {
        [self.mViewTop setHidden:NO];
        [self.mViewBottom setHidden:NO];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
    {
        [self showShakedAnimation];
        [self.mPlayer play];
    }
}

- (void)showShakedAnimation
{
    const static NSString *shakedAnimation = @"ShakedAnimation";
    [UIView beginAnimations:(NSString*)shakedAnimation context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    
    CGSize viewSize = self.mViewTop.frame.size;
    self.mViewTop.frame = CGRectMake(0, self.mViewTop.frame.origin.y-viewSize.height, viewSize.width, viewSize.height);
    self.mViewBottom.frame = CGRectMake(0, self.mViewBottom.frame.origin.y+viewSize.height, viewSize.width, viewSize.height);
    
    [UIView commitAnimations];
}

#pragma mark UIAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CGSize viewSize = self.mViewTop.frame.size;
    float navigationBarYPos = self.navigationController.navigationBar.frame.origin.y;
    self.mViewTop.frame = CGRectMake(0, navigationBarYPos, viewSize.width, viewSize.height);
    self.mViewBottom.frame = CGRectMake(0, self.mViewTop.frame.origin.y+viewSize
                                        .height, viewSize.width, viewSize.height);
    
    [self.mLabel setText:@"Hello"];
    
    [self.mViewTop setHidden:YES];
    [self.mViewBottom setHidden:YES];
}

@end
