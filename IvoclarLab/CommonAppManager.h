//
//  ERGameManager.h
//  GoodieLetters
//
//  Created by Coding Cursors on 05/05/11.
//  Copyright 2011 What IS? Properties LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoctorLogin.h"
#import "LabPersonLogin.h"
#import "SideMenuListViewController.h"
#import "DoctorAlreadyRegistered.h"
#import "NewUserOTPScreen.h"
#import "ProfileScreen.h"
#import "CaseEntryViewController.h"
#import "CaseHistory.h"
#import "UpdateMobileScreen.h"
#import "ComplaintsScreen.h"
#import "CaseDelivery.h"

#define MainURL  @"http://www.kurnoolcity.com/wsdemo"
@interface CommonAppManager : NSObject{
    
    
    NSURLConnection *theConnection;
    NSMutableData *webData;
    
    NSMutableArray * menuArray;
    
    id delegate;
    
}

+(id)sharedAppManager;
-(void) soapService: (NSString * )message url:appendingString withDelegate:(id)viewController;

-(void)viewController:viewControllerName;

@end
