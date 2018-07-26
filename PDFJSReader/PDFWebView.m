//
//  PDFWebView.m
//  PDFJSReader
//
//  Created by lilu on 2017/5/12.
//  Copyright © 2017年 lilu. All rights reserved.
//

#import "PDFWebView.h"

@interface PDFWebView ()

@end

@implementation PDFWebView
- (void)dealloc{
    [self clearAllUIWebViewData];
    NSLog(@"%s", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.startPageNumber = 1;
        
        //双击
        UITapGestureRecognizer *doubleTap = ({
            UITapGestureRecognizer *tapGestureRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
            tapGestureRecognizer.numberOfTapsRequired = 2;
            tapGestureRecognizer;
        });
        
        [self addGestureRecognizer:doubleTap];
    
    }
    return self;
}

- (void)loadPDFFile:(NSString*)filePath;{
    _filePath = filePath;
    NSString *viwerPath = [[NSBundle mainBundle] pathForResource:@"viewer" ofType:@"html" inDirectory:@"PDFJS/web"];
    filePath = [NSString stringWithFormat:@"file://%@", filePath];
    NSString *urlStr = [NSString stringWithFormat:@"%@?file=%@#page=%zd",viwerPath,filePath, self.startPageNumber];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self loadRequest:request];

}

- (void)setPageNumber:(NSInteger)pageNumber{
    NSString *string = [NSString stringWithFormat:@"window.PDFViewerApplication.page = %zd", pageNumber];
    [self stringByEvaluatingJavaScriptFromString:string];
}

- (NSInteger)pageNumber{
    NSString *string = @"window.PDFViewerApplication.page";
    NSString *result = [self stringByEvaluatingJavaScriptFromString:string];
    return [result integerValue];
}

#pragma mark - GestureRecognizer
- (void)doubleTapped:(UITapGestureRecognizer *)recognizer{
//    NSString *scaleString =
}

/**
 关闭pdf
 */
- (void)closePdf{
    NSString *string = @"window.PDFViewerApplication.close();";
    [self stringByEvaluatingJavaScriptFromString:string];
}

- (void)clearAllUIWebViewData {
    // Empty the cookie jar...
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
