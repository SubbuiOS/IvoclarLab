//
//  LabPersonLogin.m
//  IvoclarLab
//
//  Created by Mac on 23/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "LabPersonLogin.h"

@interface LabPersonLogin ()

@end


@implementation LabPersonLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Ivoclar Lab";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
//    statusArray = [[NSMutableArray alloc]initWithObjects:@"In-Process",@"Out for Dispatch",@"Delivered", nil];
//    _statusPicker.hidden = YES;
//    _statusPicker.delegate = self;
//    _statusPicker.dataSource = self;
    
    
    
    
}



- (IBAction)labLoginSubmit:(id)sender
{
    
    NSString * labLoginCheck =  [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<CheckLoginLab xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                 "<Username>%@</Username>\n"
                                 "<Password>%@</Password>\n"
                                 "<RegId>-</RegId>\n"
                                 "</CheckLoginLab>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n",_labPersonUserName.text,_labPersonPassword.text];
    
    
    [[CommonAppManager sharedAppManager]soapService:labLoginCheck url:@"CheckLoginLab" withDelegate:self];
    


    
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
    currentDescription = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentDescription = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    //[spinner stopAnimating];
    
    //NSLog(@"element names :%@\n\n",elementName);
    
    if ([elementName isEqual:@"CheckLoginLabResult"]) {
        
        NSLog(@"lab login :%@",currentDescription);
    }
    
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
