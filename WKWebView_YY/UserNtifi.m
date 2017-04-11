//
//  UserNtifi.m
//  WKWebView_YY
//
//  Created by 杨振 on 2016/11/17.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "UserNtifi.h"
#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface UserNtifi () <UNUserNotificationCenterDelegate>

@end

@implementation UserNtifi

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)creatLocalNotification:(UIButton *)sender {
    if (!([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)) {
        return;
    }
    // 创建一个本地通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    UNMutableNotificationContent *content_1 = [[UNMutableNotificationContent alloc] init];
    // 主标题
    content_1.title = [NSString localizedUserNotificationStringForKey:@"title_01" arguments:nil];
    // 副标题
    content_1.subtitle = [NSString localizedUserNotificationStringForKey:@"subtitle_01" arguments:nil];
    content_1.badge = [NSNumber numberWithInteger:1];
    content_1.body = [NSString localizedUserNotificationStringForKey:@"title_message_for_yan_01" arguments:nil];
    content_1.sound = [UNNotificationSound defaultSound];
    
    // 附加信息
    content_1.userInfo = @{@"msg" : @"开饭了"};
    
    content_1.categoryIdentifier = @"my_category";
    // 设置触发时间
    UNTimeIntervalNotificationTrigger *trigger_1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    // 创建一个发送请求
    UNNotificationRequest *request_1 = [UNNotificationRequest requestWithIdentifier:@"my_notification" content:content_1 trigger:trigger_1];
    
    // 发送通知
    [center addNotificationRequest:request_1 withCompletionHandler:^(NSError * _Nullable error) {
    }];
    // 设置通知的：默认文字
    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"my_text_01" title:@"text_action_01" options:UNNotificationActionOptionForeground textInputButtonTitle:@"输入-01" textInputPlaceholder:@"默认文字_01"];
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"my_action" title:@"action" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"my_action_1" title:@"action_1" options:UNNotificationActionOptionAuthenticationRequired];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"my_category_2" actions:@[textAction,action,action_1] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    NSSet *setting = [NSSet setWithObjects:category, nil];
    [center setNotificationCategories:setting];
    
    // 发送通知
    [center addNotificationRequest:request_1 withCompletionHandler:^(NSError * _Nullable error) {
    }];
}
- (IBAction)creatOtherNf:(UIButton *)sender {
    // 创建一个本地通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    UNMutableNotificationContent *content_1 = [[UNMutableNotificationContent alloc] init];
    // 主标题
    content_1.title = [NSString localizedUserNotificationStringForKey:@"title" arguments:nil];
    // 副标题
    content_1.subtitle = [NSString localizedUserNotificationStringForKey:@"subtitle" arguments:nil];
    content_1.badge = [NSNumber numberWithInteger:1];
    content_1.body = [NSString localizedUserNotificationStringForKey:@"title_two_22222" arguments:nil];
    content_1.sound = [UNNotificationSound defaultSound];
    // 附加信息
    content_1.userInfo = @{@"msg" : @"二次开饭了"};
    // 设置分类标识符
    content_1.categoryIdentifier = @"my_category_2";
    // 设置触发时间
    UNTimeIntervalNotificationTrigger *trigger_1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    // 创建一个发送请求
    UNNotificationRequest *request_1 = [UNNotificationRequest requestWithIdentifier:@"my_notification_2" content:content_1 trigger:trigger_1];
    
    // 设置通知的：默认文字
    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"my_text" title:@"text_action" options:UNNotificationActionOptionForeground textInputButtonTitle:@"输入_2" textInputPlaceholder:@"默认文字"];
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"my_action" title:@"action" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"my_action_1" title:@"action_1" options:UNNotificationActionOptionAuthenticationRequired];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"my_category_2" actions:@[textAction,action,action_1] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    NSSet *setting = [NSSet setWithObjects:category, nil];
    [center setNotificationCategories:setting];
    
    // 发送通知
    [center addNotificationRequest:request_1 withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

#pragma mark -
#pragma mark - <UNUserNotificationCenterDelegate>
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    // 应用内展示通知时调用
    completionHandler(UNNotificationPresentationOptionBadge + UNNotificationPresentationOptionSound);
    NSLog(@"111 ====> %@,%@", notification.date, notification.request);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    // 取消图标上的提醒数字
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    // 在用户与你推送的通知进行交互时被调用：
    NSLog(@"userInfo--%@",response.notification.request.content.userInfo);
    completionHandler();
    
    // 获取通知中心的所有的Categories
    [center getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
        for (UNNotificationCategory *category in categories) {
            if (   [category.identifier isEqualToString:@"my_category_2"]
                || [response.notification.request.content.categoryIdentifier isEqualToString:@"my_category_2"]
                || [category.identifier isEqualToString:@"my_category"]
                || [response.notification.request.content.categoryIdentifier isEqualToString:@"my_category"]) {
                for (UNNotificationAction *textAction in category.actions) {
                    if ([textAction.identifier isEqualToString:@"my_text"] || [textAction.identifier isEqualToString:@"my_text_01"]) {
                        UNTextInputNotificationAction *text = (UNTextInputNotificationAction *)textAction;
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:text.textInputButtonTitle preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                    }
                }
            }
        }
    }];
    

#pragma mark ---------------- 需求二 --------------
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
}

/* * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:] * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心 * @param notification 前台得到的的通知对象 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions / - (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler; / * @brief handle UserNotifications.framework [didReceiveNotificationResponse:withCompletionHandler:] * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心 * @param response 通知响应对象 * @param completionHandler */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{}

@end
