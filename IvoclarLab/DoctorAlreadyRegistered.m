//
//  DoctorAlreadyRegistered.m
//  IvoclarLab
//
//  Created by Subramanyam on 08/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
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
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
    navigationTitleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:25.0];
    label.textColor = [UIColor whiteColor];
    label.text = @"Ivoclar Lab";
    
    [navigationTitleView addSubview:label];
    self.navigationItem.titleView = navigationTitleView;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIAlertView * alreadyRegisteredAlert = [[UIAlertView alloc]initWithTitle:@"You are already registered" message:@"Pls Login with the details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alreadyRegisteredAlert show];
    
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
                               "<RegId>-</RegId>\n"
                               "</CheckLogin>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>\n",_registeredMobileNoTF.text,_registeredPasswordTF.text];
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:checkLoginDoctor soapActionString:@"CheckLogin"withDelegate:self];

    

}

- (IBAction)forgotPassword:(id)sender {
    
    
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
    currentDescription = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentDescription = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    [spinner stopAnimating];
    
    //NSLog(@"element names :%@\n\n",elementName);
    
    if ([elementName isEqual:@"ForgotPasswordResult"]) {
        
        NSLog(@"Password :%@",currentDescription);
    }
    
    if ([elementName isEqual:@"CheckLoginResult"]) {
        
        // If the login is success then we will have DoctorId as the response
        
        
        NSLog(@"doctor register login success : %@",currentDescription);
        
       // if (![currentDescription isEqual:@"\"N\""]) {
            
            //[self saveDataInPlist:currentDescription];
        //}
        
        // Goes to CaseEntry Screen after submitting
        
        SWRevealViewController * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
        
        //[self.revealViewController pushFrontViewController:sideMenu animated:YES];
        
        [self presentViewController:sideMenu animated:YES completion:nil];
    }
    
}

//
//- (void)saveDataInPlist:(id)docID {
//    
//    //get the plist document path
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
//    NSMutableArray *contentArray= [[NSMutableArray alloc]init];
//    
//    if (![fileManager fileExistsAtPath: plistFilePath])
//    {
//        NSLog(@"File does not exist");
//        
//        // If the file doesn’t exist, create an empty plist file
//        plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
//        //NSLog(@"path is %@",plistFilePath);
//        
//    }
//    else{
//        NSLog(@"File exists, Get data if anything stored");
//        
//        contentArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
//    }
//    
//    
//    NSString *doctorID = docID;
//    
//    //check all the textfields have values
//    if ([doctorID length] >1) {
//        
//        //add values to dictionary
//        [data setValue:doctorID forKey:@"DoctorID"];
//        
//        //add dictionary to array
//        [contentArray addObject:data];
//        
//        //write array to plist file
//        if([contentArray writeToFile:plistFilePath atomically:YES]){
//            
//            //NSLog(@"saved");
//            
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            
//        }
//        else {
//            NSLog(@"Couldn't saved");
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//    
//}





- (IBAction)newUserRegistration:(id)sender {
}
@end
