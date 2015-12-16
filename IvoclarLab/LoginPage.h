//
//  LoginPage.h
//  IvoclarLab
//
//  Created by Subramanyam on 23/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginPage : UIViewController<UIViewControllerTransitioningDelegate>



- (IBAction)doctorLogin:(id)sender;



- (IBAction)labPersonLogin:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *doctorLoginIcon;



@end
