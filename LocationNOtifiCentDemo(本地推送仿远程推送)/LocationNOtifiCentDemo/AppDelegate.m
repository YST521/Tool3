//
//  AppDelegate.m
//  LocationNOtifiCentDemo
//
//  Created by youxin on 2017/12/20.
//  Copyright © 2017年 YST. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "TestViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                // 点击允许
               NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    //                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
               NSLog(@"注册失败");
            }
            
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        
        
        
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }
    
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    

    
    
    return YES;
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    NSLog(@"iOS7及以上系统，收到通知");
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    

    completionHandler(UNNotificationPresentationOptionAlert);
    
    
    
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;

    NSString * className =  userInfo[@"vc"];
    
    //创建视图控制器的Class
    //使用class间接使用类名，即使不加头文件，也能创建对象。
    //编译器要求直接引用类名等标识符，必须拥有声明。
    Class aVCClass = NSClassFromString(className);
    //创建vc对象
    UIViewController * vc = [[aVCClass alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    
    //    UITabBarController *tab = (UITabBarController *)_window.rootViewController;
    //    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    //    //MessageViewController *vc = [[MessageViewController alloc] init];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [nav pushViewController:vc animated:YES];
    //
    completionHandler();  // 系统要求执行这个方法
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
