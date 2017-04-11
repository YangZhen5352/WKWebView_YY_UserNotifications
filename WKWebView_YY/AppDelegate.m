//
//  AppDelegate.m
//  WKWebView_YY
//
//  Created by 杨振 on 2016/11/16.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "AppDelegate.h"
#import <Speech/Speech.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    //iOS 10 before
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//    [application registerUserNotificationSettings:settings];
    
    //iOS 10
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate = self;
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (!error) {
//            NSLog(@"request authorization succeeded!");
//        }
//    }];
//    // 获取通知授权和设置
//    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//        /*
//         UNAuthorizationStatusNotDetermined : 没有做出选择
//         UNAuthorizationStatusDenied : 用户未授权
//         UNAuthorizationStatusAuthorized ：用户已授权
//         */
//        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
//        {
//            NSLog(@"未选择");
//        }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
//            NSLog(@"未授权");
//        }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
//            NSLog(@"已授权");        
//        }       
//    }];
//    // 移除还未展示的通知
//    [center removePendingNotificationRequestsWithIdentifiers: @[@"my_notification"
//                                                                  ]];
//    [center removeAllPendingNotificationRequests]; //  - (void)cancelAllLocalNotifications；
//    // 移除已经展示过的通知
//    [center removeDeliveredNotificationsWithIdentifiers:@[@"my_notification"
//                                                            ]];
//    [center removeAllDeliveredNotifications];
//    // 获取未展示的通知
//    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
//        NSLog(@"获取未展示的通知 -> %@",requests);
//    }];
//    // 获取展示过的通知
//    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) { 
//        NSLog(@"notifications -> %@",notifications);
//    }];

#pragma mark -------------------- 各个版本注册通知 -------------------
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        // 请求注册通知
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                // 获取通知授权和设置
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    /*
                     UNAuthorizationStatusNotDetermined : 没有做出选择
                     UNAuthorizationStatusDenied : 用户未授权
                     UNAuthorizationStatusAuthorized ：用户已授权
                     */
                    if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
                    {
                        NSLog(@"未选择");
                    }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                        NSLog(@"未授权");
                    }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                        NSLog(@"已授权");        
                    }
                }];
                // 移除还未展示的通知
                [center removePendingNotificationRequestsWithIdentifiers: @[@"my_notification"
                                                                            ]];
                [center removeAllPendingNotificationRequests]; //  - (void)cancelAllLocalNotifications；
                // 移除已经展示过的通知
                [center removeDeliveredNotificationsWithIdentifiers:@[@"my_notification"
                                                                      ]];
                [center removeAllDeliveredNotifications];
                // 获取未展示的通知
                [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                    NSLog(@"获取未展示的通知 -> %@",requests);
                }];
                // 获取展示过的通知
                [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
                    NSLog(@"notifications -> %@",notifications);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
   
#pragma mark ----------------------------------------------------------
    
    //申请用户语音识别权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        NSLog(@"申请用户语音识别权限 -> 成功");
        /*
        //结果未知 用户尚未进行选择
        SFSpeechRecognizerAuthorizationStatusNotDetermined
        //用户拒绝授权语音识别
        SFSpeechRecognizerAuthorizationStatusDenied
        //设备不支持语音识别功能
        SFSpeechRecognizerAuthorizationStatusRestricted
        //用户授权语音识别
        SFSpeechRecognizerAuthorizationStatusAuthorized
         */
    }];
    
    
    return YES;
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
