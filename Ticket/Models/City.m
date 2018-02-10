//
//  City.m
//  Ticket
//
//  Created by Артем Б on 01.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]){
        self.timezone = [dictionary valueForKey:@"time_zone"];
        self.translations = [dictionary valueForKey:@"name_translations"];
        self.name = [dictionary valueForKey:@"name"];
        self.countryCode = [dictionary valueForKey:@"country_code"];
        self.code = [dictionary valueForKey:@"code"];

        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]){
            NSNumber *lon = [coords valueForKey:@"lon"];
            NSNumber *lat = [coords valueForKey:@"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]){}
            self.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
        }
    }
    return self;
}

@end
