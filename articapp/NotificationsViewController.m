//
//  NotificationsViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 21/11/21.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()

// Array test
@property (strong, nonatomic) NSArray *arrayNotificationsTest;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Array of comments for testing
    self.arrayNotificationsTest = @[
        @[@"User 1", @"started following you."],
        @[@"User 2", @"left a comment on your photo."],
        @[@"User 3", @"started following you."],
        @[@"User 4", @"favourited your photo."]];
    
    self.notificationsTableView.dataSource = self;
    self.notificationsTableView.delegate = self;
}


#pragma mark - Table view data source

// Number of notifications
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayNotificationsTest count];
}

// Display notifications in cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Access specific table cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    
    // Get data from test array and populate cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", _arrayNotificationsTest[indexPath.row][0], _arrayNotificationsTest[indexPath.row][1]];
    
    // Return the cell
    return cell;
}

// Action when tapping on a cell (might redirect to art detail page or user profile)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"You clicked me");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
