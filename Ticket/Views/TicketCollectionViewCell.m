//
//  TicketCollectionViewCell.m
//  Ticket
//
//  Created by Артем Б on 12.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "TicketCollectionViewCell.h"
#import "Ticket.h"
#import <YYWebImage/YYWebImage.h>

@interface TicketCollectionViewCell()

@property (nonatomic, strong) UIImageView* airlineLogoView;
@property (nonatomic, strong) UILabel* priceLabel;
@property (nonatomic, strong) UILabel* placesLabel;
@property (nonatomic, strong) UILabel* dateLabel;

@end

@implementation TicketCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview: self.priceLabel];
        [self.contentView addSubview: self.airlineLogoView];
        [self.contentView addSubview: self.placesLabel];
        [self.contentView addSubview: self.dateLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentView.frame = CGRectMake(10.0, 10.0, screenWidth / 2 - 30.0, self.frame.size.height - 20.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 60.0, 40.0);
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) - 60.0, 20.0, 80.0, 80.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 26.0, 100.0, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket{
    _ticket = ticket;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    self.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    self.dateLabel.text = [dateFormatter stringFromDate: ticket.departure];
    NSURL *urlLogo = AirlineLogo(ticket.airline);
    
    [self.airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
    
}

- (UILabel*)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame: self.bounds];
        _priceLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    }
    return _priceLabel;
}

- (UIImageView*)airlineLogoView {
    if (!_airlineLogoView) {
        _airlineLogoView = [[UIImageView alloc] initWithFrame: self.bounds];
        _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _airlineLogoView;
}

- (UILabel*)placesLabel {
    if (!_placesLabel) {
        _placesLabel = [[UILabel alloc] initWithFrame: self.bounds];
        _placesLabel.font = [UIFont systemFontOfSize: 15.0 weight: UIFontWeightLight];
        _placesLabel.textColor = [UIColor darkGrayColor];
    }
    return _placesLabel;
}

- (UILabel*)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame: self.bounds];
        _dateLabel.font = [UIFont systemFontOfSize: 15.0 weight: UIFontWeightRegular];
    }
    return _dateLabel;
}

@end
