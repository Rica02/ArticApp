//
//  UserPostsViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 21/11/21.
//

#import "UserPostsViewController.h"

@interface UserPostsViewController ()

@end

@implementation UserPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
     _currentUserId = user.uid;
    }
    
    // Initialise Firestore database to retrieve image datas
    _db = [FIRFirestore firestore];
    
    // Will use this dictionary to store uid and downloadUrl
    _userDictionary = [[NSMutableDictionary alloc] initWithCapacity: 0];
    
    // Get user's images data from Firebase
    [[self.db collectionGroupWithID:@"images"]
        getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                if([document.data[@"uid"] isEqualToString:self->_currentUserId]){
                    // Get values and store them in dictionary
                    NSString *imageId = document.documentID;
                    NSString *downloadUrl = document.data[@"downloadUrl"];
                    [self->_userDictionary setObject:downloadUrl forKey:imageId];
                    
                    NSLog(@"userDictionary data: %@", self->_userDictionary);
                    
                    [self.userTableView reloadData];
                }
                
               
            }
          }
        }];
}


// NOTE: I could have filled the tableView with test data but decided to use my time for more research until I implement Firebase



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return number of items in dictionary
    return self.userDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Access cell of table
    UITableViewCell *cell = [_userTableView dequeueReusableCellWithIdentifier:@"UserTableCell"];
    
    // Populate cells with dictionary entries
    NSString *imageNo = [_userDictionary allKeys][indexPath.row];
    NSString *downloadUrl = _userDictionary [imageNo];
    
    // Convert the URL from String to Data to get the image
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:downloadUrl]];

    // I had issues accessing components here, but found a solution accessing them with tags that worked for me
    UIImageView *userImage = (UIImageView *)[self.view viewWithTag:345];
    userImage.image = [UIImage imageWithData: imageData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Instantiate DetailViewController
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Pass imageId and downloadUrl from dictionary to DetailViewController
    vc.imageId = [_userDictionary allKeys][indexPath.row];
    vc.downloadUrl = _userDictionary [[_userDictionary allKeys][indexPath.row]];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
