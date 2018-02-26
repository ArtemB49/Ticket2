//
//  CoreDataHelper.h
//  Ticket
//
//  Created by Артем Б on 18.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "TicketFavorite+CoreDataClass.h"
@class Ticket;

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket*)ticket;
- (NSArray*)favorites;
- (void)addToFavorite:(Ticket*)ticket;
- (void)removeFromFavorite:(Ticket*)ticket;

@end
