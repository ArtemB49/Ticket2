//
//  Ticket.m
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

- (instancetype)price:(NSNumber*)price
              airline:(NSString*)air
            departure:(NSDate*)dep
              expires:(NSDate*)exp
         flightNumber:(NSNumber*)num
               returnD:(NSDate*)ret
                 from:(NSString*)from
                   to:(NSString*)to{
    
    if ([super init]) {
        _price = price;
        _airline = air;
        _departure = dep;
        _expires = exp;
        _flightNumber = num;
        _returnDate = ret;
        _from = from;
        _to = to;
    }
    return self;
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.airline = [dictionary valueForKey:@"airline"];
        self.expires = dateFromString([dictionary valueForKey:@"expires_at"]);
        self.departure = dateFromString([dictionary valueForKey:@"departure_at"]);
        self.flightNumber = [dictionary valueForKey:@"flight_number"];
        self.price = [dictionary valueForKey:@"price"];
        self.returnDate = dateFromString([dictionary valueForKey:@"return_at"]);
    }
    return self;
}

NSDate *dateFromString(NSString *dateString){
    if (!dateString) {
        return nil;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    NSString* correctStringDate = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    correctStringDate = [correctStringDate stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString: correctStringDate];
}
@end
