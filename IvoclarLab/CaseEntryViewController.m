//
//  CaseEntryViewController.m
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "CaseEntryViewController.h"
#import "SWRevealViewController.h"
#import "PartnersCustomCell.h"
#import "ViewController.h"
#import "CaseHistory.h"

@interface CaseEntryViewController ()

@end

@implementation CaseEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.CESidebarButton setTarget: self.revealViewController];
        [self.CESidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

//    CGRect frame = CGRectMake(0, 0, 200, 44);
//    
//    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
//    navigationTitleView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:25.0];
//    
//    //label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.text = @"Ivoclar Lab";
//    
//    [navigationTitleView addSubview:label];
//    self.navigationItem.titleView = navigationTitleView;
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = @"Ivoclar Lab";
    
    
    _partnerNameLabel.hidden = YES;
    _partnerNameTitle.hidden = YES;
    
    
  //  natureOfWorkTV = [[UITableView alloc]initWithFrame:CGRectMake(33 ,150, 300, 150) style:UITableViewStylePlain];
    
    natureOfWorkArray = [[NSMutableArray alloc]initWithObjects:@"Select Nature Of Work",@"Ceramic",@"PFM",nil];
    
   // crownBrandTV = [[UITableView alloc]initWithFrame:CGRectMake(43 ,190 , 180, 150) style:UITableViewStylePlain];
    
    crownBrandArray = [[NSMutableArray alloc]initWithObjects:@"Zenostar",@"e.max", nil];
    
    
    
    //typeOfCaseTV = [[UITableView alloc]initWithFrame:CGRectMake(33, 290, 200, 150) style:UITableViewStylePlain];
    typeOfCaseArray = [[NSMutableArray alloc]initWithObjects:@"Crowns",@"Bridges",@"Veneer", nil];
    
    
    partnerLbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [partnerLbutton setTitle:@"Cancel" forState:UIControlStateNormal];
    partnerLbutton.frame = CGRectMake(30, 528, 300, 20);
    [partnerLbutton addTarget:self action:@selector(partnerLbuttonIsClicked) forControlEvents:UIControlEventTouchUpInside];
    [partnerLbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [partnerLbutton setBackgroundColor:[UIColor whiteColor]];
    
    //partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, 200, 150) style:UITableViewStylePlain];
    
    //partnerLTV = [[UITableView alloc]initWithFrame:CGRectMake(30, 70, 300, 550) style:UITableViewStylePlain];
    
    
    
    _natureOfWorkPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _natureOfWorkPicker.layer.borderWidth = 1;
    _natureOfWorkPicker.hidden = YES;
    
    _crownBrandPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _crownBrandPicker.layer.borderWidth = 1;
    _crownBrandPicker.hidden = YES;
    
    _typeOfCasePicker.layer.borderColor = [UIColor clearColor].CGColor;
    _typeOfCasePicker.layer.borderWidth = 1;
    _typeOfCasePicker.hidden = YES;

    
    
    
    
    
    
    
    
    
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
        NSLog(@"contant array is %@",contentArray);
        
    }
    
    //print the plist result data on console
    for (int i= 0; i<[contentArray count]; i++) {
        
        data= [contentArray objectAtIndex:i];
        
        if ([data objectForKey:@"DoctorID"])
        {
            
            NSString * drId = [data objectForKey:@"DoctorID"];
        
            NSCharacterSet *invCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drId componentsSeparatedByCharactersInSet:invCharSet]componentsJoinedByString:@""];
            
            
        }
        else if([data objectForKey:@"DoctorName"])
        {
            NSString *drName = [data objectForKey:@"DoctorName"];
        
            NSCharacterSet *invalidCharSet = [[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"""]invertedSet]invertedSet];
            filteredDoctorName = [[drName componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
            
            NSString * appendString = @"Welcome Dr.";
            
            NSString * welcomeString = [appendString stringByAppendingString:filteredDoctorName];
            
        //Appending a string to the Doctor name
            
            _welcomeNameLabel.text = welcomeString;
            NSLog(@"doc name :%@",welcomeString);
        
        }
        
    }

    // Get CaseId using below service
    
    NSString * caseId = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetCaseId xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetCaseId>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    
    [[CommonAppManager sharedAppManager]soapService:caseId url:@"GetCaseId" withDelegate:self];
    
    
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


- (IBAction)natureOfWork:(id)sender {
    
    
//    natureOfWorkTV.hidden = NO;
//    
//    natureOfWorkTV.delegate = self;
//    natureOfWorkTV.dataSource = self;
//    [self.view addSubview:natureOfWorkTV];
    
    
    [_natureOfWorkPicker reloadAllComponents];
    [_natureOfWorkPicker selectRow:0 inComponent:0 animated:YES];
    
    
    _natureOfWorkPicker.hidden = NO;
    
    _natureOfWorkPicker.delegate = self;
    _natureOfWorkPicker.dataSource = self;

    
    _crownBrandDDOutlet.alpha = 0.05;
    _crownBrandLabel.alpha = 0.05;
    _noOfUnitsTF.alpha = 0.05;
    _typeOfCaseOutlet.alpha = 0.05;
    _typeOfCaseLabel.alpha = 0.05;
    
    
    _crownBrandLabel.text = nil;
    
}

- (IBAction)crownBrandDD:(id)sender
{
    
    
    if ([_selectNatureOfWorkLabel.text isEqual:@"Ceramic"]) {
        
//        
//        crownBrandTV.hidden = NO;
//        
//        crownBrandTV.delegate = self;
//        crownBrandTV.dataSource = self;
//        [self.view addSubview:crownBrandTV];
        
        
        [_crownBrandPicker reloadAllComponents];
        [_crownBrandPicker selectRow:0 inComponent:0 animated:YES];
        
        
        _crownBrandPicker.hidden = NO;
        
        _crownBrandPicker.delegate = self;
        _crownBrandPicker.dataSource = self;
        
        
       // _crownBrandDDOutlet.alpha = 0.05;
        //_crownBrandLabel.alpha = 0.05;
        _noOfUnitsTF.alpha = 0.05;
        _typeOfCaseOutlet.alpha = 0.05;
        _typeOfCaseLabel.alpha = 0.05;
        

        
    }
    
}
- (IBAction)typeOfCase:(id)sender {
    
//    typeOfCaseTV.hidden = NO;
//    
//    typeOfCaseTV.delegate = self;
//    typeOfCaseTV.dataSource = self;
//    [self.view addSubview:typeOfCaseTV];
    
    
    [_typeOfCasePicker reloadAllComponents];
    [_typeOfCasePicker selectRow:0 inComponent:0 animated:YES];
    
    
    _typeOfCasePicker.hidden = NO;
    
    _typeOfCasePicker.delegate = self;
    _typeOfCasePicker.dataSource = self;
    
   
    

    
    
}
- (IBAction)selectPartner:(id)sender {
    
    
    //First we will get Mpartners by clicking the button
    
    NSString * MPartner = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetMPartners xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetMPartners>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    [[CommonAppManager sharedAppManager]soapService:MPartner url:@"GetMPartners" withDelegate:self];
    
    
    
}

- (IBAction)submitCaseEntry:(id)sender {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //uncomment to get the time only
    //[formatter setDateFormat:@"hh:mm a"];
    //[formatter setDateFormat:@"MMM dd, YYYY"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    //get the date today
    NSString *dateToday = [formatter stringFromDate:[NSDate date]];
    
    NSString * text = [NSString stringWithFormat:@"Please note that your order has been sent to %@ dates %@ for %@ Bridges.You will be contacted shortly.You are Requested to please click on Received option once your case is delivered to you to close the complete order cycle.",_partnerNameLabel.text, dateToday,_noOfUnitsTF.text];
    
    
     submitCEAlert = [[UIAlertView alloc]initWithTitle:@"Success :" message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [submitCEAlert show];
    
    
    //Insert the cases
    
    NSString * submitCE = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<InsertCases xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "<CrownBrand>%@</CrownBrand>\n"
                          "<NoofUnits>%@</NoofUnits>\n"
                          "<CrownType>%@</CrownType>\n"
                          "<PartnerName>%@</PartnerName>\n"
                          "<CaseId>%@</CaseId>\n"
                          "</InsertCases>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID,_crownBrandLabel.text,_noOfUnitsTF.text,_typeOfCaseLabel.text,_partnerNameLabel.text,_caseIdLabel.text];
    

    [[CommonAppManager sharedAppManager]soapService:submitCE url:@"InsertCases" withDelegate:self];
    
    
    
    
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
    
    if ([elementName isEqual:@"GetCaseIdResult"]) {
        
        NSLog(@"\n\ncase id :%@",currentDescription);
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
        NSString * caseId = [[currentDescription componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        
        _caseIdLabel.text = caseId;
        
    }
    
    if ([elementName isEqual:@"GetMPartnersResult"]) {
        
        NSLog(@"Mpartner :%@",currentDescription);
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        partnerMDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",partnerMDict);
        
        // To Display more Partners we are adding a tableview to the alertView
        
        partnerAlert = [[UIAlertView alloc]initWithTitle:@"Select Partner" message:@"\n" delegate:self cancelButtonTitle:@"More" otherButtonTitles:nil, nil];
        
        partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, 200, 150) style:UITableViewStylePlain];

        
        [partnerAlert setValue:partnerMTV forKey:@"accessoryView"];
    
        partnerMTV.delegate = self;
        partnerMTV.dataSource = self;
        
        [partnerAlert show];
        
    }
    
    if ([elementName isEqual:@"GetLPartnersResult"]) {
        
        NSLog(@"Lpartner: %@",currentDescription);
        
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        partnerLDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",partnerLDict);
        
        
        // Displaying a view consisting of a tableView as a Custom alertView
        
      partnerLView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 800)];
        partnerLView.alpha=1;
        partnerLView.backgroundColor = [UIColor grayColor];
        
        [partnerLView addSubview:partnerLbutton];
        
        partnerLTV = [[UITableView alloc]initWithFrame:CGRectMake(30, 25, 300, 500) style:UITableViewStylePlain];

        [partnerLView addSubview:partnerLTV];
        partnerLTV.delegate = self;
        partnerLTV.dataSource = self;
        
        [self.view addSubview:partnerLView];
        
         //self.view.alpha=0.2;

    }
    
    if ([elementName isEqual:@"InsertCasesResult"]) {
        
        NSLog(@"\n\nInsert cases %@",currentDescription);
        
    }
    
    
    
}

-(void)partnerLbuttonIsClicked
{
    [partnerLView removeFromSuperview];
    //self.view.alpha = 1;
    [partnerMTV removeFromSuperview];
    [partnerLTV removeFromSuperview];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == partnerAlert) {
    
    NSString * LPartner = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetLPartners xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetLPartners>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];

        
        [[CommonAppManager sharedAppManager]soapService:LPartner url:@"GetLPartners" withDelegate:self];
        
    
    }
    else if (alertView == submitCEAlert)
    {
        
        trackAlert = [[UIAlertView alloc]initWithTitle:@"Success :" message:@"You Can Track your case in the Track your case Status menu appearing on the Home Screen" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [trackAlert show];
        
    }
    
    else if (alertView == trackAlert)
    {
        confirmationAlert = [[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Choose here" delegate:self cancelButtonTitle:@"Place another Order" otherButtonTitles:@"Go to Homepage", nil];
        
        [confirmationAlert show];
        
    }
    
    else if(alertView == confirmationAlert)
    {
        if (buttonIndex==0) {
            
            //NSLog(@"title0 %@",[alertView buttonTitleAtIndex:buttonIndex]);
            
            
            // 0 represents Place another Order button is selected
            
            CaseEntryViewController * caseEntry = [self.storyboard instantiateViewControllerWithIdentifier:@"pageControl"];
             [self.revealViewController pushFrontViewController:caseEntry animated:YES];
            
            
        }
        else
        {
           // NSLog(@"title1 %@",[alertView buttonTitleAtIndex:buttonIndex]);
            
            // 1 represents Goto HomePage button is selected
            
            ViewController * homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
            
            [self presentViewController:homePage animated:YES completion:nil];
            
            

        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == partnerMTV)
    {
        return partnerMDict.count;
    }
    else
    {
        return partnerLDict.count+1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Displaying Custom Cells
        
        PartnersCustomCell * partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
        if (partnerCell == nil) {
            
            [tableView registerNib:[UINib nibWithNibName:@"PartnersCustomCell" bundle:nil] forCellReuseIdentifier:@"partnerCell"];
            partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
        }

        
            if (tableView == partnerMTV)
            {
                partnerCell.partnerName.text = [[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:0];
            
                partnerCell.partnerMobile.text = [[partnerMDict valueForKey:@"Mobile"]objectAtIndex:0];
            
                partnerCell.partnerLocation.text = [[partnerMDict valueForKey:@"Address"]objectAtIndex:0];
                    
                
                
            }
            else
            {
                
                
                // First the Mpartner data should be in row 0
                // After that L partners should be displayed
                
                
                if (indexPath.row == 0) {
                    
                    partnerCell.partnerName.text = [[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:0];
                    
                    partnerCell.partnerMobile.text = [[partnerMDict valueForKey:@"Mobile"]objectAtIndex:0];
                    
                    partnerCell.partnerLocation.text = [[partnerMDict valueForKey:@"Address"]objectAtIndex:0];
                }
                else
                {
                    partnerCell.partnerName.text = [[partnerLDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row-1];
                
                    partnerCell.partnerMobile.text = [[partnerLDict valueForKey:@"Mobile"]objectAtIndex:indexPath.row-1];
                
                    partnerCell.partnerLocation.text = [[partnerLDict valueForKey:@"Address"]objectAtIndex:indexPath.row-1];
                    // [partnerCell.partnerLocation sizeToFit];
                    //partnerCell.partnerLocation.numberOfLines=0;
                }
            
                
            }
        
        
        return partnerCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == natureOfWorkTV) {
//        
//        if ([[natureOfWorkArray objectAtIndex:indexPath.row] isEqual:@"PFM"])
//        {
//            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            
//            [alert show];
//            
//            _selectNatureOfWorkLabel.text = @"Select Nature Of Work";
//            
//            [_crownBrandLabel setText:@""];
//            
//        
//            
//        }
//        
//        else
//        {
//           [ _selectNatureOfWorkLabel setText:[natureOfWorkArray objectAtIndex:indexPath.row]];
//            
//            
//            
//        }
//        
//       natureOfWorkTV.hidden = YES;
//
//    }
//    else if (tableView == crownBrandTV)
//    {
//        
//        crownBrandTV.hidden = YES;
//
//        
//        if ([[crownBrandArray objectAtIndex:indexPath.row] isEqual:@"e.max"])
//        {
//            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            
//            [alert show];
//            
//            [_crownBrandLabel setText:@""];
//            
//        }
//        
//        else
//        {
//            
//            [_crownBrandLabel setText:[crownBrandArray objectAtIndex:indexPath.row]];
//        
//        }
//        
//    }
//    
//    else if (tableView == typeOfCaseTV)
//    {
//        [_typeOfCaseLabel setText:[typeOfCaseArray objectAtIndex:indexPath.row]];
//        
//        typeOfCaseTV.hidden = YES;
//
//    }
    
    /*else*/ if(tableView == partnerLTV)
        {
        
        _partnerNameTitle.hidden = NO;
        _partnerNameLabel.hidden = NO;
        if (indexPath.row == 0) {
            
            _partnerNameLabel.text =[[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row];

        }
        
        else
        {
            _partnerNameLabel.text = [[partnerLDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row-1];
        }
        
        
        
        [self partnerLbuttonIsClicked];
        
        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView == partnerLTV) || (tableView == partnerMTV)) {
        return 150.00;

    }
    
    return 45;
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _natureOfWorkPicker)
    {
        return natureOfWorkArray.count;
    }
    else if (pickerView == _crownBrandPicker)
    {
        return crownBrandArray.count;
    }
    
    else
    {
        return typeOfCaseArray.count;
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _natureOfWorkPicker)
    {
        return [natureOfWorkArray objectAtIndex:row];
        
    }
    else if (pickerView == _crownBrandPicker)
    {
        return [crownBrandArray objectAtIndex:row];
        
    }
    else
    {
        return [typeOfCaseArray objectAtIndex:row];
    }
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerViewLabel = (id)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    }
    
    pickerViewLabel.backgroundColor = [UIColor clearColor];
    
    if (pickerView == _natureOfWorkPicker)
    {
        pickerViewLabel.text =[natureOfWorkArray objectAtIndex:row];
        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:17];
        
    }
    else if (pickerView == _crownBrandPicker)

    {
        pickerViewLabel.text =[crownBrandArray objectAtIndex:row];
        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:16];
        
    }
    
    else
    {
        pickerViewLabel.text =[typeOfCaseArray objectAtIndex:row];
        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:17];
    }
    
    return pickerViewLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == _natureOfWorkPicker)
    {
        _selectNatureOfWorkLabel.text =[natureOfWorkArray objectAtIndex:row];
        
        _natureOfWorkPicker.hidden = YES;
        
        _crownBrandDDOutlet.alpha = 1;
        _crownBrandLabel.alpha = 1;
        _noOfUnitsTF.alpha = 1;
        _typeOfCaseOutlet.alpha = 1;
        _typeOfCaseLabel.alpha = 1;
        

        
        if ([[natureOfWorkArray objectAtIndex:row] isEqual:@"PFM"])
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            _selectNatureOfWorkLabel.text = @"Select Nature Of Work";
            
            [_crownBrandLabel setText:@""];
            
            
        }
        
        else
        {
            [ _selectNatureOfWorkLabel setText:[natureOfWorkArray objectAtIndex:row]];
            
        }
        
        
        
        
    }
    else if (pickerView == _crownBrandPicker)
    {
        
        _crownBrandPicker.hidden = YES;
        
       // _crownBrandDDOutlet.alpha = 1;
        //_crownBrandLabel.alpha = 1;
        _noOfUnitsTF.alpha = 1;
        _typeOfCaseOutlet.alpha = 1;
        _typeOfCaseLabel.alpha = 1;

        
        if ([[crownBrandArray objectAtIndex:row] isEqual:@"e.max"])
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            [_crownBrandLabel setText:@""];
            
        }
        
        else
        {
            
            [_crownBrandLabel setText:[crownBrandArray objectAtIndex:row]];
            
        }
        
    }
    
    else if (pickerView == _typeOfCasePicker)
    {
        [_typeOfCaseLabel setText:[typeOfCaseArray objectAtIndex:row]];
        
        _typeOfCasePicker.hidden = YES;
        
    }

    
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












