//
//  SignUpViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 16/11/21.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialise Firestore database
    _db = [FIRFirestore firestore];
    
    // Get signed in user's data
    self.handle = [[FIRAuth auth]
        addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
          // ...
        }];
}

// Email validation method
+ (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    NSString *validString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",validString];
    return [emailTest evaluateWithObject:emailAddress];
}

// Sign up button
- (IBAction)didTapSignUp:(id)sender {
    
    // Access textboxes
    NSString *signUpUsername = _signUpUsernameTextBox.text;
    NSString *signUpEmail = _signUpEmailTextBox.text;
    NSString *signUpPassword = _signUpPasswordTextBox.text;
    NSString *signUpConfirmPassword = _signUpConfirmPasswordTextBox.text;
    
    
    // FORM VALIDATION
    
    BOOL isValidForm = false;       // Flag for form validation
    NSString *alertMessage = @"";   // Sets up error message
    
    // Check textboxes aren't empty
    if ( _signUpUsernameTextBox.text.length == 0 || _signUpUsernameTextBox.text.length == 0 || _signUpEmailTextBox.text.length == 0 || _signUpPasswordTextBox.text.length == 0 || _signUpConfirmPasswordTextBox.text.length == 0 ){
        alertMessage = @"You must fill in all fields.";

    // Check if email is in valid format
    } else if (![SignUpViewController isValidEmailAddress:signUpEmail]) {
        alertMessage = @"Email is not valid.";
        
    // Check password is at least 6 characters long
    } else if (_signUpPasswordTextBox.text.length < 6) {
        alertMessage = @"Password must be at least 6 characters long.";
        
    // Check passwords are matching
    } else if(![signUpPassword isEqualToString:signUpConfirmPassword]) {
        alertMessage = @"Passwords do not match.";
        
    // If there is an issue show an alert message
    } else {
        isValidForm = true;
    }
    
    // If form fails validation, show alert displaying corresponding error message
    if(!isValidForm) {
       
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                // Button click event
                            }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        
        // If form passes validation, sign up user to Firebase
        [[FIRAuth auth] createUserWithEmail:signUpEmail
                                   password:signUpPassword
                                 completion:^(FIRAuthDataResult * _Nullable authResult,
                                              NSError * _Nullable error) {
            
            // Print error if unsuccessful, otherwise print email
            if (error != nil) {
                NSLog(@"Error creating user: %@", error);
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Could not register user." preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        // Button click event
                                    }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                NSLog(@"User created with email: %@ and UID: %@", authResult.user.email, authResult.user.uid);
                //uid = authResult.user.uid;
                
                // Also add user in Cloud Firebase database as new document with user id as its id
                [[[self.db collectionWithPath:@"users"] documentWithPath:authResult.user.uid] setData:@{
                    @"username": signUpUsername,
                    @"email": signUpEmail,
                } completion:^(NSError * _Nullable error) {
                  if (error != nil) {
                    NSLog(@"Error writing document: %@", error);
                      
                      
                  } else {
                    NSLog(@"User document successfully added to database!");
                      
                      // Finally redirect user to main page
                      UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                      UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TabBarController"];
                      vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                      [self presentViewController:vc animated:YES completion:NULL];
                  }
                }];
                
            }
        }];
        
        
        

    }
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
