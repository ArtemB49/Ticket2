//
//  FirstViewController.m
//  Ticket
//
//  Created by Артем Б on 21.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "FirstViewController.h"
#import "ContentViewController.h"

#define CONTENT_COUNT 4

#define ABOUT_APP_HEAD NSLocalizedString(@"about_app_header", nil)
#define TICKETS_HEAD NSLocalizedString(@"tickets_header", nil)
#define MAP_HEAD NSLocalizedString(@"map_price_header", nil)
#define FAVORITES_HEAD NSLocalizedString(@"favorites_header", nil)
#define ABOUT_APP_DES NSLocalizedString(@"about_app_describle", nil)
#define TICKETS_DES NSLocalizedString(@"tickets_describle", nil)
#define MAP_DES NSLocalizedString(@"map_price_describle", nil)
#define FAVORITES_DES NSLocalizedString(@"favorites_desrible", nil)
#define NEXT_BTN NSLocalizedString(@"next_button", nil)
#define DONE_BTN NSLocalizedString(@"done_button", nil)

@interface FirstViewController ()

@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) UIPageControl* pageControl;

@end

@implementation FirstViewController {
    struct firstContentData {
        __unsafe_unretained NSString* title;
        __unsafe_unretained NSString* contentText;
        __unsafe_unretained NSString* imageName;
    } contentData[CONTENT_COUNT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self createContentDataArray];
    
    self.dataSource = self;
    self.delegate = self;
    
    ContentViewController *startViewController = [self viewControllerAtIndex: 0];
    [self setViewControllers: @[startViewController]
                   direction: UIPageViewControllerNavigationDirectionForward
                    animated: false
                  completion:nil];
    
    _pageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0,
                                                                    self.view.bounds.size.height - 50.0,
                                                                    self.view.bounds.size.width,
                                                                    50.0)];
    _pageControl.numberOfPages = CONTENT_COUNT;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = UIColor.darkGrayColor;
    _pageControl.currentPageIndicatorTintColor = UIColor.blackColor;
    [self.view addSubview: _pageControl];
    
    _nextButton = [UIButton buttonWithType: UIButtonTypeSystem];
    _nextButton.frame = CGRectMake(self.view.bounds.size.width - 100.0,
                                   self.view.bounds.size.height - 50.0,
                                   100.0,
                                   50.0);
    [_nextButton addTarget:self
                    action:@selector(nextButtonDidTap:)
          forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTintColor: UIColor.blackColor];
    [self updateButtonWithIndex: 0];
    [self.view addSubview: _nextButton];
}

- (void)createContentDataArray {
    NSArray* titles = [NSArray arrayWithObjects:
                       ABOUT_APP_HEAD,
                       TICKETS_HEAD,
                       MAP_HEAD,
                       FAVORITES_HEAD,
                       nil];
    
    NSArray* contents = [NSArray arrayWithObjects:
                         ABOUT_APP_DES,
                         TICKETS_DES,
                         MAP_DES,
                         FAVORITES_DES,
                         nil];
    
    for (int i = 0; i < 4; ++i) {
        contentData[i].title = [titles objectAtIndex:i];
        contentData[i].contentText = [contents objectAtIndex:i];
        contentData[i].imageName = [NSString stringWithFormat:@"first_%d", i+1];
    }
}

- (ContentViewController*)viewControllerAtIndex:(int)index {
    if (index<0 || index>=CONTENT_COUNT) {
        return nil;
    }
    
    ContentViewController* contentVC = [ContentViewController new];
    contentVC.title = contentData[index].title;
    contentVC.contentText = contentData[index].contentText;
    contentVC.image = [UIImage imageNamed: contentData[index].imageName];
    contentVC.index = index;
    return contentVC;
}

-(void)updateButtonWithIndex:(int)index{
    switch (index) {
        case 0:
        case 1:
        case 2:
            [_nextButton setTitle: NEXT_BTN forState:UIControlStateNormal];
            _nextButton.tag = 0;
            break;
        case 3:
            [_nextButton setTitle: DONE_BTN forState:UIControlStateNormal];
            _nextButton.tag = 1;
        default:
            break;
    }
}

- (void)nextButtonDidTap:(UIButton*)sender{
    int index = ((ContentViewController*)[self.viewControllers firstObject]).index;
    if (sender.tag) {
        [[NSUserDefaults standardUserDefaults] setBool: true forKey:@"first_start"];
        [self dismissViewControllerAnimated: true completion:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        [self setViewControllers:@[[self viewControllerAtIndex:index+1]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:true
                      completion:^(BOOL finished) {
                          weakSelf.pageControl.currentPage = index+1;
                          [weakSelf updateButtonWithIndex:index+1];
                      }];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = ((ContentViewController*)viewController).index;
    index--;
    return [self viewControllerAtIndex: index];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController {
    int index = ((ContentViewController*)viewController).index;
    index++;
    return [self viewControllerAtIndex: index];
}

@end
