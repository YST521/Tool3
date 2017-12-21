//
//  ViewController.m
//  LocationNOtifiCentDemo
//
//  Created by youxin on 2017/12/20.
//  Copyright © 2017年 YST. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 1.本地通知
    [self requestLocationNotification];
    
}


- (void)requestLocationNotification{
    
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"测试通知888";
    content.subtitle = @"测试通知";
    content.body = @"来自宇宙";
    content.badge = @1;
    content.userInfo = @{@"vc":@"TestViewController"};
    
    //    NSError *error = nil;
    //
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_certification_status1@2x" ofType:@"png"];
    
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    
    
    // 创建本地通知
    NSString *requestIdentifer = @"TestRequestww1";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger1];
    
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
