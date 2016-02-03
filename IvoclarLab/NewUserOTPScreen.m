//
//  NewUserOTPScreen.m
//  IvoclarLab
//
//  Created by Subramanyam on 09/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "NewUserOTPScreen.h"
#import "PasswordGenarationScreen.h"

@interface NewUserOTPScreen ()

@end

@implementation NewUserOTPScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Keyboard will dismiss when user taps on the screen
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    _OTPTF.delegate = self;
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"NewUser" forKey:@"User"];
    [defaults synchronize];
    
    [defaults setObject:@"DocLoginSuccess" forKey:@"loginStatus"];
    [defaults synchronize];

    
    _OTPSubmitOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _OTPSubmitOutlet.clipsToBounds = YES;
    
    
//    UIAlertView * OTPAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the OTP sent to Your email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    
//    [OTPAlert show];
    
    
    _OTPReceivingLabel.hidden = NO;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    _OTPTF.text = @"";
    
    [self.titleLabel setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:118.0f/255.0f blue:172.0f/255.0f alpha:1]];
    
    
    _backButtonOutlet.layer.cornerRadius = 6;
    _backButtonOutlet.clipsToBounds = YES;
    
     [_backButtonOutlet setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:52.0/255.0 alpha:1]];

    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self getDataFromPlist];
    
    // Here We are autoFilling the OTP text field so we made the user to wait for 6sec untill the OTP is received
    
    OTPTimer = [NSTimer scheduledTimerWithTimeInterval: 6.0 target:self selector:@selector(loadOTP) userInfo:nil repeats:NO];
    
   // [self performSelector:@selector(loadOTP) withObject:filteredOTP afterDelay:2.0];
    
}

-(void) loadOTP
{
    
    _OTPTF.text = filteredOTP;
    
    
    NSLog(@"otp :%@",_OTPTF.text);
    
    
    _OTPReceivingLabel.hidden = YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) getDataFromPlist

{
    //get the plist document path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSMutableArray *contentArray= [[NSMutableArray alloc]init];
    
    if (![fileManager fileExistsAtPath: plistFilePath])
    {
        NSLog(@"file does not exist");
        
        // If the file doesn’t exist, create an empty plist file
        plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
        
    }
    else{
        
        NSLog(@"File exists, Get data if anything stored");
        contentArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
        NSLog(@"contant array is %@",contentArray);
        
    }
    
    //print the plist result data on console
    for (int i= 0; i<[contentArray count]; i++) {
        
        
        
        data= [contentArray objectAtIndex:i];
        
        if ([data objectForKey:@"DoctorID"]) {
            
            NSString *drID = [data objectForKey:@"DoctorID"];
            
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
            
            //_doctorIDTF.text = filteredDoctorID;
        }
        
        if ([data objectForKey:@"OTP"]) {
            
            NSString *OTP = [data objectForKey:@"OTP"];
            
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredOTP = [[OTP componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
            
            //_doctorIDTF.text = filteredDoctorID;
            
            NSLog(@"filtrered OTP :%@",filteredOTP);
        }
        
        // NSLog(@"Data From Plist: Doctor ID = %@",drID);
    }
}


- (IBAction)OTPSubmit:(id)sender {
    
    
    if ([_OTPTF.text isEqual:@""]) {
        
        UIAlertView * OTPAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter a valid One Time Password(OTP)" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [OTPAlert show];
    }
    
    else
    {
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(170, _OTPSubmitOutlet.frame.size.height+_OTPSubmitOutlet.frame.origin.y+50);
    [self.view addSubview:spinner];
    [spinner startAnimating];
        
        [self getDataFromPlist];
    
 

    // Checking OTP that we entered is valid or not
    
   NSString * OTPValidation =  [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
     "<soap:Body>\n"
     "<CheckOTP xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
     "<DoctorId>%@</DoctorId>\n"
     "<OTP>%@</OTP>\n"
     "</CheckOTP>\n"
     "</soap:Body>\n"
     "</soap:Envelope>\n",filteredDoctorID,_OTPTF.text];
    
    NSLog(@"otp validation:%@",OTPValidation);

    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:OTPValidation soapActionString:@"CheckOTP" withDelegate:self];
    }
       
}
-(void)connectionData:(NSData*)data status:(BOOL)status
{
    
    if (status) {
        
        
        
        NSData *connectionData = data;
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:connectionData];
        
        xmlParser.delegate = self;
        
        [xmlParser parse];
        
        
    }
    else{
        
        
        UIAlertView * connectionError = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Error in Connection....Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [connectionError show];
    }
    
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
        response = [NSString alloc];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
        response = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    [spinner stopAnimating];
    
    if ([elementName isEqual:@"CheckOTPResult"]) {
        
        NSLog(@"valid :%@",response);
        
        if ([response isEqual:@"\"Y\""]) {
            
            
            // Y represents we entered the correct OTP
            
            PasswordGenarationScreen * createPWD = [self.storyboard instantiateViewControllerWithIdentifier:@"passwordGeneration"];
            
            [self presentViewController:createPWD animated:YES completion:nil];
            
            
        }
        
        else
        {
            UIAlertView * wrongOTP = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Check yout OTP and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [wrongOTP show];
            _OTPTF.text = nil;
        }
        
        
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//- (IBAction)resendOTP:(id)sender
//{
//    
//    
//    
//}
//



@end
