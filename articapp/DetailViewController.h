//
//  DetailViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 20/11/21.
//

#import <UIKit/UIKit.h>

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// Access components
@property (strong, nonatomic) IBOutlet UILabel *detailUsername;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UITextView *detailDescription;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;

// Firebase properties
@property FIRFirestore *db;


// NOTE: this is not the uid of the currently signed in user, but the uploader of the selected image
@property NSString *uid;
@property NSString *username;
@property NSString *descriptionFB;

// Image attributes (passed by BrowseViewController)
@property NSString *imageId;
@property NSString *downloadUrl;


@end

NS_ASSUME_NONNULL_END
