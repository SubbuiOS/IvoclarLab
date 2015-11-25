//
//  CaseDelivery.h
//  IvoclarLab
//
//  Created by Mac on 21/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAppManager.h"

@interface CaseDelivery : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


{
    BOOL caseRecievedCheckBoxSelected;
    UITableView * caseIdTV;
    UITableViewCell * cell;
    NSMutableData * webData;
    NSString * currentDescription;
    NSString * filteredDoctorID;
    NSDictionary * caseIdDictionary;
    NSString * caseReceived;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *caseDeliverySideMenu;

@property (weak, nonatomic) IBOutlet UIButton *caseIdDDOutlet;
- (IBAction)caseIdDDAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *caseReceivedButtonOulet;

@property (weak, nonatomic) IBOutlet UILabel *caseReceivedLabel;

- (IBAction)caseReceivedButtonAction:(id)sender;

- (IBAction)confirmCaseDelivery:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmButtonOutlet;

@property (weak, nonatomic) IBOutlet UILabel *caseIdLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *caseIdPicker;



-(void)connectionData:(NSData*)data status:(BOOL)status;










@end
