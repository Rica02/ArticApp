//
//  HomeViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 21/11/21.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// Access views
@property (strong, nonatomic) IBOutlet UITableView *homeTableView;
// Firebase properties
@property FIRFirestore *db;
// To store user & image data
@property NSMutableDictionary *homeDictionary;
@property NSString *userId;

@end

NS_ASSUME_NONNULL_END
