//
//  NewUserOTPScreen.h
//  IvoclarLab
//
//  Created by Mac on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"

@interface NewUserOTPScreen : ViewController<NSXMLParserDelegate>


{
    
    NSURLConnection * urlConnection;
    NSMutableData * webData;
    NSString * currentDescription;
    NSString *filteredDoctorID;
    
}

- (IBAction)OTPSubmit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *doctorIDTF;
@property (weak, nonatomic) IBOutlet UITextField *OTPTF;







@end
