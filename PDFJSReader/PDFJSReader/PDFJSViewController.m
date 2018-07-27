//
//  PDFJSViewController.m
//  PDFJSReader
//
//  Created by limeng on 2018/7/25.
//  Copyright © 2018年 lilu. All rights reserved.
//

#import "PDFJSViewController.h"
#import "PDFWebView.h"

@interface PDFJSViewController () <UIWebViewDelegate, UIScrollViewDelegate>
{
    NSInteger _pageNumber;
}

/**
 是否加载成功
 */
@property (nonatomic, assign) BOOL loadSuccess;
@property (nonatomic, strong) PDFWebView *webView;

/**
 计时
 */
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger readTime;

@end

@implementation PDFJSViewController

- (void)dealloc{
    NSLog(@"%s", __func__);
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    PDFWebView *webView = [[PDFWebView alloc] initWithFrame:self.view.bounds];
    webView.startPageNumber = self.startPage;
    webView.delegate = self;
    webView.scrollView.delegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    [webView loadPDFFile:self.filePath];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.loadSuccess && !_timer) {
        //加载成功才可以计时
        [self startTimer];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self endTimer];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    
    if (self.navigationController) {
        if (self.navigationController.navigationBar.translucent) {
            //导航栏半透明
            CGFloat statusH = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
            CGFloat navH = CGRectGetHeight(self.navigationController.navigationBar.frame);
            CGFloat topHeight = statusH + navH;
            CGFloat webH = CGRectGetHeight(self.view.bounds) - topHeight;
            self.webView.frame = CGRectMake(0, topHeight, CGRectGetWidth(self.view.bounds), webH);
            return;
        }
    }
}

#pragma mark - lazy
- (NSInteger)pageNumber{
    if (_webView) {
        _pageNumber = self.webView.pageNumber;
    }
    return _pageNumber;
}

- (void)setPageNumber:(NSInteger)pageNumber{
    _pageNumber = pageNumber;
    if (_webView) {
        self.webView.pageNumber = pageNumber;
    }
}

- (void)setStartPage:(NSInteger)startPage{
    _startPage = startPage;
    _pageNumber = startPage;
}

/**
 更新最大阅读的页码
 */
- (void)updateMaxReadPageNumber{
    NSInteger page = self.pageNumber;
    if (page > self.maxReadPageNumber) {
        self.maxReadPageNumber = page;
    }
    NSLog(@"当前:%zd, 最大:%zd", page, self.maxReadPageNumber);
}

#pragma mark - method
// !!!: ---------- 计时部分 ----------
- (void)startTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)endTimer{
    [_timer invalidate];
    _timer = nil;
    
    //结束计时时回调
    NSDictionary *dict = @{@"maxReadPage" : @(self.maxReadPageNumber),
                           @"currentPage" : @(self.pageNumber),
                           @"time" : @(self.readTime)
                           };
    self.readEndHandler(dict);
    
}

- (void)updateTime{
    self.readTime ++;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.loadSuccess = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [self startTimer];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:@"pdfpagechanged"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMaxReadPageNumber];
        });
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
