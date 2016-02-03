//
//  CaseEntryViewController.m
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
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
   
//    defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:@"3" forKey:@"PresentScreen"];
//    [defaults synchronize];
    
    [self caseEntryDidLoad];
    

    
    
}

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}
-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [_noOfUnitsTF resignFirstResponder];
}



-(void) caseEntryDidLoad
{
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.CESidebarButton setTarget: self.revealViewController];
        [self.CESidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@"alreadyRegistered" forKey:@"User"];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    
    
    
    
    
    
    _noOfUnitsTF.delegate = self;
    _noOfUnitsTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _partnerNameLabel.hidden = YES;
    _partnerNameTitle.hidden = YES;
    
   
    
    natureOfWorkArray = [[NSMutableArray alloc]initWithObjects:@"Select Nature of Work",@"Ceramic",@"PFM",nil];
    
    
    crownBrandArray = [[NSMutableArray alloc]initWithObjects:@"Select Crown Brand",@"Zenostar",@"e.max", nil];
    

    typeOfCaseArray = [[NSMutableArray alloc]initWithObjects:@"Type of Case",@"Crowns",@"Bridges",@"Veneer", nil];
    
    
    // More button will be displayed when the Mpartners are more than 1
    
    moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonIsClicked) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreButton setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    
    // partnerLButton is the cancel button, which will be displayed with LPartners
    
    partnerLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [partnerLButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [partnerLButton addTarget:self action:@selector(partnerLButtonIsClicked) forControlEvents:UIControlEventTouchUpInside];
    [partnerLButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [partnerLButton setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    
//    stateButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    [stateButton setTitle:@"Select State" forState:UIControlStateNormal];
//    [stateButton addTarget:self action:@selector(stateButtonIsClicked) forControlEvents:UIControlEventTouchUpInside];
//    [stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [stateButton setBackgroundImage:[UIImage imageNamed:@"DD2 (1).png"] forState:UIControlStateNormal];
    
    //partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, 200, 150) style:UITableViewStylePlain];
    
    //partnerLTV = [[UITableView alloc]initWithFrame:CGRectMake(30, 70, 300, 550) style:UITableViewStylePlain];
//    
//    _natureOfWorkPicker.hidden = YES;
//    _crownBrandPicker.hidden = YES;
//    _typeOfCasePicker.hidden = YES;
    
    
    
    //   else
//    {
//        _noOfUnitsTF.frame = CGRectMake(20, _crownBrandDDOutlet.frame.size.height+_crownBrandDDOutlet.frame.origin.y+80, 260, 30);
//    }


}


-(void)viewWillAppear:(BOOL)animated
{
    
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // iPad
        
        _selectNatureOfWorkLabel.frame = CGRectMake(_natureOfWorkOutlet.frame.origin.x+130, _natureOfWorkOutlet.frame.origin.y+21, 150, 32);
        
        _crownBrandLabel.frame = CGRectMake(_crownBrandDDOutlet.frame.origin.x+130, _crownBrandDDOutlet.frame.origin.y+21, 150, 32);
        
        _typeOfCaseLabel.frame = CGRectMake(_typeOfCaseOutlet.frame.origin.x+130, _typeOfCaseOutlet.frame.origin.y+21, 150, 32);
    
        _noOfUnitsTF.frame = CGRectMake(_natureOfWorkOutlet.frame.origin.x+100, _crownBrandView.frame.size.height+_crownBrandView.frame.origin.y+30, 440, 50);
        
        
    }

    
    _submitOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _submitOutlet.clipsToBounds = YES;
    
    _selectPartnerOutlet.layer.cornerRadius = 10;
    _selectPartnerOutlet.clipsToBounds = YES;
    
    partnerLButton.layer.cornerRadius = 10; // this value vary as per your desire
    partnerLButton.clipsToBounds = YES;
    
    _noOfUnitsTF.layer.borderColor=[[UIColor blueColor]CGColor];
    _noOfUnitsTF.layer.borderWidth=1.0;

    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    data = [[NSMutableDictionary alloc]init];
    contentArray= [[NSMutableArray alloc]init];
    
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
        
        if ([data objectForKey:@"DoctorID"])
        {
            
            NSString * drId = [data objectForKey:@"DoctorID"];
        
            NSCharacterSet *invCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drId componentsSeparatedByCharactersInSet:invCharSet]componentsJoinedByString:@""];
            
        }
        
    }
    
        // After Login we will get doctor id, by using it we will get the profile details
        
         [self getProfileDetails:filteredDoctorID];
        
    
    

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

    
    [[CommonAppManager sharedAppManager]soapServiceMessage:caseId soapActionString:@"GetCaseId" withDelegate:self];
    
    
}

