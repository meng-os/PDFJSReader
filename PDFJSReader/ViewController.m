//
//  ViewController.m
//  PDFJSReader
//
//  Created by lilu on 2017/5/12.
//  Copyright © 2017年 lilu. All rights reserved.
//

#import "ViewController.h"
#import "PDFJSViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 100, 40)];
    [button setTitle:@"PDF" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)buttonClick:(UIButton *)button{
    PDFJSViewController *vc = [[PDFJSViewController alloc]init];
    vc.title = @"PDF";
    vc.startPage = 9;
    
    NSString *pdfFilePath = [[NSBundle mainBundle] pathForResource:@"git搭建" ofType:@"pdf"];
    vc.filePath = pdfFilePath;
    
    vc.readEndHandler = ^(NSDictionary *dict) {
        NSLog(@"阅读进度:%@", dict);
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
