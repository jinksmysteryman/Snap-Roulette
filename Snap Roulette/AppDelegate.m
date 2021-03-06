//
//  AppDelegate.m
//  Snap Roulette
//
//  Created by Jason Fieldman on 2/19/15.
//  Copyright (c) 2015 Jason Fieldman. All rights reserved.
//

#import <FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "AppDelegate.h"
#import "MainSnapViewController.h"
#import "SnapListTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	//[PreloadedSFX initializePreloadedSFX];
	
    /* Parse Activation */
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"mzrtdhojgIK8CdBWhfODDytlsrQRzWOrR7c9Bscf" clientKey:@"b7raZZ1FDwSPRTfbuIhAOT8NdW3jhrizcqKA51nn"];
    [PFFacebookUtils initializeFacebook];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    /* Create window */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MainSnapViewController sharedInstance]];
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *oldToken = [def dataForKey:@"deviceToken"];
    if ([oldToken isEqualToData:deviceToken]) return;
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    if ([PFUser currentUser]) {
        currentInstallation[@"user"] = [PFUser currentUser];
    }
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succ, NSError* err) {
        if (!succ || err) { NSLog(@"reg error: %@", err); return; }
        [def setObject:deviceToken forKey:@"deviceToken"];
        if ([PFUser currentUser]) {
            [def setObject:PFUser.currentUser.objectId forKey:@"curUserID"];
        }
    }];
    NSLog(@"reg token: %@", deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotif" object:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
