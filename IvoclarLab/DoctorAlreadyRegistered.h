//
//  DoctorAlreadyRegistered.h
//  IvoclarLab
//
//  Created by Subramanyam on 08/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"
#import "CommonAppManager.h"

@interface DoctorAlreadyRegistered : ViewController<NSXMLParserDelegate>


{
    NSURLConnection * urlConnection;
    NSMutableData * webData;
    NSString * currentDescription;
    UIActivityIndicatorView * spinner;


}

@property (weak, nonatomic) IBOutlet UITextField *registeredMobileNoTF;
@property (weak, nonatomic) IBOutlet UITextField *registeredPasswordTF;

- (IBAction)registeredSubmit:(id)sender;

- (IBAction)forgotPassword:(id)sender;

- (IBAction)newUserRegistration:(id)sender;


-(void)connectionData:(NSData*)data status:(BOOL)status;













@end