#pragma mark Get Profile Details

-(void) getProfileDetails : (NSString *) doctorId
{
    
    NSString * getProfileDetails = [NSString stringWithFormat:
                                    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                    "<soap:Body>\n"
                                    "<GetProfileDetails xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                    "<DoctorId>%@</DoctorId>\n"
                                    "</GetProfileDetails>\n"
                                    "</soap:Body>\n"
                                    "</soap:Envelope>\n",doctorId];
    
    
    
    
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:getProfileDetails soapActionString:@"GetProfileDetails" withDelegate:self];
    
}

#pragma mark Update Profile
-(void) updateProfile : (NSDictionary *) updateProfileDict
{
    updateProfile = [NSString stringWithFormat:
                     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                     "<soap:Body>\n"
                     "<UpdateProfile xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                     "<DoctorId>%@</DoctorId>\n"
                     "<DoctorName>%@</DoctorName>\n"
                     "<Email>%@</Email>\n"
                     "<City>%@</City>\n"
                     "<AreaName>%@</AreaName>\n"
                     "<Pincode>%@</Pincode>\n"
                     "<StateName>%@</StateName>\n"
                     "</UpdateProfile>\n"
                     "</soap:Body>\n"
                     "</soap:Envelope>\n",filteredDoctorID,[[updateProfileDict valueForKey:@"DoctorName"]objectAtIndex:0],[[updateProfileDict valueForKey:@"Email"]objectAtIndex:0],[[updateProfileDict valueForKey:@"City"]objectAtIndex:0],[[updateProfileDict valueForKey:@"AreaName"]objectAtIndex:0],[[updateProfileDict valueForKey:@"Pincode"]objectAtIndex:0],[[updateProfileDict valueForKey:@"StateName"]objectAtIndex:0]];
    
    NSLog(@"updateProfile :%@",updateProfile);
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:updateProfile soapActionString:@"UpdateProfile" withDelegate:self];
    
    
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
    
    
    natureOfWorkTV.hidden = NO;
    [natureOfWorkTV removeFromSuperview];
    [commonView removeFromSuperview];
    
   
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        // CommonView is used as a container to hold the tableViews
        
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_natureOfWorkView.frame.origin.x+150, _natureOfWorkView.frame.origin.y+_natureOfWorkView.frame.size.height+140, _natureOfWorkView.frame.size.width, 150)];
        
         natureOfWorkTV = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-320, 130) style:UITableViewStylePlain];
        
        
    }
    
    else
    {
         commonView = [[UIView alloc]initWithFrame:CGRectMake(_natureOfWorkView.frame.origin.x+20, _natureOfWorkView.frame.origin.y+_natureOfWorkView.frame.size.height+81 , _natureOfWorkView.frame.size.width , 150)];
        
         natureOfWorkTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 130) style:UITableViewStylePlain];
    }
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];
    
    [natureOfWorkTV reloadData];

    
      natureOfWorkTV.delegate = self;
    natureOfWorkTV.dataSource = self;
    [commonView addSubview:natureOfWorkTV];
    
    
//    [_natureOfWorkPicker reloadAllComponents];
//    [_natureOfWorkPicker selectRow:0 inComponent:0 animated:YES];
//
//    
//    _natureOfWorkPicker.hidden = NO;
//  
//    //[self.view addSubview:natureOfWorkPicker];
//
//    _natureOfWorkPicker.delegate = self;
//    _natureOfWorkPicker.dataSource = self;
//
//    _natureOfWorkPicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _natureOfWorkPicker.layer.borderWidth = 1;
//    _natureOfWorkPicker.backgroundColor = [UIColor lightGrayColor];
    
    
    _crownBrandDDOutlet.hidden = YES;
    _crownBrandLabel.hidden = YES;
    _noOfUnitsTF.hidden = YES;
    _typeOfCaseOutlet.hidden = YES;
    _typeOfCaseLabel.hidden = YES;
    
    
    _crownBrandLabel.text = nil;
    
}

