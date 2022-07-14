//
//  DetailViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 20/11/21.
//

#import "DetailViewController.h"

@interface DetailViewController ()

// Array test
@property (strong, nonatomic) NSArray *arrayCommentTest;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Array of dummy data comments for testing
    self.arrayCommentTest = @[
        @[@"User 1", @"A sample comment!"],
        @[@"User 2", @"Another sample comment."],
        @[@"User 3", @"This is yet another sample comment..."],
        @[@"User 4", @"Is this a sample comment?"]];
    
    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;
    
    
    // Convert the URL (passed from BrowseViewController from String to Data
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_downloadUrl]];
    
    // Use image Data to populate the imageView
    _detailImageView.image = [UIImage imageWithData: imageData];
    
    // Now I need to get the image's description
    
    // Initialise Firestore database to retrieve data
    _db = [FIRFirestore firestore];
    
    // Get image data from Firebase
    [[self.db collectionGroupWithID:@"images"]
        getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                if([document.documentID isEqualToString:self->_imageId]){
                    // Get field values
                    self->_uid = document.data[@"uid"];   // Note that this isn't the uid of the currently signed in user, but of the uploader of the image selected
                    //self->_descriptionFB = document.data[@"description"];
                    self->_detailDescription.text = document.data[@"description"];
                    
                    // Now get user's username
                    FIRDocumentReference *docRef = [[self.db collectionWithPath:@"users"] documentWithPath:self->_uid];
                    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
                      if (snapshot.exists) {
                          // Get username value
                          self->_detailUsername.text = snapshot.data[@"username"];
                          
                      } else {
                        NSLog(@"Document does not exist");
                      }
                    }];
                }
          }
       }
    }];
}


#pragma mark - Table view data source

// Number of comments
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayCommentTest count];
}

// Display comments at each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Access specific table cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    // Get data from the test array and populate the cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ \t %@", _arrayCommentTest[indexPath.row][0], _arrayCommentTest[indexPath.row][1]];
    
    // Return the cell
    return cell;
}

// Action when tapping on acell
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"You clicked me");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
