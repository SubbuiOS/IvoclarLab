//
//  CaseHistory.h
//  IvoclarLab
//
//  Created by Subramanyam on 16/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAppManager.h"
#import "CaseHistoryCustomCell.h"

@interface CaseHistory : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

{
    
    NSURLConnection * urlConnection;
    NSMutableData * webData;
    NSString * currentDescription;
    NSString * filteredDoctorID;
    NSMutableDictionary * CHDict;
    UITableView * caseHistoryTV;
    UIActivityIndicatorView * spinner;
    CaseHistoryCustomCell * caseHistoryCell;
}
@property NSUInteger index;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *CHSidebarButton;


-(void)connectionData:(NSData*)data status:(BOOL)status;


@end
