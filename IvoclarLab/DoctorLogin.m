//
//  DoctorLogin.m
//  IvoclarLab
//
//  Created by Mac on 07/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "DoctorLogin.h"

#import "DoctorAlreadyRegistered.h"

#import "NewUserOTPScreen.h"

@interface DoctorLogin ()

@end

NSString *OTPMessage;
NSString * checkMobile;

NSURLConnection *theConnection;

NSMutableData * webData;

NSString * currentDescription;

UILabel * tagLabel;


@implementation DoctorLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

    
    
    
    OTPMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<SendOTP xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                             "<Email>%@</Email>\n"
                             "<Mobile>%@</Mobile>\n"
                             "<UserType>-</UserType>\n"
                             "<RegId>-</RegId>\n"
                             "</SendOTP>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",_doctorEmailTF.text,_doctorMobileNoTF.text];
    
    [self login:checkMobile tag:0];
        
   
   
    
    
}

-(void) login : (NSString * )message tag: (int)tagValue
{
   
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[message length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    if (tagValue == 0)
    {
        [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/CheckMobile" forHTTPHeaderField:@"SOAPAction"];
        
    }
    

    
   else  if(tagValue==1)
    {
        [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/SendOTP" forHTTPHeaderField:@"SOAPAction"];

    }
    
    
    [theRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [message dataUsingEncoding:NSUTF8StringEncoding]];
    
        
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        webData = [NSMutableData data];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    

    
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   // NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    NSString *data = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",data);
    
    NSData *myData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
    
    xmlParser.delegate = self;
    
    [xmlParser parse];
    
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
            
            DoctorAlreadyRegistered * registeredLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"alreadyRegistered"];
            
            
            [self presentViewController:registeredLogin animated:YES completion:nil];
            
            registeredLogin.registeredMobileNoTF.text = _doctorMobileNoTF.text;
            
            
        }
        
        if ([currentDescription isEqual:@"\"N\""]) {
            [self login:OTPMessage tag:1];
            
            
        }
    }
    
    if([elementName isEqual: @"SendOTPResult"])
    {
        
        
        NewUserOTPScreen * OTPScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPScreen"];
        
        [self presentViewController:OTPScreen animated:YES completion:nil];
        
        [self saveDataInPlist:currentDescription];
        
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
