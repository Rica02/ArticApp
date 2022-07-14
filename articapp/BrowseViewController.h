//
//  BrowseViewController.h
//  articapp
//
//  Created by Rica Mae Averion on 20/11/21.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface BrowseViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// To access collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
// Firebase properties
@property FIRFirestore *db;
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;
// To store image URLs
@property NSMutableDictionary *imagesDictionary;
//@property NSMutableArray *imagesArray;

@end

NS_ASSUME_NONNULL_END
