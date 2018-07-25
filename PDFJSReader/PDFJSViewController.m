//
//  PDFJSViewController.m
//  PDFJSReader
//
//  Created by limeng on 2018/7/25.
//  Copyright © 2018年 lilu. All rights reserved.
//

#import "PDFJSViewController.h"
#import "PDFWebView.h"

@interface PDFJSViewController ()

@end

@implementation PDFJSViewController

- (void)dealloc{
    NSLog(@"%s", __func__);
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    PDFWebView *webView = [[PDFWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSString *pdfFilePath = [[NSBundle mainBundle] pathForResource:@"git搭建" ofType:@"pdf"];
    [webView loadPDFFile:pdfFilePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
