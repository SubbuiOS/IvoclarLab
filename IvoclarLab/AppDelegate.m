//
//  AppDelegate.m
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "AppDelegate.h"
#import "PagingControl.h"
#import "LabCaseStatus.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    
    
    NSString *loginStatusString = [[NSUserDefaults standardUserDefaults]stringForKey:@"loginStatus"];
    if (loginStatusString.length != 0)
    {
        NSLog(@"login Status %@",loginStatusString);
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main.storyboard" bundle:[NSBundle mainBundle]];
        
        if ([loginStatusString isEqual:@"DocLoginSuccess"])
        {
             SWRevealViewController * pageController = [storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
            self.window.rootViewController = pageController;
        }
        else if ([loginStatusString isEqual:@"LabLoginSuccess"])
        {
            SWRevealViewController * labCaseStatus = [storyboard instantiateViewControllerWithIdentifier:@"LabSWRevealViewController"];
            self.window.rootViewController = labCaseStatus;


        }
       
        self.window.backgroundColor = [UIColor grayColor];
        [self.window makeKeyAndVisible];
    }
    
    else if (loginStatusString.length == 0)
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main.storyboard" bundle:[NSBundle mainBundle]];
        UIViewController *vc =[storyboard instantiateInitialViewController];
        
        // Set root view controller and make windows visible
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
        
    }
    
    
    
    
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                             | UIUserNotificationTypeBadge
                                                                                             | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:notificationTypes];
    }
    
    
    
    
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"Device token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
