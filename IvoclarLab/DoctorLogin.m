//
//  DoctorLogin.m
//  IvoclarLab
//
//  Created by Subramanyam on 07/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "DoctorLogin.h"

#import "DoctorAlreadyRegistered.h"

#import "NewUserOTPScreen.h"


@interface DoctorLogin ()

@end


@implementation DoctorLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Customising the navigation Title
    // Taken a view and added a label to it with our required font
    CGRect frame = CGRectMake(0, 0, 400, 44);
    
    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
    navigationTitleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:25.0];
    label.textColor = [UIColor whiteColor];
    label.text = @"Ivoclar Lab";
    
    [navigationTitleView addSubview:label];
    self.navigationItem.titleView = navigationTitleView;
    
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    _doctorEmailTF.delegate = self;

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

- (IBAction)submitActionDoctor:(id)sender {
    
    
    //Check Mobile string
    
    checkMobile = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CheckMobile xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                             "<Mobile>%@</Mobile>\n"
                             "</CheckMobile>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",_doctorMobileNoTF.text
                             ];

    
    
    //OTP String
    
    OTPMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<SendOTP xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                             "<Email>%@</Email>\n"
                             "<Mobile>%@</Mobile>\n"
                             "<UserType>Doctor</UserType>\n"
                             "<RegId>-</RegId>\n"
                             "</SendOTP>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",_doctorEmailTF.text,_doctorMobileNoTF.text];
    
    
    // first check the mobile is already registered or not
    
    [self saveDoctorMobileInPlist:_doctorMobileNoTF.text];
    
    // Until data is parsed a spinner is displayed
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(175, 400);
    //spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
    // Getting data from the server using the given url is required every time... So we have taken a class(CommonAppManager) and we are using it everywhere
    
    // Here @"CheckMobile" is the appending String for the respective SOAPAction
    
    [[CommonAppManager sharedAppManager] soapServiceMessage:checkMobile soapActionString:@"CheckMobile" withDelegate:self];
    
    
    
    
}

- (void)saveDoctorMobileInPlist:(NSString *)doctorMobile {
    
    //get the plist document path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSMutableArray *contentArray= [[NSMutableArray alloc]init];
    
    if (![fileManager fileExistsAtPath: plistFilePath])
    {
        NSLog(@"File does not exist");
        
        // If the file doesn’t exist, create an empty plist file
        plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
        //NSLog(@"path is %@",plistFilePath);
        
    }
    else{
        NSLog(@"File exists, Get data if anything stored");
        
        contentArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
    }
    
    
    NSString *docMobile = doctorMobile;
    
    //check all the textfields have values
    if ([docMobile length] >0) {
        
        //add values to dictionary
        [data setValue:docMobile forKey:@"DoctorMobile"];
        
        //add dictionary to array
        [contentArray addObject:data];
        
        //write array to plist file
        if([contentArray writeToFile:plistFilePath atomically:YES]){
            
            //NSLog(@"saved");
            
            
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //            [alert show];
            
        }
        else {
            NSLog(@"Couldn't saved");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
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
        [spinner stopAnimating];
        
        UIAlertView * connectionError = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Error in Connection....Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [connectionError show];
    }
    
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentDescription = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentDescription = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqual:@"CheckMobileResponse"])
    {
        NSLog(@"mobile response :%@",currentDescription);
        
        if ([currentDescription isEqual:@"\"Y\""]) {
            
            // Y represents already a registered user
            
            [spinner stopAnimating];
            
            DoctorAlreadyRegistered * registeredLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"alreadyRegistered"];
            
            
            [self presentViewController:registeredLogin animated:YES completion:nil];
            
            // After successfull login we will get doctorID.
            //[self saveDataInPlist:currentDescription];

            
            registeredLogin.registeredMobileNoTF.text = _doctorMobileNoTF.text;
            
            [defaults setValue:@"DocLoginSuccess" forKey:@"loginStatus"];
            [defaults synchronize];
            
            
            
        }
        
        if ([currentDescription isEqual:@"\"N\""]) {
            
            // N represents new user
            // so OTP should be sent
            
            
            [[CommonAppManager sharedAppManager] soapServiceMessage:OTPMessage soapActionString:@"SendOTP" withDelegate:self];

            
            
        }
    }
    
    if([elementName isEqual: @"SendOTPResult"])
    {
        
        [spinner stopAnimating];
        
        NewUserOTPScreen * OTPScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPScreen"];
        
        [self presentViewController:OTPScreen animated:YES completion:nil];
        
        [self saveDataInPlist:currentDescription];
        
        
        //Here we will get doctor ID in current Description and we are storing it
        
        NSLog(@" present doctor id  %@",currentDescription);
            
       
    }
    


}

- (void)saveDataInPlist:(id)docID {
    
    //get the plist document path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSMutableArray *contentArray= [[NSMutableArray alloc]init];
    
    if (![fileManager fileExistsAtPath: plistFilePath])
    {
        NSLog(@"File does not exist");
        
        // If the file doesn’t exist, create an empty plist file
        plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
        //NSLog(@"path is %@",plistFilePath);
        
    }
    else{
        NSLog(@"File exists, Get data if anything stored");
        
        contentArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
    }
    
    
    NSString *doctorID = docID;
    
    //check all the textfields have values
    if ([doctorID length] >1) {
        
        //add values to dictionary
        [data setValue:doctorID forKey:@"DoctorID"];
        
        //add dictionary to array
        [contentArray addObject:data];
        
        //write array to plist file
        if([contentArray writeToFile:plistFilePath atomically:YES]){
            
            //NSLog(@"saved");
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else {
            NSLog(@"Couldn't saved");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
   
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSString * email = _doctorEmailTF.text;
    
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
       BOOL validEmail = [emailTest evaluateWithObject:email];
    
    //NSLog(@"valid email :%i",validEmail);
    if (validEmail==0) {
        
        UIAlertView * validEmailAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter a valid email id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validEmailAlert show];
        
        _doctorEmailTF.text = nil;
       
    
        
    }
    
    
    
}




@end
