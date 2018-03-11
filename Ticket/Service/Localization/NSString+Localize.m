//
//  NSString+Localize.m
//  Ticket
//
//  Created by Артем Б on 11.03.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString*)localize {
    return NSLocalizedString(self, "");
}

@end