- (IBAction)crownBrandDD:(id)sender
{
    [commonView removeFromSuperview];
    [crownBrandTV removeFromSuperview];
    
    if ([_selectNatureOfWorkLabel.text isEqual:@"Ceramic"]) {
        
        
        crownBrandTV.hidden = NO;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            
            commonView = [[UIView alloc]initWithFrame:CGRectMake(_crownBrandView.frame.origin.x+140, _crownBrandView.frame.origin.y+_crownBrandView.frame.size.height+140, _crownBrandView.frame.size.width-300, 210)];
            
             crownBrandTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-320, 130) style:UITableViewStylePlain];
            
            
        }
    
        else
        {
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_crownBrandView.frame.origin.x+20, _crownBrandView.frame.origin.y+_crownBrandView.frame.size.height+82 , _crownBrandView.frame.size.width , 210)];
            
             crownBrandTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 130) style:UITableViewStylePlain];
            
        }
        
        commonView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:commonView];
        
        [crownBrandTV reloadData];
        
        
        
       

        crownBrandTV.delegate = self;
        crownBrandTV.dataSource = self;
        [commonView addSubview:crownBrandTV];
        
        
//        [_crownBrandPicker reloadAllComponents];
//        [_crownBrandPicker selectRow:0 inComponent:0 animated:YES];
//        
//        
//        _crownBrandPicker.hidden = NO;
//        
//        _crownBrandPicker.delegate = self;
//        _crownBrandPicker.dataSource = self;
//        
//        
//        _crownBrandPicker.layer.borderColor = [UIColor whiteColor].CGColor;
//        _crownBrandPicker.layer.borderWidth = 1;
//        _crownBrandPicker.backgroundColor = [UIColor lightGrayColor];
        
       // _crownBrandDDOutlet.alpha = 0.05;
        //_crownBrandLabel.alpha = 0.05;
        _noOfUnitsTF.hidden = YES;
        _typeOfCaseOutlet.hidden =YES;
        _typeOfCaseLabel.hidden = YES;
        

        
    }
    
}
- (IBAction)typeOfCase:(id)sender {
    
    typeOfCaseTV.hidden = NO;
    
    [commonView removeFromSuperview];
    [typeOfCaseTV removeFromSuperview];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_typeOfCaseView.frame.origin.x+140, _typeOfCaseView.frame.origin.y+_typeOfCaseView.frame.size.height+140, _typeOfCaseView.frame.size.width-300, 150)];
        
         typeOfCaseTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-320, 130) style:UITableViewStylePlain];
        
        
    }
    
    else
    {
    
    
    commonView = [[UIView alloc]initWithFrame:CGRectMake(_typeOfCaseView.frame.origin.x+20, _typeOfCaseView.frame.origin.y+_typeOfCaseView.frame.size.height+82 , _typeOfCaseView.frame.size.width , 150)];
        
         typeOfCaseTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 130) style:UITableViewStylePlain];
        
    }
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];

    [typeOfCaseTV reloadData];
    
   

    
    typeOfCaseTV.delegate = self;
    typeOfCaseTV.dataSource = self;
    [commonView addSubview:typeOfCaseTV];
    
    
//    [_typeOfCasePicker reloadAllComponents];
//    [_typeOfCasePicker selectRow:0 inComponent:0 animated:YES];
//    
//    _typeOfCasePicker.hidden = NO;
//    _typeOfCasePicker.delegate = self;
//    _typeOfCasePicker.dataSource = self;
//    
//    
//    _typeOfCasePicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _typeOfCasePicker.layer.borderWidth = 1;
//    _typeOfCasePicker.backgroundColor = [UIColor lightGrayColor];


    
}
- (IBAction)selectPartner:(id)sender {
    
    
    moreButton.hidden = NO;
    
    if ([_welcomeNameLabel.text isEqual:@""] || _welcomeNameLabel.text== nil)
    {
        
        UIAlertView * selectPartnerAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Update the profile" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        
        [selectPartnerAlert show];
        
        
    }
    
    else
    {
    
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
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:MPartner soapActionString:@"GetMPartners" withDelegate:self];
    
    }
    
}

