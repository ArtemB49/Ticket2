//
//  Ticket.h
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *expires;
@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (instancetype)price:(NSNumber*)price
              airline:(NSString*)air
            departure:(NSDate*)dep
              expires:(NSDate*)exp
         flightNumber:(NSNumber*)num
               returnD:(NSDate*)ret
                 from:(NSString*)from
                   to:(NSString*)to;

@end
