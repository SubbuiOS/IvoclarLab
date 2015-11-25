//
//  ComplaintsScreen.h
//  IvoclarLab
//
//  Created by Mac on 20/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAppManager.h"

@interface ComplaintsScreen : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSMutableArray * complaintTypeArray;
    UITableView * complaintTypeTV;
    UITableView * caseIdTV;
    UITableViewCell * cell;
    BOOL qualityCheckboxSelected;
    BOOL notSatisfiedServiceCheckboxSelected;
    BOOL callBackFromCompanyCheckboxSelected;
    BOOL callBackFromLabCheckboxSelected;
    
    NSString *currentDescription;
    NSMutableData * webData;
    NSURLConnection * urlConnection;
    NSString * filteredDoctorID;
    NSDictionary * caseIdDictionary;
    
    NSString * materialQuality;
    NSString * labService;
    NSString * callBackFromCompany;
    NSString * callBackFromLab;
    
    UITextField * otherComplaints;



}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *complaintsSideMenu;


@property (weak, nonatomic) IBOutlet UITextField *commentsTF;


- (IBAction)complaintTypeDD:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *complaintTypeDDOutlet;

- (IBAction)getCaseIds:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *caseIdDDOutlet;

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UIButton *qualityButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *notSatisfiedServiceLabel;
@property (weak, nonatomic) IBOutlet UIButton *notSatisfiedServiceButtonOutlet;

@property (weak, nonatomic) IBOutlet UILabel *callBackFromCompanyLabel;


@property (weak, nonatomic) IBOutlet UIButton *callBackFromCompanyButtonOutlet;

@property (weak, nonatomic) IBOutlet UILabel *callBackFromLabLabel;

@property (weak, nonatomic) IBOutlet UIButton *callBackFromLabButtonOutlet;
- (IBAction)complaintSubmit:(id)sender;


- (IBAction)qualityButtonAction:(id)sender;
- (IBAction)notSatisfiedServiceButtonAction:(id)sender;
- (IBAction)callBackFromCompanyButtonAction:(id)sender;
- (IBAction)callBackFromLabButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *complaintTypeLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *complaintTypePicker;
@property (weak, nonatomic) IBOutlet UILabel *caseIdLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *caseIdPicker;










-(void)connectionData:(NSData*)data status:(BOOL)status;







@end
