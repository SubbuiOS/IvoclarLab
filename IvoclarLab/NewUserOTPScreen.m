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

NSURLConnection * urlConnection;
NSMutableData * webData;
NSString * currentDescription;
NSString *filteredDoctorID;

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
        NSString *drID = [data objectForKey:@"DoctorID"];
        
        
        
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        
        //_doctorIDTF.text = filteredDoctorID;
        
        
       // NSLog(@"Data From Plist: Doctor ID = %@",drID);
    }

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

    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[OTPValidation length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
        [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/CheckOTP" forHTTPHeaderField:@"SOAPAction"];
   
    
    [theRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [OTPValidation dataUsingEncoding:NSUTF8StringEncoding]];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( urlConnection )
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
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
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
        
       // NSLog(@"%@",data);
        
        NSData *myData = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
        
        xmlParser.delegate = self;
        
        [xmlParser parse];
        
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
    
    if ([elementName isEqual:@"CheckOTPResult"]) {
        
        NSLog(@"valid :%@",currentDescription);
        
        if ([currentDescription isEqual:@"\"Y\""]) {
            
            PasswordGenarationScreen * createPWD = [self.storyboard instantiateViewControllerWithIdentifier:@"passwordGeneration"];
            
            [self presentViewController:createPWD animated:YES completion:nil];
            
            
        }
        
        
    }
    
    
    
    
}








@end
