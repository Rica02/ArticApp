//
//  LoginViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 16/11/21.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface LoginViewController : UIViewController

// Access textboxes
@property (strong, nonatomic) IBOutlet UITextField *loginEmailTextBox;
@property (strong, nonatomic) IBOutlet UITextField *loginPasswordTextBox;

@end

