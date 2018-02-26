//
//  ContentViewController.m
//  Ticket
//
//  Created by Артем Б on 21.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* contentLabel;

@end

@implementation ContentViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc]
                      initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0,
                                                [UIScreen mainScreen].bounds.size.height/2 - 100.0,
                                                200.0,
                                                200.0)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 8.0;
        _imageView.clipsToBounds = true;
        [self.view addSubview: _imageView];
        
        _titleLabel = [[UILabel alloc]
                       initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0,
                                                 CGRectGetMinY(_imageView.frame) - 61.0,
                                                 200.0,
                                                 21.0)];
        _titleLabel.font = [UIFont systemFontOfSize: 20.0 weight:UIFontWeightHeavy];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview: _titleLabel];
        
        _contentLabel = [[UILabel alloc]
                       initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0,
                                                 CGRectGetMaxY(_imageView.frame) + 20.0,
                                                 200.0,
                                                 21.0)];
        _titleLabel.font = [UIFont systemFontOfSize: 17.0 weight:UIFontWeightSemibold];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview: _contentLabel];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    float height = heightForText(title, _titleLabel.font, 200.0);
    _titleLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0,
                                   CGRectGetMinY(_imageView.frame) - 40.0 - height,
                                   200.0,
                                   height);
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    _contentLabel.text = contentText;
    float height = heightForText(contentText, _contentLabel.font, 200.0);
    _contentLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0,
                                     CGRectGetMaxY(_imageView.frame) + 20.0,
                                     200.0,
                                     height);
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

float heightForText(NSString* text, UIFont* font, float width) {
    if (text && [text isKindOfClass:[NSString class]]) {
        CGSize size = CGSizeMake(width, FLT_MAX);
        CGRect needLabel = [text boundingRectWithSize:size
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
        return ceilf(needLabel.size.height);
    }
    return 0.0;
}
@end
