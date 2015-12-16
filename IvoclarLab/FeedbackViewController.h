//
//  FeedbackViewController.h
//  IvoclarLab
//
//  Created by Subramanyam on 06/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"

@interface FeedbackViewController : ViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *feedbackSideMenu;

- (IBAction)deliverDropDown:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *deliverDropDownOutlet;
- (IBAction)inTimeDeliverDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *inTimeDeliverDropDownOutlet;

- (IBAction)serviceFeedbackDD:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *serviceFeedbackDDOutlet;
@property (weak, nonatomic) IBOutlet UITextField *commentsFeedback;
- (IBAction)submitFeedBack:(id)sender;























@end
