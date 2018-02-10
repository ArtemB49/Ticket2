//
//  APIManager.m
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "APIManager.h"
#import "Ticket.h"
#import "SearchRequestStruct.h"
#import "MapPrice.h"

#define API_TOKEN @""
#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CHEAP @"https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="
#define API_URL_MAP_PRICE @"https://map.aviasales.ru/prices.json?origin_iata="

@implementation APIManager

+ (instancetype)sharedInstance {
    static APIManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [APIManager new];
    });
    return instance;
}

- (void)cityForCurrentIP:(void (^)(City *))completion{
    [self IPAddressWithCompletion:^(NSString *IPAddress) {
        [self load:[NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP, IPAddress] withComletion:^(id  _Nullable result) {
            NSDictionary* json = result;
            NSString* iata = [json valueForKey:@"iata"];
            if (iata) {
                City* city = [[DataManager sharedInstance] cityForIATA: iata];
                if (city) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(city);
                    });
                }
            }
        }];
    }];
}

- (void)IPAddressWithCompletion:(void(^)(NSString* IPAddress))completion {
    [self load:API_URL_IP_ADDRESS withComletion:^(id  _Nullable result) {
        NSDictionary* json = result;
        completion([json valueForKey:@"ip"]);
    }];
}

- (void)load:(NSString*)urlString withComletion:(void(^)(_Nullable id result))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
    });
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: urlString]
                                 completionHandler:^(NSData * _Nullable data,
                                                     NSURLResponse * _Nullable response,
                                                     NSError * _Nullable error) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: false];
                                     });
                                     completion([NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:nil]);
                                 }] resume ];
    
}

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void(^)(NSArray* tickets))completion{
    NSString* urlString = [NSString stringWithFormat:@"%@?%@&token=%@", API_URL_CHEAP, SearchRequestQuery(request), API_TOKEN];
    [self load:urlString withComletion:^(id  _Nullable result) {
        NSDictionary *responce = result;
        if (responce) {
            NSDictionary* json = [[responce valueForKey:@"data"] valueForKey: request.destionation];
            NSMutableArray* array = [NSMutableArray new];
            for (NSString* key in json) {
                NSDictionary* value = [json valueForKey: key];
                Ticket* ticket = [[Ticket alloc] initWithDictionary: value];
                ticket.from = request.origin;
                ticket.to = request.destionation;
                [array addObject: ticket];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array);
            });
        }
    }];
}

- (void)mapPricesFor:(City*)origin withCompletion:(void(^)(NSArray* prices))completion{
    static BOOL isLoading;
    if (isLoading){return;}
    isLoading = true;
    NSString* urlString = [NSString stringWithFormat:@"%@%@", API_URL_MAP_PRICE, origin.code];
    [self load: urlString withComletion:^(id  _Nullable result) {
        NSArray* array = result;
        NSMutableArray* prices = [NSMutableArray new];
        if (array) {
            for (NSDictionary* mapPriceDictionary in array) {
                MapPrice* mapPrice = [[MapPrice alloc] initWithDictionary: mapPriceDictionary withOrigin:origin];
                [prices addObject: mapPrice];
            }
            isLoading = false;
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(prices);
            });
        }
    }];
}

NSString* SearchRequestQuery(SearchRequest request){
    NSString* result = [NSString stringWithFormat:@"origin=%@&destination=%@", request.origin, request.destionation];
    if (request.departDate && request.returnDate) {
        NSDateFormatter* dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM";
        result = [NSString stringWithFormat:@"%@depart_date=%@&return_date=%@",
                  result,
                  [dateFormatter stringFromDate: request.departDate],
                  [dateFormatter stringFromDate: request.returnDate]];
    }
    return result;
}


@end
