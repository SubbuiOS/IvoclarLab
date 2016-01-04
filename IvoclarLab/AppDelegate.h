//
//  AppDelegate.h
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

{
    NSMutableArray * menuArray;
    NSUserDefaults * defaults;
}

@property (strong, nonatomic) UIWindow *window;


@end

