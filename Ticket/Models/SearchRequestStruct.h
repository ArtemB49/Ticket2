//
//  SearchRequestEnum.h
//  Ticket
//
//  Created by Артем Б on 04.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//



typedef struct SearchRequest{
    __unsafe_unretained NSString* origin;
    __unsafe_unretained NSString* destionation;
    __unsafe_unretained NSString* departDate;
    __unsafe_unretained NSString* returnDate;
}SearchRequest;