- (IBAction)submitCaseEntry:(id)sender {
    
    
    if(([_selectNatureOfWorkLabel.text isEqual:@"Select Nature of Work"]) || (([_crownBrandLabel.text isEqual: @""]|| ([_crownBrandLabel.text isEqual:@"Select Crown Brand"]))) || ([_noOfUnitsTF.text isEqual: @""]) || ([_typeOfCaseLabel.text isEqual: @"Type of Case"]) || ([_partnerNameLabel.text isEqual: @""]) || ([_caseIdLabel.text isEqual:@""]) )
    {
        
        UIAlertView * caseSubmitAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all the details and select a partner" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [caseSubmitAlert show];
        
    }
    else
    {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //uncomment to get the time only
    //[formatter setDateFormat:@"hh:mm a"];
    //[formatter setDateFormat:@"MMM dd, YYYY"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
        
    
    
    //get the date today
    NSString *dateToday = [formatter stringFromDate:[NSDate date]];
    
    NSString * text = [NSString stringWithFormat:@"Please note that your order has been sent to %@ dated %@ for %@Unit(s) of %@ %@.You will be contacted shortly.You are Requested to please click on Received option once your case is delivered to you to close the complete order cycle.",_partnerNameLabel.text, dateToday,_noOfUnitsTF.text,_crownBrandLabel.text,_typeOfCaseLabel.text];
    
    
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
    

    [[CommonAppManager sharedAppManager]soapServiceMessage:submitCE soapActionString:@"InsertCases" withDelegate:self];
    
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
    
    if ([elementName isEqual:@"GetProfileDetailsResult"]) {
        
        NSLog(@"\n\n Profile Details :%@",response);
        
        if ((response!=nil) && ![response isEqual:@"[]"])
        {
            NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
            profileDetailsDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"profile dictionary :%@",profileDetailsDict);
            
            [self updateProfile:profileDetailsDict];
        
        }
        
        if ([response isEqual:@"[]"]) {
            
            // If the user did not enter the profile details at the beginning the profile should be updated.
            
            UIAlertView * profileAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Update the profile" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [profileAlert show];
        }

    }
    if ([elementName isEqual:@"UpdateProfileResult"]) {
        
        NSLog(@"\n\n Update Profile Response :%@",response);
        
        [self saveDocName:[[profileDetailsDict valueForKey:@"DoctorName" ]objectAtIndex:0]];
        [self getDoctorName];

        
        
    }
  
    if ([elementName isEqual:@"GetCaseIdResult"]) {
        
        NSLog(@"\n\ncase id :%@",response);
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
        NSString * caseId = [[response componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        
        _caseIdLabel.text = caseId;
          [self getDoctorName];
        
    }
    
    if ([elementName isEqual:@"GetMPartnersResult"]) {
        
        NSLog(@"Mpartner :%@",response);
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        partnerMDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",partnerMDict);
        
        // To Display more Partners we are adding a tableview to the alertView
        
        // If the MPartners count was 1 alertView will be displayed
        
        if (partnerMDict.count ==1) {
            
            partnerAlert = [[UIAlertView alloc]initWithTitle:@"Select Partner" message:@"\n" delegate:self cancelButtonTitle:@"More" otherButtonTitles:nil, nil];
            
            partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, 200, 150) style:UITableViewStylePlain];
            
            
            [partnerAlert setValue:partnerMTV forKey:@"accessoryView"];
            partnerAlert.delegate = self;
           // [partnerAlert setNeedsLayout];
            partnerMTV.delegate = self;
            partnerMTV.dataSource = self;
            [partnerAlert show];

            
        }
        else
        {
            
//            partnerAlert = [[UIAlertView alloc]initWithTitle:@"Select Partner" message:@"\n" delegate:self cancelButtonTitle:@"More" otherButtonTitles:nil, nil];
//            
//            partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, 200, 150) style:UITableViewStylePlain];
//            
//            
//            [partnerAlert setValue:partnerMTV forKey:@"accessoryView"];
//            partnerAlert.delegate = self;
//            [partnerAlert setNeedsLayout];
//            partnerMTV.delegate = self;
//            partnerMTV.dataSource = self;
//            [partnerAlert show];
            
            // PartnerMView will be displayed when MPartners are more than 1
            
            partnerMView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            //partnerLView.alpha=1;
            //partnerLView.userInteractionEnabled = YES;
            partnerMView.backgroundColor = [UIColor grayColor];
            
            
            partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(partnerMView.frame.origin.x+8, partnerMView.frame.origin.y+8, partnerMView.frame.size.width-15,partnerMView.frame.size.height-42) style:UITableViewStylePlain];
            
            partnerMTV.layer.cornerRadius = 7;
            partnerMTV.clipsToBounds = YES;
            
            moreButton.frame = CGRectMake(partnerMTV.frame.origin.x, partnerMTV.frame.size.height+partnerMTV.frame.origin.y+7, partnerMTV.frame.size.width,25);
            [partnerMView addSubview:moreButton];
            
            // stateButton.frame = CGRectMake(30, partnerLView.frame.origin.y+10, partnerLTV.frame.size.width, 20);
            //[partnerLView addSubview:stateButton];
            
            [self.view addSubview:partnerMView];
            partnerMTV.delegate = self;
            partnerMTV.dataSource = self;
            [partnerMView addSubview:partnerMTV];
            

            


        
            
        }
        
        
    
        
    }
    
    if ([elementName isEqual:@"GetLPartnersResult"]) {
        
        NSLog(@"Lpartner: %@",response);
        
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        partnerLDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",partnerLDict);
        
        
        
        // Displaying a view consisting of a tableView as a Custom alertView
        
      partnerLView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //partnerLView.alpha=1;
        //partnerLView.userInteractionEnabled = YES;
        partnerLView.backgroundColor = [UIColor grayColor];
        
        
       // selectStateTV = [[UITableView alloc]initWithFrame:CGRectMake(partnerLView.frame.origin.x+30, partnerLView.frame.origin.y+5, partnerLView.frame.size.width-50,100) style:UITableViewStylePlain];
    
        
        partnerLTV = [[UITableView alloc]initWithFrame:CGRectMake(partnerLView.frame.origin.x+8, partnerLView.frame.origin.y+8, partnerLView.frame.size.width-15,partnerLView.frame.size.height-42) style:UITableViewStylePlain];
        
        partnerLTV.layer.cornerRadius = 7;
        partnerLTV.clipsToBounds = YES;
        
        partnerLButton.frame = CGRectMake(partnerLTV.frame.origin.x, partnerLTV.frame.size.height+partnerLTV.frame.origin.y+7, partnerLTV.frame.size.width,25);
        [partnerLView addSubview:partnerLButton];
        
       // stateButton.frame = CGRectMake(30, partnerLView.frame.origin.y+10, partnerLTV.frame.size.width, 20);
        //[partnerLView addSubview:stateButton];

        [self.view addSubview:partnerLView];
        partnerLTV.delegate = self;
        partnerLTV.dataSource = self;
        [partnerLView addSubview:partnerLTV];
        
        
        
         //self.view.alpha=0.2;

    }
    
    if ([elementName isEqual:@"InsertCasesResult"]) {
        
        NSLog(@"\n\nInsert cases %@",response);
        
    }
    
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == partnerAlert) {
    
        [partnerLTV reloadData];
        
    NSString * LPartner = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetLPartners xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetLPartners>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];

        [[CommonAppManager sharedAppManager]soapServiceMessage:LPartner soapActionString:@"GetLPartners" withDelegate:self];
       
    
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

