//
//  LabPersonLogin.m
//  IvoclarLab
//
//  Created by Subramanyam on 23/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "LabPersonLogin.h"

@interface LabPersonLogin ()

@end


@implementation LabPersonLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.navigationItem.title = @"Ivoclar Lab";
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    // Customising the navigation Title
    // Taken a view and added a label to it with our required font
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
    navigationTitleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:25.0];
    label.textColor = [UIColor whiteColor];
    label.text = @"Ivoclar Lab";
    
    [navigationTitleView addSubview:label];
    self.navigationItem.titleView = navigationTitleView;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:71.0f/255.0f green:118.0f/255.0f blue:172.0f/255.0f alpha:1];
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    

    
    _labPersonUserName.delegate = self;
    _labPersonPassword.delegate = self;
    
    // Keyboard will dismiss when user taps on the screen
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    _labLoginSubmit.layer.cornerRadius = 10; // this value vary as per your desire
    _labLoginSubmit.clipsToBounds = YES;
    
//    _labPersonUserName.layer.borderColor=[[UIColor blueColor]CGColor];
//    _labPersonUserName.layer.borderWidth=1.0;
//    
//    _labPersonPassword.layer.borderColor=[[UIColor blueColor]CGColor];
//    _labPersonPassword.layer.borderWidth=1.0;


    
}

- (IBAction)labLoginSubmit:(id)sender
{
    
    if ([_labPersonUserName.text isEqual: @""] || [_labPersonPassword.text isEqual:@""]) {
        
        UIAlertView * loginAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter all the details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [loginAlert show];
    }
    
    else
    {
    NSString * labLoginCheck =  [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<CheckLoginLab xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                 "<Username>%@</Username>\n"
                                 "<Password>%@</Password>\n"
                                 "<RegId>%@</RegId>\n"
                                 "</CheckLoginLab>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n",_labPersonUserName.text,_labPersonPassword.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"]];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake((_labLoginSubmit.frame.size.width/2), _labLoginSubmit.frame.origin.y+_labLoginSubmit.frame.size.height+60);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:labLoginCheck soapActionString:@"CheckLoginLab" withDelegate:self];
    
    }

    
}


-(void)connectionData:(NSData *)data status:(BOOL)status
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
    
    if ([elementName isEqual:@"CheckLoginLabResult"]) {
        
        NSLog(@"lab login :%@",response);
        
        
        
        if (![response isEqual:@"\"N\""]) {
            
        
        [self saveDataInPlist:response];
        
        [defaults setObject:@"LabLoginSuccess" forKey:@"loginStatus"];
        [defaults synchronize];
        
        
        
        SWRevealViewController * labCaseStatus = [self.storyboard instantiateViewControllerWithIdentifier:@"LabSWRevealViewController"];
        
        [self presentViewController:labCaseStatus animated:YES completion:nil];
        
        }
        
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Enter valid login details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            _labPersonUserName.text = @"";
            _labPersonPassword.text = @"";
            
        }
        
        
    }
    
}

-(void) saveDataInPlist:(id) loginId

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
    
    
    NSString *labPersonID = loginId;
    
    //check all the textfields have values
    if ([labPersonID length] >0) {
        
        //add values to dictionary
        [data setValue:labPersonID forKey:@"LabPersonID"];
        
        NSLog(@"lab person ID :%@",[data objectForKey:@"LabPersonID"]);
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
