//
//  TicketCollectionViewController.m
//  Ticket
//
//  Created by Артем Б on 12.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "TicketCollectionViewController.h"
#import "TicketCollectionViewCell.h"

@interface TicketCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray* tickets;

@end

@implementation TicketCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithTickets:(NSArray*)tickets andCollectionViewLayout:(UICollectionViewFlowLayout*)flowLayout{
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        self.tickets = tickets;
        self.title = @"Билеты";
        self.collectionView.backgroundColor = UIColor.whiteColor;
        [self.collectionView registerClass:[TicketCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     Полная реализация UICollectionView, но в UICollectionViewController уже все выполнено
    
     /*
    self.view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    
    UICollectionViewFlowLayout* collectionViewLayout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
      
    
     // Register cell classes
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView registerClass:[TicketCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
      */

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _tickets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.ticket = [self.tickets objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView*)collectionView
                  layout:(nonnull UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/2 - 20.0, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 5.0);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
