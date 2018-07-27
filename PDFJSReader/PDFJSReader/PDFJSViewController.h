//
//  PDFJSViewController.h
//  PDFJSReader
//
//  Created by limeng on 2018/7/25.
//  Copyright © 2018年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFJSViewController : UIViewController

@property (nonatomic, strong) NSString *filePath;

/**
 起始页码
 */
@property (nonatomic, assign) NSInteger startPage;

/**
 页数
 */
@property (nonatomic, assign) NSInteger pageNumber;

/**
 最大阅读的页码
 */
@property (nonatomic, assign) NSInteger maxReadPageNumber;

/**
 结束阅读回调
 
 maxReadPage, 最大阅读的页数
 currentPage, 当前阅读的页数
 time,        阅读的时间(秒)
 */
@property (nonatomic, copy) void(^readEndHandler)(NSDictionary *);

@end
