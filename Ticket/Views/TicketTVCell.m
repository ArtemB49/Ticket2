//
//  TicketTVCell.m
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "TicketTVCell.h"
#import <YYWebImage/YYWebImage.h>
#import "Ticket.h"

@interface TicketTVCell()

@property (nonatomic, strong) UIImageView* airlineLogoView;
@property (nonatomic, strong) UILabel* priceLabel;
@property (nonatomic, strong) UILabel* placesLabel;
@property (nonatomic, strong) UILabel* dateLabel;

@end

@implementation TicketTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.priceLabel = [[UILabel alloc] initWithFrame: self.bounds];
        self.priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview: self.priceLabel];
        
        self.airlineLogoView = [[UIImageView alloc] initWithFrame: self.bounds];
        self.airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview: self.airlineLogoView];
        
        self.placesLabel = [[UILabel alloc] initWithFrame: self.bounds];
        self.placesLabel.font = [UIFont systemFontOfSize: 15.0 weight: UIFontWeightLight];
        self.placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview: self.placesLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame: self.bounds];
        self.dateLabel.font = [UIFont systemFontOfSize: 15.0 weight: UIFontWeightRegular];
        [self.contentView addSubview: self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentView.frame = CGRectMake(10.0, 10.0, screenWidth - 20.0, self.frame.size.height - 20.0);
    self.priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    self.airlineLogoView.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    self.placesLabel.frame = CGRectMake(10.0, CGRectGetMaxX(self.priceLabel.frame) +16.0, 100.0, 20.0);
    self.dateLabel.frame = CGRectMake(10.0, CGRectGetMaxX(self.placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
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
@end
