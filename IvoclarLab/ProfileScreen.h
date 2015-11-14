//
//  ProfileScreen.h
//  IvoclarLab
//
//  Created by Mac on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"

@interface ProfileScreen : ViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


- (IBAction)profileSubmit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *doctorIDTF;

@property (weak, nonatomic) IBOutlet UITextField *doctorNameTF;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UITextField *cityTF;

@property (weak, nonatomic) IBOutlet UITextField *areaNameTF;

@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;

@property (weak, nonatomic) IBOutlet UITextField *stateNameTF;

- (IBAction)stateDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stateDDOutlet;
- (IBAction)cityDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cityDDOutlet;










@end
