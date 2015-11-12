//
//  CaseEntryViewController.h
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"

@interface CaseEntryViewController : ViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CESidebarButton;
- (IBAction)dropDownButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dropDownButtonOutlet;









@end
