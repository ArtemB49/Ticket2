//
//  Airport.m
//  Ticket
//
//  Created by Артем Б on 02.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "Airport.h"

@implementation Airport

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.timezone = [dictionary valueForKey:@"time_zone"];
        self.translations = [dictionary valueForKey:@"name_translations"];
        self.name = [dictionary valueForKey:@"name"];
        self.countryCode = [dictionary valueForKey:@"country_code"];
        self.cityCode = [dictionary valueForKey:@"city_code"];
        self.code = [dictionary valueForKey:@"code"];
        self.flightable = [dictionary valueForKey:@"flightable"];
        
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
