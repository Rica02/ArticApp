//
//  HomeViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 21/11/21.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    
    // Initialise Firestore database to retrieve image datas
    _db = [FIRFirestore firestore];
    
    // Will use this dictionary to store uid and downloadUrl
    _homeDictionary = [[NSMutableDictionary alloc] initWithCapacity: 0];
    
    // Get image data from Firebase
    [[self.db collectionGroupWithID:@"images"]
        getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                // Get values and store them in dictionary
                NSString *imageId = document.documentID;
                NSString *downloadUrl = document.data[@"downloadUrl"];
                [self->_homeDictionary setObject:downloadUrl forKey:imageId];
                
                NSLog(@"homeDictionary data: %@", self->_homeDictionary);
                
                [self.homeTableView reloadData];
            }
          }
        }];
}


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
    return self.homeDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Access cell of table
    UITableViewCell *cell = [_homeTableView dequeueReusableCellWithIdentifier:@"HomeTableCell"];
    
    // Populate cells with dictionary entries
    NSString *imageNo = [_homeDictionary allKeys][indexPath.row];
    NSString *downloadUrl = _homeDictionary [imageNo];
    
    // Convert the URL from String to Data to get the image
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:downloadUrl]];

    // I had issues accessing components here, but found a solution accessing them with tags that worked for me
    UIImageView *homeImage = (UIImageView *)[self.view viewWithTag:123];
    homeImage.image = [UIImage imageWithData: imageData];
    
    // Now we need to get the username
    UILabel *homeUsername = (UILabel *)[self.view viewWithTag:234];
    
    // Get data from Firebase
    [[self.db collectionGroupWithID:@"images"]
        getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                if([document.documentID isEqualToString:imageNo]){
                    // Get field values
                    self->_userId = document.data[@"uid"];   // Note that this isn't the uid of the currently signed in user, but of the uploader of the image selected
                   
                    
                    // Now get user's username
                    FIRDocumentReference *docRef = [[self.db collectionWithPath:@"users"] documentWithPath:self->_userId];
                    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
                      if (snapshot.exists) {
                          // Get username value
                          homeUsername.text = snapshot.data[@"username"];
                          
                      } else {
                        NSLog(@"Document does not exist");
                      }
                    }];
                }
          }
       }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Instantiate DetailViewController
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Pass imageId and downloadUrl from dictionary to DetailViewController
    vc.imageId = [_homeDictionary allKeys][indexPath.row];
    vc.downloadUrl = _homeDictionary [[_homeDictionary allKeys][indexPath.row]];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
