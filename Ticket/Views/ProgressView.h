//
//  ProgressView.h
//  Ticket
//
//  Created by Артем Б on 21.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void(^)(void))completion;
- (void)dismiss:(void(^)(void))completion;

@end
