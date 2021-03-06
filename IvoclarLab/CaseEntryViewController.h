//
//  CaseEntryViewController.h
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "ViewController.h"
#import "CommonAppManager.h"
#import "PartnersCustomCell.h"


@interface CaseEntryViewController : ViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UIAlertViewDelegate/*,UIPickerViewDataSource,UIPickerViewDelegate*/>


{
    UITableView * natureOfWorkTV;
    UITableView * crownBrandTV;
    UITableView * typeOfCaseTV;
    UITableView * partnerMTV;
    UITableView * partnerLTV;
  //  UITableView * selectStateTV;
    UITableViewCell * cell;
    
    NSMutableArray * natureOfWorkArray;
    NSMutableArray * crownBrandArray;
    NSMutableArray * typeOfCaseArray;
    NSMutableDictionary * partnerMDict;
    NSMutableDictionary * partnerLDict;
    NSMutableDictionary * profileDetailsDict;
    
    PartnersCustomCell * partnerCell;
    
   // NSUserDefaults * defaults;
   
    NSString * response;
    NSString * filteredDoctorID;
    NSString * filteredDoctorName;
    NSString * updateProfile;
    
    UIAlertView * partnerAlert;
    UIAlertView * submitCEAlert;
    UIAlertView * trackAlert;
    UIAlertView * confirmationAlert;
    UIView * partnerLView;
    UIView * partnerMView;
    UIButton * moreButton;
    UIButton * partnerLButton;
   // UIButton * stateButton;
    
    NSMutableDictionary *data;
    NSMutableArray *contentArray;
    UITapGestureRecognizer * tapRecognizer;

    UIActivityIndicatorView * spinner;
    
    UIView * commonView;
    
    

}

@property NSUInteger index;
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
@property (weak, nonatomic) IBOutlet UIButton *submitOutlet;


@property (weak, nonatomic) IBOutlet UIButton *selectPartnerOutlet;

@property (weak, nonatomic) IBOutlet UILabel *selectNatureOfWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *crownBrandLabel;


@property (weak, nonatomic) IBOutlet UILabel *typeOfCaseLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *crownBrandPicker;

@property (weak, nonatomic) IBOutlet UIPickerView *natureOfWorkPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *typeOfCasePicker;
@property (weak, nonatomic) IBOutlet UIView *natureOfWorkView;

@property (weak, nonatomic) IBOutlet UIView *crownBrandView;
@property (weak, nonatomic) IBOutlet UIView *typeOfCaseView;





-(void)connectionData:(NSData*)data status:(BOOL)status;














//- (IBAction)CESidebarAction:(id)sender;







@end
