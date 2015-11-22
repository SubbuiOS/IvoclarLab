//
//  CaseDelivery.h
//  IvoclarLab
//
//  Created by Mac on 21/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseDelivery : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>


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

- (IBAction)caseReceivedButtonAction:(id)sender;

- (IBAction)confirmCaseDelivery:(id)sender;



@end
