//
//  CaseHistory.m
//  IvoclarLab
//
//  Created by Subramanyam on 16/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "CaseHistory.h"
#import "SWRevealViewController.h"
#import "CaseEntryViewController.h"

@interface CaseHistory ()

@end


@implementation CaseHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self caseHistoryDidLoad];
    
    
}

-(void) caseHistoryDidLoad
{
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.CHSidebarButton setTarget: self.revealViewController];
        [self.CHSidebarButton setAction: @selector( revealToggle: )];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@"RegisteredUser" forKey:@"User"];

    
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
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //    [self.navigationController.navigationBar
    //     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = @"Ivoclar Lab";
    
    
    
    caseHistoryTV = [[UITableView alloc]initWithFrame:CGRectMake(0, _caseHistoryLabel.frame.origin.y+_caseHistoryLabel.frame.size.height+5, _caseHistoryLabel.frame.size.width, self.view.frame.size.height-150) style:UITableViewStylePlain];
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    
}

-(void)viewWillAppear:(BOOL)animated
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
        if ([data objectForKey:@"DoctorID"]) {
            
            NSString *drID = [data objectForKey:@"DoctorID"];
            
            NSLog(@"dr id :%@",drID);
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        }
        
    }
    
    NSString * caseHistory = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<CaseHistory xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</CaseHistory>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:caseHistory soapActionString:@"CaseHistory" withDelegate:self];
    
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
    response = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    response = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqual:@"CaseHistoryResult"]) {
        
       // NSLog(@"case history %@",response);
        
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        CHDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"caseHistory dictionary :%@",CHDict);
        
        
        caseHistoryTV.delegate = self;
        caseHistoryTV.dataSource = self;
        
        [self.view addSubview:caseHistoryTV];
        
        
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CHDict.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //Displaying the Custom Cells
    
    caseHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"caseHistoryCell"];
    if (caseHistoryCell == nil) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CaseHistoryCustomCell" bundle:nil] forCellReuseIdentifier:@"caseHistoryCell"];
        caseHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"caseHistoryCell"];
    }
    
    caseHistoryCell.cellNumberCH.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    
    caseHistoryCell.crownBrandCH.text = [[CHDict valueForKey:@"CrownBrand"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.crownTypeCH.text = [[CHDict valueForKey:@"CrownType"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.issueDateCH.text = [[CHDict valueForKey:@"IssueDate"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.noOfUnitsCH.text = [[CHDict valueForKey:@"NoofUnits"]objectAtIndex:indexPath.row];

    caseHistoryCell.caseIdCH.text = [[CHDict valueForKey:@"CaseId"]objectAtIndex:indexPath.row];

    caseHistoryCell.caseStatusCH.text = [[CHDict valueForKey:@"CaseStatus"]objectAtIndex:indexPath.row];
    
//    caseHistoryCell.doctorNameCH.hidden = YES;
//    caseHistoryCell.docAddressCH.hidden = YES;
//    caseHistoryCell.doctorNameTitle.hidden = YES;
//    caseHistoryCell.addressTitle.hidden = YES;
    
    [caseHistoryCell.doctorNameTitle setText:@"LabName"];
    
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