//-(void)willPresentAlertView:(UIAlertView *)alertView
//{
//    if(alertView == partnerAlert)
//    {
//        [alertView setFrame:CGRectMake(0, 0, 280, 600)];
//
//    }
//    
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    UIAlertView * memoryAlert = [[UIAlertView alloc]initWithTitle:@"Memory Warning" message:@"Received memory Warning" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [memoryAlert show];
}

#pragma mark TableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == natureOfWorkTV) {
        
        return natureOfWorkArray.count;
    }
    else if (tableView == crownBrandTV)
    {
        return crownBrandArray.count;
    }
    else if (tableView == typeOfCaseTV)
    {
        return typeOfCaseArray.count;
    }
    
    else if (tableView == partnerMTV)
    {
        return partnerMDict.count;
    }
    else
    {
        return partnerLDict.count+partnerMDict.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if ((tableView == partnerMTV) || (tableView == partnerLTV)) {
        
    
    //Displaying Custom Cells
        
      
            if (tableView == partnerMTV)
            {
                
                
                partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
                if (partnerCell == nil) {
                    
                    [tableView registerNib:[UINib nibWithNibName:@"PartnersCustomCell" bundle:nil] forCellReuseIdentifier:@"partnerCell"];
                    partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
                    partnerCell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    
                }
                
                [partnerCell.partnerLocation scrollRangeToVisible:NSMakeRange(0, 0)];

                
                partnerCell.partnerName.text = [[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row];
            
                partnerCell.partnerMobile.text = [[partnerMDict valueForKey:@"Mobile"]objectAtIndex:indexPath.row];
            
                partnerCell.partnerLocation.text = [[partnerMDict valueForKey:@"Address"]objectAtIndex:indexPath.row];
                

                
                
            }
            else if (tableView == partnerLTV)
            {
                
                partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
                if ((partnerCell == nil)|| (indexPath.row<partnerMDict.count)) {
                    
                    [tableView registerNib:[UINib nibWithNibName:@"PartnersCustomCell" bundle:nil] forCellReuseIdentifier:@"partnerCell"];
                    partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
                    partnerCell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    
                }
                
                [partnerCell.partnerLocation scrollRangeToVisible:NSMakeRange(0, 0)];

            
                // First the Mpartner data should be displayed
                // After that L partners should be displayed
                
                NSLog(@"indexpath.row total :%li",(long)indexPath.row);
                NSLog(@"m dict count :%li",(unsigned long)partnerMDict.count);

                if (indexPath.row < partnerMDict.count) {
                    
                    NSLog(@"indexpath.row :%li",(long)indexPath.row);
                    
                    partnerCell.partnerName.text = [[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row];
                    
                    NSLog(@"partner name : %@",partnerCell.partnerName.text);
                    
                    partnerCell.partnerMobile.text = [[partnerMDict valueForKey:@"Mobile"]objectAtIndex:indexPath.row];
                    
                    partnerCell.partnerLocation.text = [[partnerMDict valueForKey:@"Address"]objectAtIndex:indexPath.row];
                    

                }
                
                // When More is clicked PartnerLView and PartnerLTV will be displayed
                // When displaying we should display the Mpartner first and followed by LPartners
                
                
                 if(indexPath.row>=partnerMDict.count)
                    
                {
                    
                    // To avoid the crash when there are no partners we are returning it without displaying anything
                    
                    if ([[[partnerLDict valueForKey:@"PartnerName"] objectAtIndex:indexPath.row-partnerMDict.count] isEqual:nil] || [[[partnerLDict valueForKey:@"PartnerName"] objectAtIndex:indexPath.row-partnerMDict.count] isEqual:@""]) {
                        
                        return partnerCell;
                        
                    }
                    
                    else
                    {
                        
                        NSLog(@"indexpath.row l partner:%li",(long)indexPath.row);
                        
                        // NSLog(@"L ddict :%@",partnerLDict);
                        
                        NSLog(@"partner M dict count :%li",(unsigned long)partnerMDict.count);
                        NSLog(@"L count :%li",(unsigned long)partnerLDict.count);
                        
                        partnerCell.partnerName.text = [[partnerLDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row-partnerMDict.count];
                        
                        NSLog(@"partner name : %@",partnerCell.partnerName.text);
                        
                        
                        partnerCell.partnerMobile.text = [[partnerLDict valueForKey:@"Mobile"]objectAtIndex:indexPath.row-partnerMDict.count];
                        
                        partnerCell.partnerLocation.text = [[partnerLDict valueForKey:@"Address"]objectAtIndex:indexPath.row-partnerMDict.count];
                        // [partnerCell.partnerLocation sizeToFit];
                        //partnerCell.partnerLocation.numberOfLines=0;
                        
                    }
                   
                }
            
                
            }
        
        
        return partnerCell;
    }
    
    
    else
    {
        NSString * identifier = @"normalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
        }
        
        
        if (tableView == natureOfWorkTV)
        {
            cell.textLabel.text =  [natureOfWorkArray objectAtIndex:indexPath.row];
            
        }
        else if (tableView == crownBrandTV)
        {
            cell.textLabel.text = [crownBrandArray objectAtIndex:indexPath.row];
            
        }
        else if(tableView == typeOfCaseTV)
        {
            cell.textLabel.text = [typeOfCaseArray objectAtIndex:indexPath.row];
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:17];

        return cell;
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == partnerMTV) {
        
        _partnerNameLabel.text = [[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row];
        [partnerAlert dismissWithClickedButtonIndex:indexPath.row animated:YES];
        
        _partnerNameTitle.hidden = NO;
        _partnerNameLabel.hidden = NO;
        moreButton.hidden = YES;
        [partnerMView removeFromSuperview];
        [partnerMTV removeFromSuperview];
        
        

    }
    
    if(tableView == partnerLTV)
        {
        
            _partnerNameTitle.hidden = NO;
            _partnerNameLabel.hidden = NO;

        
        if (indexPath.row < partnerMDict.count) {
            
            _partnerNameLabel.text =[[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row];
            
           

        }
        
        else if(indexPath.row>=partnerMDict.count)
        {
            
             if ([[[partnerLDict valueForKey:@"PartnerName"] objectAtIndex:indexPath.row-partnerMDict.count] isEqual:nil] || [[[partnerLDict valueForKey:@"PartnerName"] objectAtIndex:indexPath.row-partnerMDict.count] isEqual:@""])
             {
                 
                 
                 
             }
            
            else
            {
                 _partnerNameLabel.text = [[partnerLDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row-partnerMDict.count];
            }
            
           
        }
        
       
        
        
    }
    
    if (tableView == natureOfWorkTV)
    {
        _selectNatureOfWorkLabel.text =[natureOfWorkArray objectAtIndex:indexPath.row];
        
       // _natureOfWorkPicker.hidden = YES;
        
        natureOfWorkTV.hidden = YES;
        
        _crownBrandDDOutlet.hidden = NO;
        _crownBrandLabel.hidden = NO;
        _noOfUnitsTF.hidden = NO;
        _typeOfCaseOutlet.hidden = NO;
        _typeOfCaseLabel.hidden = NO;
        
        
        
        if ([[natureOfWorkArray objectAtIndex:indexPath.row] isEqual:@"PFM"])
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            _selectNatureOfWorkLabel.text = @"Select Nature of Work";
            
            [_crownBrandLabel setText:@""];
            
            
        }
        
        else
        {
            [ _selectNatureOfWorkLabel setText:[natureOfWorkArray objectAtIndex:indexPath.row]];
            
        }
        
        [commonView removeFromSuperview];
        [natureOfWorkTV removeFromSuperview];

        
        
    }
    else if (tableView == crownBrandTV)
    {
        
        crownBrandTV.hidden = YES;
        
       // _crownBrandPicker.hidden = YES;
        
        // _crownBrandDDOutlet.alpha = 1;
        //_crownBrandLabel.alpha = 1;
        _noOfUnitsTF.hidden = NO;
        _typeOfCaseOutlet.hidden = NO;
        _typeOfCaseLabel.hidden = NO;

        
        if ([[crownBrandArray objectAtIndex:indexPath.row] isEqual:@"e.max"])
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            [_crownBrandLabel setText:@""];
            
        }
        
        else
        {
            
            [_crownBrandLabel setText:[crownBrandArray objectAtIndex:indexPath.row]];
            
        }
        
        [commonView removeFromSuperview];
        [crownBrandTV removeFromSuperview];

        
    }
    
    else if (tableView == typeOfCaseTV)
    {
        [_typeOfCaseLabel setText:[typeOfCaseArray objectAtIndex:indexPath.row]];
        
       // _typeOfCasePicker.hidden = YES;
        
        typeOfCaseTV.hidden = YES;
        [commonView removeFromSuperview];
        [typeOfCaseTV removeFromSuperview];

        
    }

    

    [self partnerLButtonIsClicked];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView == partnerLTV) || (tableView == partnerMTV)) {
        return 150.00;

    }
    
    return 45;
}

-(void) moreButtonIsClicked
{
//    [partnerMView removeFromSuperview];
//    [partnerMTV removeFromSuperview];
    
    [partnerMView removeFromSuperview];
    [partnerMTV removeFromSuperview];
    
    [partnerLTV reloadData];
    
    NSString * LPartner = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                           "<soap:Body>\n"
                           "<GetLPartners xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                           "<DoctorId>%@</DoctorId>\n"
                           "</GetLPartners>\n"
                           "</soap:Body>\n"
                           "</soap:Envelope>\n",filteredDoctorID];
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:LPartner soapActionString:@"GetLPartners" withDelegate:self];
    

    
    
    
}

