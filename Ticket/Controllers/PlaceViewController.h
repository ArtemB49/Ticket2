//
//  PlaceViewController.h
//  Ticket
//
//  Created by Артем Б on 01.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

typedef enum PlaceType{
    PlaceTypeArrival,
    PlaceTypeDeparture
}PlaceType;

@protocol PlaceViewControllerDelegate<NSObject>
    - (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;
@end

@interface PlaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;
- (instancetype)initWithType:(PlaceType)type;

@end
