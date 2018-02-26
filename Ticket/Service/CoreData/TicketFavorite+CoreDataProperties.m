//
//  TicketFavorite+CoreDataProperties.m
//  Ticket
//
//  Created by Артем Б on 19.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//
//

#import "TicketFavorite+CoreDataProperties.h"

@implementation TicketFavorite (CoreDataProperties)

+ (NSFetchRequest<TicketFavorite *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TicketFavorite"];
}

@dynamic airline;
@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic flight_number;
@dynamic from;
@dynamic price;
@dynamic return_date;
@dynamic to;

@end
