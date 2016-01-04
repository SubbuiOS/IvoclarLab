//
//  ProfileScreen.h
//  IvoclarLab
//
//  Created by Subramanyam on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"
#import "CommonAppManager.h"

@interface ProfileScreen : ViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate/*,UIPickerViewDelegate,UIPickerViewDataSource*/,UITextFieldDelegate>

{
    
    NSString * response;
    NSString * filteredDoctorID;
    NSData *myData;
    NSMutableDictionary *jsonStatesData;
    NSMutableDictionary * jsonCityData;
    UITableViewCell * cell;
    UITableView * statesTableView;
    UITableView * cityTableView;
    UIActivityIndicatorView * spinner;
    UIView * commonView;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


- (IBAction)profileSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *profileSubmitOutlet;

//@property (weak, nonatomic) IBOutlet UITextField *doctorIDTF;

@property (weak, nonatomic) IBOutlet UITextField *doctorNameTF;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

//@property (weak, nonatomic) IBOutlet UITextField *cityTF;

@property (weak, nonatomic) IBOutlet UITextField *areaNameTF;

@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;

//@property (weak, nonatomic) IBOutlet UITextField *stateNameTF;

- (IBAction)stateDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stateDDOutlet;
- (IBAction)cityDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cityDDOutlet;

@property (weak, nonatomic) IBOutlet UILabel *selectYourStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectYourCityLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *statePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UIView *stateView;

@property (weak, nonatomic) IBOutlet UIView *cityView;



- (void)saveDataInPlist:(NSString *)doctorName;

-(void)connectionData:(NSData*)data status:(BOOL)status;


@end
