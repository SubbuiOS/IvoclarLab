//
//  LabCaseHistory.h
//  IvoclarLab
//
//  Created by Subramanyam on 26/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "CommonAppManager.h"
#import "CaseHistoryCustomCell.h"

@interface LabCaseHistory : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>


{
    UITableView * labCaseHistoryTV;
    NSMutableDictionary * caseHistoryDict;
    UIActivityIndicatorView * spinner;
    NSString * filteredLabCaseId;
    NSString * currentDescription;
    NSMutableArray * reqReceivedArray;

}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *labCaseHistorySideMenu;

-(void) getDataFromPlist;

-(void)connectionData:(NSData *)data status:(BOOL)status;



@end
