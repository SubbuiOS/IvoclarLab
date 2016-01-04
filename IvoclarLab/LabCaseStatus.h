//
//  LabCaseStatus.h
//  IvoclarLab
//
//  Created by Subramanyam on 24/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface LabCaseStatus : UIViewController</*UIPickerViewDataSource,UIPickerViewDelegate,*/NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray * statusArray;
    NSString * filteredlabCaseId;
    NSString * response;
    NSDictionary * labCaseIdDict;
    UIView * commonView;
    
    UITableView * caseStatusTV;
    UITableView * caseIdTV;
    UITableViewCell * cell;
    

}
@property (weak, nonatomic) IBOutlet UIPickerView *statusPicker;
- (IBAction)statusButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *caseStatusSideMenu;

@property (weak, nonatomic) IBOutlet UIPickerView *caseIdPicker;
@property (weak, nonatomic) IBOutlet UILabel *caseIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *caseIdButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *statusButtonOutlet;

- (IBAction)labCaseIdButtonAction:(id)sender;
- (IBAction)submitCaseStatus:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitCaseIdButtonOutlet;

@property (weak, nonatomic) IBOutlet UIView *labCaseStatusView;
@property (weak, nonatomic) IBOutlet UIView *labCaseIdView;



-(void) getDataFromPlist;

-(void)connectionData:(NSData *)data status:(BOOL)status;


@end
