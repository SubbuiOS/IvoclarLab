//
//  LabCaseHistory.m
//  IvoclarLab
//
//  Created by Subramanyam on 26/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "LabCaseHistory.h"

@interface LabCaseHistory ()

@end

@implementation LabCaseHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self labCaseHistoryDidLoad];
    
  
    
    
}
-(void) labCaseHistoryDidLoad
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.labCaseHistorySideMenu setTarget: self.revealViewController];
        [self.labCaseHistorySideMenu setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    //self.navigationItem.title = @"Ivoclar lab";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //    [self.navigationController.navigationBar
    //     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];
    
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    //self.navigationItem.title = @"Ivoclar Lab";
    
    
    labCaseHistoryTV= [[UITableView alloc]initWithFrame:CGRectMake(0, _caseHistoryLabel.frame.origin.y+ _caseHistoryLabel.frame.size.height+10, self.view.frame.size.width, 500) style:UITableViewStylePlain];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    reqReceivedArray = [[NSMutableArray alloc]init];
    caseHistoryDict = [[NSMutableDictionary alloc]init];
    
}


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
    
    //print the plist result data on console
    for (int i= 0; i<[contentArray count]; i++) {
        
        data= [contentArray objectAtIndex:i];
        if ([data objectForKey:@"LabPersonID"]) {
            
            
            
            NSString *labID = [data objectForKey:@"LabPersonID"];
            
            NSLog(@"labId without filtering :%@",labID);
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredLabCaseId = [[labID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
            
            NSLog(@"lab id :%@",filteredLabCaseId);
            
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [labCaseHistoryTV reloadData];
    
    [self getDataFromPlist];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString * caseHistory = [NSString stringWithFormat:
                              @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                              "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                              "<soap:Body>\n"
                              "<LabCaseHistory xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                              "<LabId>%@</LabId>\n"
                              "</LabCaseHistory>\n"
                              "</soap:Body>\n"
                              "</soap:Envelope>\n",filteredLabCaseId];
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:caseHistory soapActionString:@"LabCaseHistory" withDelegate:self];
    

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
        
        
        UIAlertView * connectionError = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Error in Connection....Please check your Network Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [connectionError show];
        
        [spinner stopAnimating];

        // Display the previous contents when there is no network.
        
        //Filtering the Request Received case status and storing in an array
        for (int i=0; i<[[defaults objectForKey:@"CaseHistoryLab"]count]; i++) {
            
            if ([[[[defaults objectForKey:@"CaseHistoryLab"]valueForKey:@"CaseStatus"]objectAtIndex:i] isEqual:@"REQUEST RECEIVED"])
            {
                
                NSLog(@"request received default :%@",[[defaults objectForKey:@"CaseHistoryLab"]objectAtIndex:i]);
                
                [reqReceivedArray addObject:[[defaults objectForKey:@"CaseHistoryLab"]objectAtIndex:i]];
                
                NSLog(@"reqRecieved : %@",reqReceivedArray);
            
            }
            
            else
            {
                
                
            }
            
        }

        // Assigning the filtered contents (Only Case Status that are having REQUEST RECEIVED) to caseHistoryDict
        caseHistoryDict =(NSMutableDictionary *) reqReceivedArray;
        
        NSLog(@"no network caseHistory:%@",caseHistoryDict);
        
        labCaseHistoryTV.delegate = self;
        labCaseHistoryTV.dataSource = self;
        
        [self.view addSubview:labCaseHistoryTV];
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
    
    if ([elementName isEqual:@"LabCaseHistoryResult"]) {
        
        NSLog(@"lab login :%@",response);

        // Clearing the NSUserDefaults
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [defaults removePersistentDomainForName:appDomain];
       // NSLog(@"cleared default :%@",[defaults objectForKey:@"CaseHistoryLab"]);

        [reqReceivedArray removeAllObjects];
        
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        
        caseHistoryDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",caseHistoryDict);
        
        
        // Storing in NSUserDefaults and is used when there is no network
        [defaults setObject:caseHistoryDict forKey:@"CaseHistoryLab"];
        [defaults synchronize];
        NSLog(@"defaults: %@",[defaults objectForKey:@"CaseHistoryLab"]);
        
        [defaults setValue:@"LabLoginSuccess" forKey:@"loginStatus"];
        [defaults synchronize];

        labCaseHistoryTV.delegate = self;
        labCaseHistoryTV.dataSource = self;
        
        [self.view addSubview:labCaseHistoryTV];
        
        
        
    }
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return caseHistoryDict.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Displaying the Custom Cells
    
    
    CaseHistoryCustomCell * caseHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"caseHistoryCell"];
    if (caseHistoryCell == nil) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CaseHistoryCustomCell" bundle:nil] forCellReuseIdentifier:@"caseHistoryCell"];
        caseHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"caseHistoryCell"];
    }
    
    caseHistoryCell.cellNumberCH.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    
    caseHistoryCell.doctorNameCH.text = [[caseHistoryDict valueForKey:@"DoctorName"]objectAtIndex:indexPath.row];
    caseHistoryCell.docAddressCH.text = [[caseHistoryDict valueForKey:@"Address"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.crownBrandCH.text = [[caseHistoryDict valueForKey:@"CrownBrand"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.crownTypeCH.text = [[caseHistoryDict valueForKey:@"CrownType"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.issueDateCH.text = [[caseHistoryDict valueForKey:@"IssueDate"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.noOfUnitsCH.text = [[caseHistoryDict valueForKey:@"NoofUnits"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.caseIdCH.text = [[caseHistoryDict valueForKey:@"CaseId"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.caseStatusCH.text = [[caseHistoryDict valueForKey:@"CaseStatus"]objectAtIndex:indexPath.row];
    
    
    return caseHistoryCell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270.00;
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

@end
