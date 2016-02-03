//
//  LoginPage.h
//  IvoclarLab
//
//  Created by Subramanyam on 23/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginPage : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



- (IBAction)doctorLogin:(id)sender;



- (IBAction)labPersonLogin:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *backButtonOutlet;


@end
