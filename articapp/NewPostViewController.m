//
//  NewPostViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 19/11/21.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()

@end

// Extension
@interface NewPostViewController() <UIImagePickerControllerDelegate, UINavigationBarDelegate> {
}

@end

@implementation NewPostViewController

//UIImagePickerController *_imagePicker;
//UIActionSheet *_actionSheet; //show Photo Menu
UIImage *_image;

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


    // TODO: Upload image/video, Add description to it, Post it

- (IBAction)didTapUploadImage:(id)sender {
    
    // Open ImagePickerController
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)didTapUploadVideo:(id)sender {
    // For a future version
}

- (IBAction)didTapCancel:(id)sender {
    // Reset image and description
    _image = nil;
    _uploadImagePreview.image = [UIImage imageNamed:@"placeholder-image"];
    _uploadDescriptionTextBox.text = @"";
}

- (IBAction)didTapPost:(id)sender {
    
    // Show error alert if no image was selected
    if(!_image){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please upload a media." preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { // Button click event
            }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
       
    } else {
        
        NSString *uploadDescription = _uploadDescriptionTextBox.text;
        NSLog(@"Uploading media with description: %@", uploadDescription);
        
        
        
        // Get current user's ID
        NSString *uid = @"";
        FIRUser *user = [FIRAuth auth].currentUser;
        if (user) {
            uid = user.uid;
        } else {
            NSLog(@"Error: user not found.");
        }
        
        // Create a storage reference from our storage service
        FIRStorageReference *storageRef = [[FIRStorage storage] reference];
        
        // Create a child reference (root folder will contain list of folders named after users uid)
        FIRStorageReference *imagesRef = [storageRef child:uid];
        
        // Create randomised unique uid for each image uploaded
        NSString *randomId = [[NSUUID UUID] UUIDString];
        
        // Path for each uploaded image will then be: uid/randomId.jpg
        NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", uid, randomId];
        
        FIRStorageReference *spaceRef = [storageRef child:path];
        
        // Convert the image data to a jpg data
        NSData *imageData = UIImageJPEGRepresentation(_image, 0.75);
        
        // Upload the file to the path "uid/randomId.jpg"
        FIRStorageUploadTask *uploadTask = [spaceRef putData:imageData
                                                     metadata:nil
                                                   completion:^(FIRStorageMetadata *metadata,
                                                                NSError *error) {
          if (error != nil) {
            // Uh-oh, an error occurred!
          } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            int size = metadata.size;
            // You can also access to download URL after upload.
            [spaceRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
              if (error != nil) {
                // Uh-oh, an error occurred!
                  NSLog(@"An error occurred while uploading the image.");
              } else {
                // Image upload successful, also create downloadURL
                NSURL *downloadURL = URL;
                NSLog(@"Image uploaded successfully! downloadURL: %@", downloadURL);
                  
                // Convert URL to String
                NSString *downloadURLString = downloadURL.absoluteString;
                  
                // Add the image in Firestore database in a collection called "images"
                  [[[[[self.db collectionWithPath:@"users"] documentWithPath:uid] collectionWithPath:@"images"] documentWithPath:randomId] setData:@{
                    
                    /*
                     Note: adding the uid again might look redundant, but sometimes I need to get user data
                     knowing only image data (i.e. getting 'username' knowing only the 'image id'). This was the
                     best way I could come up with without re-structuring my entire database.
                     */
                    @"uid": uid,
                    @"downloadUrl": downloadURLString,
                    @"description": uploadDescription
                  } completion:^(NSError * _Nullable error) {
                    if (error != nil) {
                      NSLog(@"Error writing document: %@", error);
                    } else {
                      NSLog(@"Image document successfully added to database!");
                    }
                  }];
                  
                  
                // Also let the user know it was successfull with an alert window
                  
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Image successfully uploaded." preferredStyle:UIAlertControllerStyleAlert];

               UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   
                       // Redirect user to browsing page
                       UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                       UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"BrowseViewController"];
                       vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                       [self presentViewController:vc animated:YES completion:NULL];
                   }];
               [alert addAction:ok];
               [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _image = info[UIImagePickerControllerEditedImage];
    self.uploadImagePreview.image = _image;
    NSLog(@"Image selected: %@", _image);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end





