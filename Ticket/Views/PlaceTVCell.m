//
//  PlaceTVCell.m
//  Ticket
//
//  Created by Артем Б on 04.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "PlaceTVCell.h"

@implementation PlaceTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.leftLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0, 0.0, screenWidth / 2.0, 44.0)];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: self.leftLabel];
        
        self.rightLabel = [[UILabel alloc] initWithFrame: CGRectMake(screenWidth / 2.0, 0.0, screenWidth / 2.0, 44.0)];
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: self.rightLabel];
    }
    return self;
}

@end
