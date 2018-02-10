//
//  MapPrice.h
//  Ticket
//
//  Created by Артем Б on 10.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface MapPrice : NSObject

@property (nonatomic, strong) City* destination;
@property (nonatomic, strong) City* origin;
@property (nonatomic, strong) NSDate* departure;
@property (nonatomic, strong) NSDate* returnDate;
@property (nonatomic) NSInteger numberOfChanges;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger distance;
@property (nonatomic) BOOL actual;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary withOrigin:(City*)origin;

@end
