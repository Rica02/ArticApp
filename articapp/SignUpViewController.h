//
//  SignUpViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 16/11/21.
//

#import <UIKit/UIKit.h>

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController

// Firebase properties
@property FIRFirestore *db;
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

// Access textboxes
@property (strong, nonatomic) IBOutlet UITextField *signUpUsernameTextBox;
@property (strong, nonatomic) IBOutlet UITextField *signUpEmailTextBox;
@property (strong, nonatomic) IBOutlet UITextField *signUpPasswordTextBox;
@property (strong, nonatomic) IBOutlet UITextField *signUpConfirmPasswordTextBox;

// Email validation method
+ (BOOL)isValidEmailAddress:(NSString *)emailAddress ;

@end

NS_ASSUME_NONNULL_END
