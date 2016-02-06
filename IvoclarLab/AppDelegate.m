//
//  AppDelegate.m
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "AppDelegate.h"
#import "PagingControl.h"
#import "LabCaseStatus.h"
#import "DoctorLogin.h"
#import "DoctorAlreadyRegistered.h"
#import "LoginPage.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[NSThread sleepForTimeInterval:5];
    
   
    // The Launch screen image should display for 5seconds, so we kept the didFinishLaunchingWithOptions method to sleep
    
        sleep(5);
    
    
    
//    
//    if (SYSTEM_VERSION_GREATER_THAN(@"8.1")) {
//        // code here
//        
//        UIAlertView * notSupportedAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Supports iOS below 8.1 version" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        
//        [notSupportedAlert show];
//        
//        return NO;
//
//        
//    }
    
   // else {
    
   // NSSetUncaughtExceptionHandler(&myExceptionHandler);

    
    
    
    //LoginScreen should only come once.
    // So we have saved the login status, once login it will be set to DocLoginSuccess or LabLoginSuccess based on the login
    // So every time it checks for login string when the app is opened and if it is not equal to 0 it will directly open without login screen
    
    
    NSString *loginStatusString = [[NSUserDefaults standardUserDefaults]stringForKey:@"loginStatus"];
   // NSString * presentScreen = [[NSUserDefaults standardUserDefaults] valueForKey:@"PresentScreen"];

    if (loginStatusString.length != 0)
    {
        NSLog(@"login Status %@",loginStatusString);
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

      
        
        if ([loginStatusString isEqual:@"DocLoginSuccess"])
        {
            
//            if ([presentScreen isEqual:@"1"]) {
//                DoctorLogin * doctorLogin = [storyboard instantiateViewControllerWithIdentifier:@"doctorLogin"];
//                
//                self.window.rootViewController = doctorLogin;
//                
//            }
//            
//            if ([presentScreen isEqual:@"3"]) {
            
                SWRevealViewController * pageController = [storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
                
                self.window.rootViewController = pageController;
                
           // }
            
        }
        else if ([loginStatusString isEqual:@"LabLoginSuccess"])
        {
            SWRevealViewController * labCaseStatus = [storyboard instantiateViewControllerWithIdentifier:@"LabSWRevealViewController"];
            
            self.window.rootViewController = labCaseStatus;


        }
       
        self.window.backgroundColor = [UIColor grayColor];
        [self.window makeKeyAndVisible];
    }

    
    // If the login status string value is equal to zero, the app will be opened from the initial view controller which will include login page.
    
    else if (loginStatusString.length == 0)
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc =[storyboard instantiateInitialViewController];
        
        // Set root view controller and make windows visible
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
        
    }
    
    
        NSLog(@"device version :%@",[[UIDevice currentDevice]systemVersion]);


//        if([[UIDevice currentDevice]systemVersion]>=[NSString stringWithFormat:@"8.0"])
//        {
//            
    
            if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
            {
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                                     | UIUserNotificationTypeBadge
                                                                                                     | UIUserNotificationTypeSound) categories:nil];
                [application registerUserNotificationSettings:settings];

            
            }
       // }
    
        
        
//    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//#ifdef __IPHONE_8_0
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
//                                                                                             | UIUserNotificationTypeBadge
//                                                                                             | UIUserNotificationTypeSound) categories:nil];
//        [application registerUserNotificationSettings:settings];
//#endif
  // }
//    else if ([[UIDevice currentDevice]systemVersion]<[NSString stringWithFormat:@"8.0"]) {
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [application registerForRemoteNotificationTypes:notificationTypes];
//    }
    
    
    
    
    
    return YES;
    
    //}

}

//void myExceptionHandler (NSException *exception)
//{
//    NSArray *stack = [exception callStackReturnAddresses];
//    NSLog(@"Stack trace: %@", stack);
//}

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
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString * newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token:%@",newToken);
    [defaults setValue:newToken forKey:@"DeviceToken"];
    [defaults synchronize];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"user info in notifications : %@",userInfo);
    
    
    if (application.applicationState == UIApplicationStateActive)
    {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        NSString *cancelTitle = @"Close";
        NSString *showTitle = @"Show";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ivoclar"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle 
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
    }
    
    else if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground)
    {
        // go to screen relevant to Notification content
    }
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
