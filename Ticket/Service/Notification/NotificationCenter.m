//
//  NotificationCenter.m
//  Ticket
//
//  Created by Артем Б on 22.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "NotificationCenter.h"
#import <UserNotifications/UserNotifications.h>
#import <NotificationCenter/NotificationCenter.h>

@interface NotificationCenter()<UNUserNotificationCenterDelegate>
@end

@implementation NotificationCenter

+ (instancetype)sharedInstance {
    static NotificationCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NotificationCenter new];
    });
    return instance;
}

- (void)registerService{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions: (UNAuthorizationOptionBadge |
                                                 UNNotificationPresentationOptionSound |
                                                 UNAuthorizationOptionAlert)
                              completionHandler: ^(BOOL granted, NSError * _Nullable error) {
                                  if (!error) {
                                      NSLog(@"request authorization succeeded!");
                                  }
                              }];
    } else {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *setting;
        setting = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings: setting];
    }
}

- (void)sendNotification:(Notification)notification {
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = notification.title;
        content.body = notification.body;
        content.sound = [UNNotificationSound defaultSound];
        
        if (notification.imageURL) {
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:notification.imageURL options:nil error:nil];
            if (attachment) {
                content.attachments = @[attachment];
            }
        }
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate: notification.date];
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.calendar = calendar;
        newComponents.timeZone = [NSTimeZone defaultTimeZone];
        newComponents.month = components.month;
        newComponents.day = components.day;
        newComponents.hour = components.hour;
        newComponents.minute = components.minute;
        
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:false];
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"Notification"
                                                                              content:content
                                                                              trigger:trigger];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:nil];
    } else {
        UILocalNotification *localNotification = [UILocalNotification new];
        localNotification.fireDate = notification.date;
        if (notification.title) {
            localNotification.alertBody = [NSString stringWithFormat:@"%@ - %@", notification.title, notification.body];
        } else {
            localNotification.alertBody = notification.body;
        }
        
        [[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
    }
}
    
    
    Notification NotificationMake(NSString* _Nullable title, NSString* _Nonnull body, NSDate* _Nonnull date, NSURL* _Nullable imageURL){
        Notification notification;
        notification.title = title;
        notification.date = date;
        notification.body = body;
        notification.imageURL = imageURL;
        
        return notification;
    }

@end
