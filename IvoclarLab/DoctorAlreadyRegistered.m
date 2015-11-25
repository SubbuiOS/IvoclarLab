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

UIActivityIndicatorView * spinner;

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
    
    SWRevealViewController * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
    
    //[self.revealViewController pushFrontViewController:sideMenu animated:YES];
    
    [self presentViewController:sideMenu animated:YES completion:nil];
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
    
    
    
    [[CommonAppManager sharedAppManager] soapService:forgotPassword url:@"ForgotPassword" withDelegate:self];
    
    
        
    
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
    
}


- (IBAction)newUserRegistration:(id)sender {
}
@end
