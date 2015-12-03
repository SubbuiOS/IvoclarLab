//
//  NewUserOTPScreen.m
//  IvoclarLab
//
//  Created by Mac on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "NewUserOTPScreen.h"
#import "PasswordGenarationScreen.h"

@interface NewUserOTPScreen ()

@end


@implementation NewUserOTPScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)OTPSubmit:(id)sender {
    
    
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(170, 400);
    //spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
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
        
       // NSLog(@"Data From Plist: Doctor ID = %@",drID);
    }

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

    
    
    [[CommonAppManager sharedAppManager]soapService:OTPValidation url:@"CheckOTP" withDelegate:self];
    
       
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
    
    if ([elementName isEqual:@"CheckOTPResult"]) {
        
        NSLog(@"valid :%@",currentDescription);
        
        if ([currentDescription isEqual:@"\"Y\""]) {
            
            
            // Y represents we entered the correct OTP
            
            PasswordGenarationScreen * createPWD = [self.storyboard instantiateViewControllerWithIdentifier:@"passwordGeneration"];
            
            [self presentViewController:createPWD animated:YES completion:nil];
            
            
        }
        
        
    }
    
    
    
    
}








@end
