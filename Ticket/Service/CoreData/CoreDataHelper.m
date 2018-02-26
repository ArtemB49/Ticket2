//
//  CoreDataHelper.m
//  Ticket
//
//  Created by Артем Б on 18.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "CoreDataHelper.h"
#import "Ticket.h"

@interface CoreDataHelper()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance{
    static CoreDataHelper* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup{
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"baseair" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];
    
    NSURL* docsURL = [[[NSFileManager defaultManager]
                       URLsForDirectory: NSDocumentDirectory
                       inDomains: NSUserDomainMask] lastObject];
    
    NSURL* storeURL = [docsURL URLByAppendingPathComponent: @"base.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel: _managedObjectModel];
    
    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                         configuration:nil
                                                                                   URL:storeURL
                                                                               options:nil
                                                                                 error:nil];
    if (!store) {
        abort();
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError* error;
    [_managedObjectContext save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (TicketFavorite*)favoriteFromTicket:(Ticket*)ticket{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TicketFavorite"];
    request.predicate = [NSPredicate predicateWithFormat:@"price==%ld AND airline==%@ AND from==%@ AND to==%@ AND departure==%@ AND expires== %@ AND flight_number == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket{
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket{
    TicketFavorite *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"TicketFavorite" inManagedObjectContext: _managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flight_number = ticket.flightNumber.intValue;
    favorite.return_date = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    [self save];
}

- (void)removeFromFavorite:(Ticket *)ticket{
    TicketFavorite* favorite = [self favoriteFromTicket:ticket];
    if (favorite){
        [_managedObjectContext deleteObject: favorite];
        [self save];
    }
}

- (NSArray*)favorites{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TicketFavorite"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending: false]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}
@end
