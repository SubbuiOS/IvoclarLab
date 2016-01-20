//
//  PasswordGenarationScreen.m
//  IvoclarLab
//
//  Created by Subramanyam on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "PasswordGenarationScreen.h"
#import "ProfileScreen.h"
#import "SWRevealViewController.h"

@interface PasswordGenarationScreen ()

@end

NSString * filteredDoctorID;

@implementation PasswordGenarationScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _passwordTF.delegate = self;
    _reenterPasswordTF.delegate = self;
    
    
    
    _passwordSubmitOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _passwordSubmitOutlet.clipsToBounds = YES;
    
    // Keyboard will dismiss when user taps on the screen
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
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

-(void) getDocId
{
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
    

}

- (IBAction)passwordSubmit:(id)sender {
    
    
    if ([_passwordTF.text isEqual:@""] || [_reenterPasswordTF.text isEqual:@""]) {
        
        UIAlertView * passwordAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter a password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [passwordAlert show];
        
    }
    else
    {
    
    if ([_passwordTF.text isEqual:_reenterPasswordTF.text]) {
        
        
        [self getDocId];
        
        NSString * updatePassword = [NSString stringWithFormat:
                                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                     "<soap:Body>\n"
                                     "<UpdatePassword xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                     "<DoctorId>%@</DoctorId>\n"
                                     "<Password>%@</Password>\n"
                                     "</UpdatePassword>\n"
                                     "</soap:Body>\n"
                                     "</soap:Envelope>\n",filteredDoctorID,_passwordTF.text];
        
        NSLog(@"updatePWD :%@",updatePassword);
        
        [[CommonAppManager sharedAppManager] soapServiceMessage:updatePassword soapActionString:@"UpdatePassword" withDelegate:self];
        

       
        
//        ProfileScreen * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
//        
//       // [self.revealViewController pushFrontViewController:sideMenu animated:YES];
//        [self presentViewController:sideMenu animated:YES completion:nil];
        
    }
    
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Passwords are not matching..Please enter correctly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        _passwordTF.text = nil;
        _reenterPasswordTF.text= nil;
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
    
    if ([elementName isEqual:@"UpdatePasswordResult"]) {
        
        NSLog(@"valid :%@",response);
        
        if ([response isEqual:@"\"Y\""]) {
            
            
            // Y represents we entered the password saved
            
            UIAlertView * savedPwd = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Password is saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [savedPwd show];

            
            
            SWRevealViewController * profilePage = [self.storyboard instantiateViewControllerWithIdentifier:@"profileSW"];
            // [self.revealViewController pushFrontViewController:profilePage animated:YES];
            [self presentViewController:profilePage animated:YES completion:nil];

           
            
        }
        
        
        
    }
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




@end
