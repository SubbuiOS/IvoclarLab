//
//  DoctorLogin.h
//  IvoclarLab
//
//  Created by Mac on 07/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"

@interface DoctorLogin : ViewController<NSXMLParserDelegate,UITextFieldDelegate>
{
    
    NSString *OTPMessage;
    NSString * checkMobile;
    NSURLConnection *theConnection;
    NSMutableData * webData;
    NSString * currentDescription;
    UILabel * tagLabel;

    
}

@property (weak, nonatomic) IBOutlet UITextField *doctorEmailTF;

@property (weak, nonatomic) IBOutlet UITextField *doctorMobileNoTF;

- (IBAction)submitActionDoctor:(id)sender;











@end
