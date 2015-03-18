//
//  CustomZBarViewController.m
//  Push
//
//  Created by 高 军 on 15/2/11.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "CustomZBarViewController.h"


#define SCANVIEW_EdgeTop 40.0

#define SCANVIEW_EdgeLeft 50.0

#define VIEW_WIDTH 320
#define VIEW_HEIGHT 460


#define TINTCOLOR_ALPHA 0.2 //浅色透明度

#define DARKCOLOR_ALPHA 0.5 //深色透明度

@interface CustomZBarViewController ()
@property (nonatomic) NSInteger requestCode;
@end


@implementation CustomZBarViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
        
    }
    
    return self;
    
}


- (void)viewDidLoad

{
    [super viewDidLoad];
    
    self.title=@"扫描二维码";
    
    //初始化扫描界面
    
//    [self setScanView];
    
//    _readerView= [[ZBarReaderView alloc]init];
//    
//    _readerView.frame =CGRectMake(0,64, VIEW_WIDTH, VIEW_HEIGHT -64);
    
//    self.view = _readerView;
    _readerView.tracksSymbols=NO;
    
    _readerView.readerDelegate =self;
//    [_scanView setFrame:[_readerView frame]];
    
    [_readerView addSubview:_overlayView];
    
    //关闭闪光灯
    
    _readerView.torchMode =0;
    
//    [self.view addSubview:_readerView];
    
    //扫描区域
    
    //readerView.scanCrop =
    
    [_readerView start];
    
    [self createTimer];
    
}

- (void)dealloc
{
    [_readerView stop];
    [self stopTimer];
}

- (IBAction)onCancelClick:(id)sender
{    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- ZBarReaderViewDelegate

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image

{
    
    const zbar_symbol_t *symbol =zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    //判断是否包含 头"http:'
    NSString *regex =@"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid =@"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    if ([predicate evaluateWithObject:symbolStr]) {
        
    }
    
    else if([ssidPre evaluateWithObject:symbolStr]){
        
        NSArray *arr = [symbolStr componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0]componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1]componentsSeparatedByString:@":"];
        
        symbolStr = [NSString stringWithFormat:@"ssid: %@ \n password:%@",
                     [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        

        
        //然后，可以使用如下代码来把一个字符串放置到剪贴板上：
//        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
//        pasteboard.string = [arrInfoFoot objectAtIndex:1];
        
    }
    
    if ([symbolStr canBeConvertedToEncoding:NSShiftJISStringEncoding])
    {
        symbolStr = [NSString stringWithCString:[symbolStr cStringUsingEncoding:
                                             NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onZBarResultReturned:requestCode:)])
    {
        [_delegate onZBarResultReturned:@{@"code":symbolStr} requestCode:_requestCode];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCustomZBarViewControllerDelegate:(id<CustomZBarViewControllerDelegate>)delegate requestCode:(NSInteger)requestCode
{
    _delegate = delegate;
    self.requestCode = requestCode;
}

- (void)openLight
{
    if (_readerView.torchMode ==0) {
        
        _readerView.torchMode =1;
        
    }else
        
    {
        _readerView.torchMode =0;
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    
    if (_readerView.torchMode ==1) {
        
        _readerView.torchMode =0;
        
    }
    
    [self stopTimer];
    
    [_readerView stop];
    
}

//二维码的横线移动

- (void)moveUpAndDownLine
{
//    CGRect rectFrame = [self.view frame];
//    CGRect rectCenter = [_centerView frame];
//    int top = (rectFrame.size.height-rectCenter.size.height)/2;
//    int bottom = top + rectCenter.size.height;
//    
//    CGFloat Y=_QrCodeline.frame.origin.y;
//    
//    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
//    
//    if (Y >= bottom ){
//        
//        [UIView beginAnimations:@"asa" context:nil];
//        
//        [UIView setAnimationDuration:1];
//        
//        CGRect rect = CGRectMake((rectFrame.size.width-rectCenter.size.width)/2 -9, (rectFrame.size.height - rectCenter.size.height)/2, rectCenter.size.width, 2);
//        _QrCodeline.frame=rect;
//        
//        [UIView commitAnimations];
//        
//    }else{
//        
//        [UIView beginAnimations:@"asa" context:nil];
//        
//        [UIView setAnimationDuration:1];
//        CGRect rect = [_QrCodeline frame];
//        rect.origin.y += 50;
//        _QrCodeline.frame=rect;
//        
//        [UIView commitAnimations];
//        
//    }
//    
}


- (void)createTimer

{
    
    //创建一个时间计数
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
    
}


- (void)stopTimer

{
    
    if ([_timer isValid] == YES) {
        
        [_timer invalidate];
        
        _timer =nil;
        
    }
    
}


- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

@end
