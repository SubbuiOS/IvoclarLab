//
//  CaseEntryViewController.h
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"


@interface CaseEntryViewController : ViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CESidebarButton;

@property (weak, nonatomic) IBOutlet UILabel *partnerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *partnerNameTitle;

@property (weak, nonatomic) IBOutlet UILabel *welcomeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseIdLabel;
- (IBAction)natureOfWork:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *natureOfWorkOutlet;
- (IBAction)crownBrandDD:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *crownBrandDDOutlet;


@property (weak, nonatomic) IBOutlet UITextField *noOfUnitsTF;

- (IBAction)typeOfCase:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *typeOfCaseOutlet;
- (IBAction)selectPartner:(id)sender;
- (IBAction)submitCaseEntry:(id)sender;






//- (IBAction)CESidebarAction:(id)sender;







@end
