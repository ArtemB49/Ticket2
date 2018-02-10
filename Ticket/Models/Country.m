//
//  Country.m
//  Ticket
//
//  Created by Артем Б on 01.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "Country.h"

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.currency = [dictionary valueForKey:@"currency"];
        self.translations = [dictionary valueForKey:@"translations"];
        self.name = [dictionary valueForKey:@"name"];
        self.code = [dictionary valueForKey:@"code"];
    }
    return self;
}

@end
