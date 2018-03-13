//
//  TicketsViewController.m
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "TicketsViewController.h"
#import "TicketTVCell.h"
#import "CoreDataHelper.h"
#import "TicketFavorite+CoreDataClass.h"
#import "Ticket.h"
#import "NotificationCenter.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

#define TITLE NSLocalizedString(@"tickets_title", nil)
#define FAVORITE_TITLE NSLocalizedString(@"favorite_tickets_title", nil)
#define BACK_BTN NSLocalizedString(@"back_button", nil)
#define ACTIONS_TITLE NSLocalizedString(@"actions_with_tickets", nil)
#define ACTIONS_MESSAGE NSLocalizedString(@"actions_with_tickets_describle", nil)
#define DELETE_FAVORITE NSLocalizedString(@"remove_from_favorite", nil)
#define ADD_FAVORITE NSLocalizedString(@"add_to_favorite", nil)
#define CLOSE_BTN NSLocalizedString(@"close", nil)
#define REMIND NSLocalizedString(@"remind_me", nil)
#define REMINDER NSLocalizedString(@"ticket_reminder", nil)
#define NOTIFICATION NSLocalizedString(@"notification_will_be_sent", nil)
#define SUCCESS NSLocalizedString(@"success", nil)

@interface TicketsViewController ()

@property (nonatomic, strong) NSArray* tickets;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation TicketsViewController{
    BOOL isFavorites;
    TicketTVCell *notificationCell;
}

- (instancetype)initFavoriteTicketsController{
    self = [super init];
    if (self) {
        isFavorites = true;
        self.tickets = [NSArray new];
        self.title = FAVORITE_TITLE;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTVCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.prefersLargeTitles = true;
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets{
    self = [super init];
    if (self) {
        self.tickets = tickets;
        self.title = TITLE;
        [self.navigationController setNavigationBarHidden:false animated:true];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTVCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        UIBarButtonItem *newBtn = [[UIBarButtonItem alloc] initWithTitle: BACK_BTN style:UIBarButtonItemStylePlain  target: self action:@selector(backButtonDidTap:)];
        self.navigationItem.leftItemsSupplementBackButton = true;
        self.navigationItem.backBarButtonItem = newBtn;
        self.navigationController.navigationBar.prefersLargeTitles = true;
        
        _datePicker = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = true;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [UIToolbar new];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBB, doneBB];
        
        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview:_dateTextField];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = true;
        _tickets = [[CoreDataHelper sharedInstance] favorites];
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
     NSLog(@"viewWillAppear");
    if (!isFavorites) [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewWillDisappear:(BOOL)animated {
     NSLog(@"viewWillDisappear");
    if (!isFavorites) [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)backButtonDidTap:(UIBarButtonItem*)sender{
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketTVCell* cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier
                                                       forIndexPath:indexPath];
    
    if (isFavorites) {
        cell.favorite = [self.tickets objectAtIndex:indexPath.row];
        
    } else {
        Ticket *t = [self.tickets objectAtIndex:indexPath.row];
        cell.ticket = t;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isFavorites) return;
    UIAlertController *alertController
    = [UIAlertController alertControllerWithTitle:ACTIONS_TITLE
                                          message:ACTIONS_MESSAGE
                                   preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite:[_tickets objectAtIndex:indexPath.row]]){
        favoriteAction = [UIAlertAction actionWithTitle:DELETE_FAVORITE
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [[CoreDataHelper sharedInstance]
                                                     removeFromFavorite: [_tickets objectAtIndex:indexPath.row]];
                                                }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:ADD_FAVORITE
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [[CoreDataHelper sharedInstance]
                                                     addToFavorite:[_tickets objectAtIndex:indexPath.row]];
                                                }];
    }
    
    UIAlertAction* notificationAction = [UIAlertAction actionWithTitle:REMIND style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [_dateTextField becomeFirstResponder];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:CLOSE_BTN
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction: favoriteAction];
    [alertController addAction: notificationAction];
    [alertController addAction: cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
    
    
}

- (void)doneButtonDidTap:(UIBarButtonItem*)sender{
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб", notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];
        
        NSURL *imageURL;
        if (notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject] stringByAppendingString: [NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:true];
            }
            imageURL = [NSURL fileURLWithPath: path];
        }
        
        Notification notification = NotificationMake(REMINDER, message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification: notification];
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: SUCCESS message: [NSString stringWithFormat: @"%@ - %@", NOTIFICATION, _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)] ;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CLOSE_BTN style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController: alertController animated: true completion:nil];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:true];
}

@end
