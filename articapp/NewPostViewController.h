//
//  NewPostViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 19/11/21.
//

#import <UIKit/UIKit.h>

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface NewPostViewController : UIViewController

// Access views
@property (strong, nonatomic) IBOutlet UIImageView *uploadImagePreview;
@property (strong, nonatomic) IBOutlet UITextView *uploadDescriptionTextBox;
// Firebase properties
@property FIRFirestore *db;
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

NS_ASSUME_NONNULL_END
