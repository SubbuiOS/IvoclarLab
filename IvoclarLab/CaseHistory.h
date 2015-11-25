//
//  CaseHistory.h
//  IvoclarLab
//
//  Created by Mac on 16/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAppManager.h"

@interface CaseHistory : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

{
    
    NSURLConnection * urlConnection;
    NSMutableData * webData;
    NSString * currentDescription;
    NSString * filteredDoctorID;
    NSMutableDictionary * CHDict;
    UITableView * caseHistoryTV;

}
@property NSUInteger index;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *CHSidebarButton;


-(void)connectionData:(NSData*)data status:(BOOL)status;


@end
