//
//  BrowseViewController.m
//  articapp
//
//  Created by Rica Mae Averion on 20/11/21.
//

#import "BrowseViewController.h"
#import "BrowseCollectionViewCell.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialise the collectionView
    [self.collectionView registerNib:[UINib nibWithNibName:@"BrowseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BrowseCell"];
    
    self.collectionView.delegate = self;

    // Initialise Firestore database to retrieve image datas
    _db = [FIRFirestore firestore];
    
    // Dictionary to store images' URLs (with imageId is the respective key)
    _imagesDictionary = [[NSMutableDictionary alloc] initWithCapacity: 0];
    
    // Get image data from Firebase
    [[self.db collectionGroupWithID:@"images"]
        getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                // Get imageId and downloadUrl and store them into the dictionary
                NSString *imageId = document.documentID;
                NSString *downloadUrl = document.data[@"downloadUrl"];
                [self->_imagesDictionary setObject:downloadUrl forKey:imageId];
                
                NSLog(@"imagesDictionary data: %@", self->_imagesDictionary);
                
                // Reload the collectionView
                [self.collectionView reloadData];
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


// Implement methods from protocols using arrayTest as a test

#pragma UICollectionViewDataSource
 
// Number of cells
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesDictionary.count;
}
 
// Display image in each cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Access single cell in collectionView
    BrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrowseCell" forIndexPath:indexPath];

    // Retrieve URLs from dictionary
    NSString *imageNo = [_imagesDictionary allKeys][indexPath.row];
    NSString *downloadUrl = _imagesDictionary [imageNo];
    
    // Convert the URL from String to Data
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:downloadUrl]];
    
    // Use image Data to populate the cell
    cell.browseImageView.image = [UIImage imageWithData: imageData];
    
    //[imageData release];
    
    // Return the cell
    return cell;
}
 
#pragma UICollectionViewDelegate
 
// Action when tapping on a cell (will redirect to the specific image detail page)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate DetailViewController
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Pass imageId and downloadUrl from dictionary to DetailViewController
    vc.imageId = [_imagesDictionary allKeys][indexPath.row];
    vc.downloadUrl = _imagesDictionary [[_imagesDictionary allKeys][indexPath.row]];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma UICollectionViewDelegateFlowLayout

// To stylise the cells (size and dimensions)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Specifies size of cell
    return CGSizeMake(130, 130);
}

@end
