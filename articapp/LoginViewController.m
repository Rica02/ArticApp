//
//  LoginViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 16/11/21.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// Validate login, then go to Home
- (IBAction)didTapLogin:(id)sender {
    
    // FORM VALIDATION
    
    // Check textboxes aren't empty
    if (_loginEmailTextBox.text.length == 0 || _loginPasswordTextBox.text.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You must fill in all fields." preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                // Button click event
                            }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        // Sign in user with Firebase
        [[FIRAuth auth] signInWithEmail:self-> _loginEmailTextBox.text
                               password:self-> _loginPasswordTextBox.text
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
            // Print error if unsuccessful, otherwise print email
            if (error != nil) {
                 NSLog(@"Error signing in: %@", error);
                
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Incorrect credentials." preferredStyle:UIAlertControllerStyleAlert];

                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         // Button click event
                                     }];
                 [alert addAction:ok];
                 [self presentViewController:alert animated:YES completion:nil];
            } else {
                
                NSLog(@"User signed in with email: %@", authResult.user.email);
                
                // When login is successful, redirect to home page
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TabBarController"];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:vc animated:YES completion:NULL];
            }
        }];
    }
}

// For dismissing segue from SignUp view
- (IBAction)unwindToLoginViewController:(UIStoryboardSegue *)unwindSegue
{
}

@end
