//
//  BMViewController.m
//  BMM
//
//  Created by “Zack” on 09/28/2021.
//  Copyright (c) 2021 “Zack”. All rights reserved.
//

#import "BMViewController.h"
#import <BMM/HttpHandler.h>
@interface BMViewController ()

@end

@implementation BMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [HttpHandler httpRequestWithAPI:@"http://zack2311.club.com" method:@"GET" parameter:nil topic:@"http 接口测试" jsonData:YES shouldAlertResult:NO shouldShowPrecess:NO isUrlEncode:YES result:^(BOOL, NSData * _Nonnull) {
            
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
