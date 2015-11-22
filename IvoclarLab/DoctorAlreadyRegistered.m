//
//  DoctorAlreadyRegistered.m
//  IvoclarLab
//
//  Created by Mac on 08/11/15.
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
    
    
    // Goes to CaseEntry Screen after submitting
    
    SWRevealViewController * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    
    //[self.revealViewController pushFrontViewController:sideMenu animated:YES];
    
    [self presentViewController:sideMenu animated:YES completion:nil];
}

- (IBAction)forgotPassword:(id)sender {
    
    
   NSString * forgotPassword = [NSString stringWithFormat:
                  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                  "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                  "<soap:Body>\n"
                  "<ForgotPassword xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                  "<Mobile>%@</Mobile>\n"
                  "</ForgotPassword>\n"
                  "</soap:Body>\n"
                  "</soap:Envelope>\n",_registeredMobileNoTF.text];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[forgotPassword length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/ForgotPassword" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
    [theRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [forgotPassword dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    
    //NSLog(@"element names :%@\n\n",elementName);
    
    if ([elementName isEqual:@"ForgotPasswordResult"]) {
        
        NSLog(@"Password :%@",currentDescription);
    }
    
}


- (IBAction)newUserRegistration:(id)sender {
}
@end
