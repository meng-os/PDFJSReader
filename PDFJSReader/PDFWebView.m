//
//  PDFWebView.m
//  PDFJSReader
//
//  Created by lilu on 2017/5/12.
//  Copyright © 2017年 lilu. All rights reserved.
//

#import "PDFWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface PDFWebView () <UIWebViewDelegate>

@end

@implementation PDFWebView
- (void)dealloc{
    NSLog(@"%s", __func__);
}

- (void)loadPDFFile:(NSString*)filePath;{
    _filePath = filePath;
    NSString *viwerPath = [[NSBundle mainBundle] pathForResource:@"viewer" ofType:@"html" inDirectory:@"PDFJS/web"];
    filePath = [NSString stringWithFormat:@"file://%@", filePath];
    NSString *urlStr = [NSString stringWithFormat:@"%@?file=%@#page=5",viwerPath,filePath];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self loadRequest:request];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setPage];
    });
    
}

- (void)setPage{
    
    NSString *string = @"window.PDFViewerApplication.page = 7;";
    [self stringByEvaluatingJavaScriptFromString:string];
    
//    JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *textJS = @"setPageNumber(7)";
//    [context evaluateScript:textJS];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
