//
//  CaseHistory.h
//  IvoclarLab
//
//  Created by Subramanyam on 16/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAppManager.h"
#import "CaseHistoryCustomCell.h"
#import "CHDoctorCustomCell.h"

@interface CaseHistory : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSString * response;
    NSString * filteredDoctorID;
    NSMutableDictionary * CHDict;
    UITableView * caseHistoryTV;
    UIActivityIndicatorView * spinner;
    CHDoctorCustomCell * caseHistoryCell;
}
@property NSUInteger index;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *CHSidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *caseHistoryLabel;


-(void)connectionData:(NSData*)data status:(BOOL)status;


@end
