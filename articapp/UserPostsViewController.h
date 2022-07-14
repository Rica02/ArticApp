//
//  UserPostsViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 21/11/21.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface UserPostsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *userTableView;
// Firebase properties
@property FIRFirestore *db;
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;
// To store user & image data
@property NSMutableDictionary *userDictionary;
@property NSString *currentUserId;

@end

NS_ASSUME_NONNULL_END
