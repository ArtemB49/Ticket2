//
// Created by Артем Б on 03.02.2018.
// Copyright (c) 2018 Артем Б. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()
// Приватные массивы для хранения готовых объектов данных
@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *airportsArray;
@end

@implementation DataManager

 + (instancetype)sharedInstance {
     static DataManager *instance;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         instance = [DataManager new];
     });
     return instance;
 }

//  Загрузка данных из JSON
 - (void)loadData {
     dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
         NSArray *countriesJsonArray = [self arrayFromFileName: @"countries" ofType: @"json"];
         self.countriesArray = [self createObjectsFromArray: countriesJsonArray withType: DataSourceTypeCountry];

         NSArray *citiesJsonArray = [self arrayFromFileName: @"cities" ofType: @"json"];
         self.citiesArray = [self createObjectsFromArray: citiesJsonArray withType: DataSourceTypeCity];

         NSArray *airportsJsonArray = [self arrayFromFileName: @"airports" ofType: @"json"];
         self.airportsArray = [self createObjectsFromArray: airportsJsonArray withType: DataSourceTypeAiport];

         dispatch_async(dispatch_get_main_queue(), ^{
             [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete
                                                                 object:nil];
         });
         NSLog(@"Complete load data");
     });
 }

// Преобразование в готовые объекты
 - (NSMutableArray *)createObjectsFromArray:(NSArray *)array withType:(DataSourceType)type{
     NSMutableArray *results = [NSMutableArray  new];

     for (NSDictionary *jsonObject in array) {
         if (type == DataSourceTypeCountry){
             Country *country = [[Country alloc] initWithDictionary:jsonObject];
             [results addObject:country];
         } else if (type == DataSourceTypeCity){
             City *city = [[City alloc] initWithDictionary:jsonObject];
             [results addObject:city];
         } else if (type == DataSourceTypeAiport){
             Airport *airport = [[Airport alloc] initWithDictionary:jsonObject];
             [results addObject:airport];
         }
     }
     return results;
 }

 - (NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type{
     NSString *path = [[NSBundle mainBundle] pathForResource: fileName ofType: type];
     NSData *data = [NSData dataWithContentsOfFile: path];
     return  [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error: nil];

 }

- (City*)cityForIATA:(NSString*)iata{
    if (iata) {
        for (City* city in self.citiesArray) {
            if ([city.code isEqualToString:iata]) {
                return city;
            }
        }
    }
    return nil;
}

- (City*)cityForLocation:(CLLocation*)location {
    for (City* city in _citiesArray) {
        if (ceilf(city.coordinate.latitude) == ceilf(location.coordinate.latitude)
            && ceilf(city.coordinate.longitude) == ceilf(location.coordinate.longitude)) {
            return city;
        }
    }
    return nil;
}

 - (NSArray *)countries{
     return self.countriesArray;
 }

 - (NSArray *)cities{
     return self.citiesArray;
 }

 - (NSArray *)airports {
     return self.airportsArray;
 }

@end
