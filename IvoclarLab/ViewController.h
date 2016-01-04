//
//  ViewController.h
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "LoginPage.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIButton *getStartedButtonOutlet;


- (IBAction)getStartedButtonAction:(id)sender;


@end

