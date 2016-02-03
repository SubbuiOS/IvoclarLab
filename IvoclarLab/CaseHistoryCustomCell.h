//
//  CaseHistoryCustomCell.h
//  IvoclarLab
//
//  Created by Subramanyam on 17/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseHistoryCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *doctorNameCH;
//@property (weak, nonatomic) IBOutlet UILabel *docAddressCH;
@property (weak, nonatomic) IBOutlet UITextView *docAddressCH;



@property (weak, nonatomic) IBOutlet UILabel *crownBrandCH;
@property (weak, nonatomic) IBOutlet UILabel *noOfUnitsCH;

@property (weak, nonatomic) IBOutlet UILabel *crownTypeCH;

@property (weak, nonatomic) IBOutlet UILabel *issueDateCH;
@property (weak, nonatomic) IBOutlet UILabel *caseIdCH;

@property (weak, nonatomic) IBOutlet UILabel *caseStatusCH;

@property (weak, nonatomic) IBOutlet UILabel *cellNumberCH;


@property (weak, nonatomic) IBOutlet UILabel *doctorNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;







@end
