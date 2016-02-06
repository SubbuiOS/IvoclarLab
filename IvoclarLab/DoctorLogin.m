//
//  DoctorLogin.m
//  IvoclarLab
//
//  Created by Subramanyam on 07/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
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
    
    
//    defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:@"1" forKey:@"PresentScreen"];
//    [defaults synchronize];
    
    // Customising the navigation Title
    // Taken a view and added a label to it with our required font
  
//    CGRect frame = CGRectMake(0, 0, 200, 44);
//    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
//    navigationTitleView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:25.0];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"Ivoclar Lab";
//    
//    [navigationTitleView addSubview:label];
//    self.navigationItem.titleView = navigationTitleView;
//
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];
    
    
    // Keyboard will dismiss when user taps on the screen
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    _doctorEmailTF.delegate = self;
    _doctorEmailTF.keyboardType = UIKeyboardTypeEmailAddress;
    _doctorMobileNoTF.delegate = self;
    _doctorMobileNoTF.keyboardType = UIKeyboardTypePhonePad;
    
    _doctorLoginSubmit.layer.cornerRadius = 10; // this value vary as per your desire
    _doctorLoginSubmit.clipsToBounds = YES;

    self.titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"Ivoclar Lab";
    
    
    // Navigation bar is customised so we will hide the navigation bar
    self.navigationController.navigationBarHidden = YES;
    
//    _backButtonOutlet.layer.cornerRadius = 10;
//    _backButtonOutlet.clipsToBounds = YES;
   
    
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

-(void)viewWillAppear:(BOOL)animated
{
    _doctorMobileNoTF.text = @"";
    _doctorEmailTF.text = @"";
    
    [self.titleLabel setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:118.0f/255.0f blue:172.0f/255.0f alpha:1]];
    

    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:16.0f/255.0f green:141.0f/255.0f blue:171.0f/255.0f alpha:1];

    _backButtonOutlet.layer.cornerRadius = 6;
    _backButtonOutlet.clipsToBounds = YES;
    
     [_backButtonOutlet setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:52.0/255.0 alpha:1]];
    
    
}

- (IBAction)submitActionDoctor:(id)sender {
    
    
    if ([_doctorEmailTF.text isEqual: @""] || ([_doctorEmailTF.text isEqual:@""])) {
        
        UIAlertView * loginALert = [[UIAlertView alloc]initWithTitle:@"ALERT" message:@"Please enter all the details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [loginALert show];
    }
    
    else
    {
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
                             "<RegId>%@</RegId>\n"
                             "</SendOTP>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",_doctorEmailTF.text,_doctorMobileNoTF.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"]];
        
        
        
        
        
        NSLog(@"device token :%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"]);
    
   // NSLog(@"otp message :%@",OTPMessage);
    // first check the mobile is already registered or not
    
    [self saveDoctorMobileInPlist:_doctorMobileNoTF.text];
    
    // Until data is parsed a spinner is displayed
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake((_doctorLoginSubmit.frame.size.width/2), _doctorLoginSubmit.frame.origin.y+_doctorLoginSubmit.frame.size.height+30);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
    // Getting data from the server using the given url is required every time... So we have taken a class(CommonAppManager) and we are using it everywhere
    
    // Here @"CheckMobile" is the appending String for the respective SOAPAction
    
    [[CommonAppManager sharedAppManager] soapServiceMessage:checkMobile soapActionString:@"CheckMobile" withDelegate:self];
    
    
    }
    
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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}




-(void)connectionData:(NSData*)data status:(BOOL)status
{
    
    // If status is Yes it will parse the data using NSXMLParser
    // If status is NO an alert will be displayed
    
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
    response = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    response= string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqual:@"CheckMobileResponse"])
    {
        
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:_doctorEmailTF.text forKey:@"Email"];
        [defaults synchronize];
        
        NSLog(@"mobile response :%@",response);
        
        
    
        
        
        if ([response isEqual:@"\"Y\""]) {
            
            // Y represents already a registered user
            

            
            [spinner stopAnimating];
            
            DoctorAlreadyRegistered * registeredLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"alreadyRegistered"];
            
            
            [self presentViewController:registeredLogin animated:YES completion:nil];

            
            registeredLogin.registeredMobileNoTF.text = _doctorMobileNoTF.text;
            
            
            //Testing
//            
//            UIAlertView * deviceTokenAlert = [[UIAlertView alloc]initWithTitle:@"DeviceToken" message:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceToken" ]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            
//            [deviceTokenAlert show];
//            
            
            
        }
        
        if ([response isEqual:@"\"N\""]) {
            
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
        NSLog(@" New User doctor id  %@",response);

        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        docIdDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"docidDict :%@",docIdDict);

        //            docIdDict = [NSJSONSerialization JSONObjectWithData:drID options:NSJSONReadingMutableContainers error:nil];
        //            NSLog(@"profile dictionary :%@",docIdDict);
        
        
       // [self saveDataInPlist:[[docIdDict valueForKey:@"DoctorId"]objectAtIndex:0] OTP:[[docIdDict valueForKey:@"OTP"]objectAtIndex:0] doctorMobile:_doctorMobileNoTF.text];
        
        [self saveDataInPlist:[[docIdDict valueForKey:@"DoctorId"]objectAtIndex:0]];
        
        [self saveOTPInPlist:[[docIdDict valueForKey:@"OTP"]objectAtIndex:0]];
        
       //[self saveDataInPlist:[[docIdDict valueForKey:@"DoctorId"]objectAtIndex:0] OTP:[[docIdDict valueForKey:@"OTP"]objectAtIndex:0] doctorMobile:_doctorMobileNoTF.text];
      
        
        //Here we will get doctor ID and OTP as response and we are storing it
        
        
       
    }
    


}

- (void)saveDataInPlist:(id)docID
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
    if ([doctorID length] >0) {
        
        //add values to dictionary
        [data setValue:doctorID forKey:@"DoctorID"];
        
        
        //add dictionary to array
        [contentArray addObject:data];
        
        //write array to plist file
        if([contentArray writeToFile:plistFilePath atomically:YES]){
            
            //NSLog(@"saved");
            
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
        }
        else {
            NSLog(@"Couldn't saved");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
   
}



- (void)saveOTPInPlist:(id)OTP
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
        NSLog(@"File does not exist");
        
        // If the file doesn’t exist, create an empty plist file
        plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
        //NSLog(@"path is %@",plistFilePath);
        
    }
    else{
        NSLog(@"File exists, Get data if anything stored");
        
        contentArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
    }
    
    
    NSString *otp = OTP;
    
    //check all the textfields have values
    if ([otp length] >0) {
        
        //add values to dictionary
        [data setValue:otp forKey:@"OTP"];
        
        
        //add dictionary to array
        [contentArray addObject:data];
        
        //write array to plist file
        if([contentArray writeToFile:plistFilePath atomically:YES]){
            
            //NSLog(@"saved");
            
            //
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //            [alert show];
            
        }
        else {
            NSLog(@"Couldn't saved");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _doctorEmailTF)
    {
        NSString * email = _doctorEmailTF.text;
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL validEmail = [emailTest evaluateWithObject:email];
        
        //NSLog(@"valid email :%i",validEmail);
        if (validEmail==0) {
            
            UIAlertView * validEmailAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter a Valid E-mail id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [validEmailAlert show];
            
            _doctorEmailTF.text = nil;
            
        }

    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)backButton:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
