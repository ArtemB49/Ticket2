//
//  TicketFavorite+CoreDataProperties.h
//  Ticket
//
//  Created by Артем Б on 19.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//
//

#import "TicketFavorite+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TicketFavorite (CoreDataProperties)

+ (NSFetchRequest<TicketFavorite *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nonatomic) int16_t flight_number;
@property (nullable, nonatomic, copy) NSString *from;
@property (nonatomic) int64_t price;
@property (nullable, nonatomic, copy) NSDate *return_date;
@property (nullable, nonatomic, copy) NSString *to;

@end

NS_ASSUME_NONNULL_END