-(void)partnerLButtonIsClicked
{
    
    [partnerLView removeFromSuperview];
    //self.view.alpha = 1;
    [partnerMTV removeFromSuperview];
    [partnerLTV removeFromSuperview];
    
    
    
}

//-(void) stateButtonIsClicked
//{
//    
//    selectStateTV.dataSource = self;
//    selectStateTV.delegate = self;
//    
//}

//#pragma mark picker view delegate methods
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    if (pickerView == _natureOfWorkPicker)
//    {
//        return natureOfWorkArray.count;
//    }
//    else if (pickerView == _crownBrandPicker)
//    {
//        return crownBrandArray.count;
//    }
//    
//    else
//    {
//        return typeOfCaseArray.count;
//    }
//    
//}
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (pickerView == _natureOfWorkPicker)
//    {
//        return [natureOfWorkArray objectAtIndex:row];
//        
//    }
//    else if (pickerView == _crownBrandPicker)
//    {
//        return [crownBrandArray objectAtIndex:row];
//        
//    }
//    else
//    {
//        return [typeOfCaseArray objectAtIndex:row];
//    }
//    
//}
//
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//    UILabel *pickerViewLabel = (id)view;
//    
//    if (!pickerViewLabel) {
//        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f,[pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
//        
//       // NSLog(@"picker view height and width :%f %f",[pickerView rowSizeForComponent:component].height,[pickerView rowSizeForComponent:component].width);
//    }
//    
//    pickerViewLabel.backgroundColor = [UIColor whiteColor];
//    
//    if (pickerView == _natureOfWorkPicker)
//    {
//        pickerViewLabel.text =[natureOfWorkArray objectAtIndex:row];
//        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:18];
//        
//    }
//    else if (pickerView == _crownBrandPicker)
//
//    {
//        pickerViewLabel.text =[crownBrandArray objectAtIndex:row];
//        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:18];
//        
//    }
//    
//    else
//    {
//        pickerViewLabel.text =[typeOfCaseArray objectAtIndex:row];
//        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:18];
//    }
//    
//    pickerViewLabel.textAlignment = NSTextAlignmentCenter;
//
//    return pickerViewLabel;
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    if (pickerView == _natureOfWorkPicker)
//    {
//        _selectNatureOfWorkLabel.text =[natureOfWorkArray objectAtIndex:row];
//        
//        _natureOfWorkPicker.hidden = YES;
//        
//        _crownBrandDDOutlet.hidden = NO;
//        _crownBrandLabel.hidden = NO;
//        _noOfUnitsTF.hidden = NO;
//        _typeOfCaseOutlet.hidden = NO;
//        _typeOfCaseLabel.hidden = NO;
//        
//
//        
//        if ([[natureOfWorkArray objectAtIndex:row] isEqual:@"PFM"])
//        {
//            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            
//            [alert show];
//            
//            _selectNatureOfWorkLabel.text = @"Select Nature of Work";
//            
//            [_crownBrandLabel setText:@""];
//            
//            
//        }
//        
//        else
//        {
//            [ _selectNatureOfWorkLabel setText:[natureOfWorkArray objectAtIndex:row]];
//            
//        }
//        
//        
//        
//        
//    }
//    else if (pickerView == _crownBrandPicker)
//    {
//        
//        _crownBrandPicker.hidden = YES;
//        
//       // _crownBrandDDOutlet.alpha = 1;
//        //_crownBrandLabel.alpha = 1;
//        _noOfUnitsTF.hidden = NO;
//        _typeOfCaseOutlet.hidden = NO;
//        _typeOfCaseLabel.hidden = NO;
//
//        
//        if ([[crownBrandArray objectAtIndex:row] isEqual:@"e.max"])
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
//            [_crownBrandLabel setText:[crownBrandArray objectAtIndex:row]];
//            
//        }
//        
//    }
//    
//    else if (pickerView == _typeOfCasePicker)
//    {
//        [_typeOfCaseLabel setText:[typeOfCaseArray objectAtIndex:row]];
//        
//        _typeOfCasePicker.hidden = YES;
//        
//    }
//
//    
//}
//
//-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    if (pickerView == _natureOfWorkPicker) {
//        return 45.0;
//    }
//    else if (pickerView == _crownBrandPicker)
//    {
//        return 45.0f;
//    }
//    
//    else
//    {
//        return 40.0;
//
//    }
//    
//    
//}

