//
//  PDFWebView.h
//  PDFJSReader
//
//  Created by lilu on 2017/5/12.
//  Copyright © 2017年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFWebView : UIWebView

/**
 pdf file path
 **/
@property (readonly) NSString *filePath;

/**
 load pdf file

 @param filePath pdf file path
 */
- (void)loadPDFFile:(NSString*)filePath;

/**
 页数
 */
@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) NSInteger startPageNumber;

/**
 关闭pdf
 */
- (void)closePdf;

/**
 清除缓存
 */
- (void)clearAllUIWebViewData;

@end
