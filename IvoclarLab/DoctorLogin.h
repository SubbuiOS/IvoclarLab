//
//  DoctorLogin.h
//  IvoclarLab
//
//  Created by Subramanyam on 07/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "ViewController.h"
#import "CommonAppManager.h"

@interface DoctorLogin : ViewController<NSXMLParserDelegate,UITextFieldDelegate>
{
    
    NSString *OTPMessage;
    NSString * checkMobile;
    NSString * response;
    NSMutableDictionary * docIdDict;
    UIActivityIndicatorView *spinner;
   // NSUserDefaults * defaults;
    
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButtonOutlet;
- (IBAction)backButton:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *doctorEmailTF;

@property (weak, nonatomic) IBOutlet UITextField *doctorMobileNoTF;

@property (weak, nonatomic) IBOutlet UIButton *doctorLoginSubmit;

- (IBAction)submitActionDoctor:(id)sender;

-(void)connectionData:(NSData*)data status:(BOOL)status;










@end
