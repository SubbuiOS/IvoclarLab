//
//  UpdateMobileScreen.m
//  IvoclarLab
//
//  Created by Subramanyam on 20/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "UpdateMobileScreen.h"
#import "DoctorLogin.h"
#import "DoctorAlreadyRegistered.h"
#import "SWRevealViewController.h"

@interface UpdateMobileScreen ()

@end


@implementation UpdateMobileScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateMobileDidLoad];

    
}

-(void) updateMobileDidLoad
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.updateMobileSideMenu setTarget: self.revealViewController];
        [self.updateMobileSideMenu setAction: @selector( revealToggle: )];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Customising the navigation Title
    // Taken a view and added a label to it with our required font
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
    navigationTitleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, -2, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:25.0];
    label.textColor = [UIColor whiteColor];
    label.text = @"Ivoclar Lab";
    
    [navigationTitleView addSubview:label];
    self.navigationItem.titleView = navigationTitleView;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //    [self.navigationController.navigationBar
    //     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    // self.navigationItem.title = @"Ivoclar Lab";
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self getDataFromPlist];
    
    NSString * getMobileDetails = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "<GetMobileDetails xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                               "<DoctorId>%@</DoctorId>\n"
                               "</GetMobileDetails>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>\n",filteredDoctorID];
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:getMobileDetails soapActionString:@"GetMobileDetails" withDelegate:self];
    
    //NSLog(@"doctor mobile :%@",_mobileNumberTF.text);
    
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

-(void) getDataFromPlist
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
        NSLog(@"content array is %@",contentArray);
        
    }
    NSString *drMobile;
    //print the plist result data on console
    for (int i= 0; i<[contentArray count]; i++) {
        
        data= [contentArray objectAtIndex:i];
        if ([data objectForKey:@"DoctorMobile"]) {
            
            
            
            drMobile = [data objectForKey:@"DoctorMobile"];
            
        }
        //_mobileNumberTF.text = drMobile;

        
        if ([data objectForKey:@"DoctorID"]) {
            
            
            
            NSString *drID = [data objectForKey:@"DoctorID"];
            
            NSLog(@"dr id :%@",drID);
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        }

        
        
    }

    
}


- (IBAction)updateMobile:(id)sender {
 
    
    [self getDataFromPlist];
    
    //Update Profile
    
    NSString * updateMobile = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<UpdateMobile xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "<Mobile>%@</Mobile>\n"
                          "</UpdateMobile>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID,_mobileNumberTF.text];

    [[CommonAppManager sharedAppManager]soapServiceMessage:updateMobile soapActionString:@"UpdateMobile" withDelegate:self];
    
    
       
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
    
    if ([elementName isEqual:@"GetMobileDetailsResult"]) {
        
        NSLog(@"Mobile Number :%@",currentDescription);
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
        filteredDoctorMobile = [[currentDescription componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        
        _mobileNumberTF.text = filteredDoctorMobile;

    }
    
    
    if ([elementName isEqual:@"UpdateMobileResult"]) {
        
        NSLog(@"Status :%@",currentDescription);

    }
}


    
    
    

@end
