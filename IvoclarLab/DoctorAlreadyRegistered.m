//
//  DoctorAlreadyRegistered.m
//  IvoclarLab
//
//  Created by Subramanyam on 08/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "DoctorAlreadyRegistered.h"
#import "SWRevealViewController.h"


@interface DoctorAlreadyRegistered ()

@end


@implementation DoctorAlreadyRegistered

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Customising the navigation Title
    // Taken a view and added a label to it with our required font
//    CGRect frame = CGRectMake(0, 0, 200, 44);
//    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
//    navigationTitleView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:25.0];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"Ivoclar Lab";
//    
//    [navigationTitleView addSubview:label];
//    self.navigationItem.titleView = navigationTitleView;
//    
//   // self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];
//   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:16.0f/255.0f green:141.0f/255.0f blue:171.0f/255.0f alpha:1];

    
    [self.titleLabel setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:118.0f/255.0f blue:172.0f/255.0f alpha:1]];
    
    
    // Keyboard will dismiss when user taps on the screen
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    _registeredPasswordTF.delegate = self;
    
    _registeredSubmit.layer.cornerRadius = 10; // this value vary as per your desire
    _registeredSubmit.clipsToBounds = YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIAlertView * alreadyRegisteredAlert = [[UIAlertView alloc]initWithTitle:@"You are already registered" message:@"Pls Login with the details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alreadyRegisteredAlert show];
    
    [_backButtonOutlet setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:52.0/255.0 alpha:1]];
    
    _backButtonOutlet.layer.cornerRadius = 6;
    _backButtonOutlet.clipsToBounds = YES;
    
    
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

- (IBAction)registeredSubmit:(id)sender {
    
    
    NSString *checkLoginDoctor = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "<CheckLogin xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                               "<Mobile>%@</Mobile>\n"
                               "<Password>%@</Password>\n"
                               "<RegId>%@</RegId>\n"
                               "</CheckLogin>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>\n",_registeredMobileNoTF.text,_registeredPasswordTF.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"]];
    
    
    NSLog(@"device token :%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"]);
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:checkLoginDoctor soapActionString:@"CheckLogin"withDelegate:self];


    
}

- (IBAction)forgotPassword:(id)sender {
    
    // If user taps on forgot Password, an email will be sent having the password.
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(170, 400);
    //spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
   NSString * forgotPassword = [NSString stringWithFormat:
                  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                  "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                  "<soap:Body>\n"
                  "<ForgotPassword xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                  "<Mobile>%@</Mobile>\n"
                  "</ForgotPassword>\n"
                  "</soap:Body>\n"
                  "</soap:Envelope>\n",_registeredMobileNoTF.text];
    
    
    
    [[CommonAppManager sharedAppManager] soapServiceMessage:forgotPassword soapActionString:@"ForgotPassword" withDelegate:self];
    
    
        
    
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
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
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
    
    //NSLog(@"element names :%@\n\n",elementName);
    
    if ([elementName isEqual:@"ForgotPasswordResult"]) {
        
        NSLog(@"Password :%@",response);
        
        if ([response isEqual:@"\"Y\""]) {
            
            UIAlertView * forgotPasswordAlert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your Password has been sent to your Email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [forgotPasswordAlert show];
        }
        
    }
    
    if ([elementName isEqual:@"CheckLoginResult"]) {
        
        // If the login is success then we will have DoctorId as the response
        
        
        NSLog(@"doctor register login success : %@",response);
    
        
        if (![response isEqual:@"\"N\""]) {
            
            [self saveDataInPlist:response];
            
            
        
        SWRevealViewController * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
        
        //[self.revealViewController pushFrontViewController:sideMenu animated:YES];
        
        [self presentViewController:sideMenu animated:YES completion:nil];
            
        [defaults setObject:@"DocLoginSuccess" forKey:@"loginStatus"];
        [defaults synchronize];
            
//        [defaults setObject:@"alreadyRegistered" forKey:@"User"];
//        [defaults synchronize];
//            
//

        
        }
        
        else
        {
            UIAlertView * passwordAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter the correct password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [passwordAlert show];
            
            // Below id Only for my testing it should be deleted
            
//            [self saveDataInPlist:@"108"];
//             SWRevealViewController * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
//            [self presentViewController:sideMenu animated:YES completion:nil];

        }
        
        // Goes to CaseEntry Screen after submitting
        
       // SWRevealViewController * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
        
        //[self.revealViewController pushFrontViewController:sideMenu animated:YES];
        
//        [self presentViewController:sideMenu animated:YES completion:nil];
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
            
            
           // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
           // [alert show];
            
        }
        else {
            NSLog(@"Couldn't saved");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}


- (IBAction)newUserRegistration:(id)sender {
    
    // For New user it will redirect back to doctor login screen
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}


- (IBAction)backButton:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}



-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}













@end
