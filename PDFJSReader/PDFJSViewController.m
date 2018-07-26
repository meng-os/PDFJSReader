//
//  PDFJSViewController.m
//  PDFJSReader
//
//  Created by limeng on 2018/7/25.
//  Copyright © 2018年 lilu. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "PDFJSViewController.h"
#import "PDFWebView.h"

@interface PDFJSViewController () <UIWebViewDelegate, UIScrollViewDelegate>
{
    NSInteger _pageNumber;
}
@property (nonatomic, strong) PDFWebView *webView;
@property (nonatomic, strong) JSContext *context;

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

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
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
- (void)startTimer{
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
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
