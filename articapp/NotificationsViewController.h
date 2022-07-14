//
//  NotificationsViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 21/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *notificationsTableView;

@end

NS_ASSUME_NONNULL_END
