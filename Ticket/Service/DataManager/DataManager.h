//
// Created by Артем Б on 03.02.2018.
// Copyright (c) 2018 Артем Б. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"
#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAiport
} DataSourceType;

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadData;
- (City*)cityForIATA:(NSString*)iata;
- (City*)cityForLocation:(CLLocation*)location;

@property (nonatomic, strong, readonly) NSArray *coutries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

@end
