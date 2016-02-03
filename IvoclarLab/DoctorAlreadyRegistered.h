//
//  DoctorAlreadyRegistered.h
//  IvoclarLab
//
//  Created by Subramanyam on 08/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "ViewController.h"
#import "CommonAppManager.h"

@interface DoctorAlreadyRegistered : ViewController<NSXMLParserDelegate,UITextFieldDelegate>


{
  
    NSString * response;
    UIActivityIndicatorView * spinner;
    NSUserDefaults * defaults;

}

@property (weak, nonatomic) IBOutlet UITextField *registeredMobileNoTF;
@property (weak, nonatomic) IBOutlet UITextField *registeredPasswordTF;

@property (weak, nonatomic) IBOutlet UIButton *registeredSubmit;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


- (IBAction)registeredSubmit:(id)sender;

- (IBAction)forgotPassword:(id)sender;

- (IBAction)newUserRegistration:(id)sender;


-(void)connectionData:(NSData*)data status:(BOOL)status;













@end
