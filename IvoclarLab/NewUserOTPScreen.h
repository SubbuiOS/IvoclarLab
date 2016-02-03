//
//  NewUserOTPScreen.h
//  IvoclarLab
//
//  Created by Subramanyam on 09/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "ViewController.h"
#import "CommonAppManager.h"

@interface NewUserOTPScreen : ViewController<NSXMLParserDelegate,UITextFieldDelegate>


{
    
    NSString * response;
    NSString *filteredDoctorID;
    NSString * filteredOTP;
   // NSMutableDictionary * docIdDict;
    NSTimer * OTPTimer;
    UIActivityIndicatorView * spinner;
    NSUserDefaults * defaults;
    
}
@property (weak, nonatomic) IBOutlet UILabel *OTPReceivingLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *OTPSubmitOutlet;

- (IBAction)OTPSubmit:(id)sender;

//@property (weak, nonatomic) IBOutlet UITextField *doctorIDTF;
@property (weak, nonatomic) IBOutlet UITextField *OTPTF;

-(void)connectionData:(NSData*)data status:(BOOL)status;






@end