//-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 30.0f;
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//
#pragma mark saveDoctorName

- (void)saveDocName : (NSString * )doctorName  {
    
    //get the plist document path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
   // NSMutableArray *contentArray= [[NSMutableArray alloc]init];
    
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
    
    
    NSString *docName = doctorName;
    
    //check all the textfields have values
    if ([docName length] >0) {
        
        //add values to dictionary
        [data setValue:docName forKey:@"DoctorName"];
        
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

#pragma mark getDoctorName

-(void) getDoctorName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    data = [[NSMutableDictionary alloc]init];
    contentArray= [[NSMutableArray alloc]init];
    
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
    NSString * welcomeString;
    
    //print the plist result data on console
    for (int i= 0; i<[contentArray count]; i++) {
        data= [contentArray objectAtIndex:i];

        if([data objectForKey:@"DoctorName"])
        {
            NSString *drName = [data objectForKey:@"DoctorName"];
            
            NSCharacterSet *invalidCharSet = [[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"""]invertedSet]invertedSet];
            filteredDoctorName = [[drName componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
            
            if ([filteredDoctorName isEqual:nil] || [filteredDoctorName isEqual:@""]) {
                
                UIAlertView * profileAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter the profile details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [profileAlert show];
            }
            
            else
            {
            NSString * appendString = @"Welcome Dr.";
            
            welcomeString = [appendString stringByAppendingString:filteredDoctorName];
            }
                
        }
        
        
    }
    
    //Appending a string to the Doctor name
    
    _welcomeNameLabel.text = welcomeString;
    
    _welcomeNameLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:118.0f/255.0f blue:172.0f/255.0f alpha:1];

    
    NSLog(@"doc name :%@",welcomeString);

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}




@end












