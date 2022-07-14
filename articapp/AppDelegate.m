//
//  AppDelegate.m
//  articapp
//
//  Created by Rica Mae Averion on 16/11/21.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // CUSTOMISE TAB BAR COLOURS
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed: 0.93 green: 0.95 blue: 0.98 alpha: 1.00]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed: 0.19 green: 0.31 blue: 0.52 alpha: 1.00]];
 
    // Use Firebase library to configure APIs
    [FIRApp configure];
    
    FIRFirestore *defaultFirestore = [FIRFirestore firestore];
    
    FIRStorage *storage = [FIRStorage storage];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
