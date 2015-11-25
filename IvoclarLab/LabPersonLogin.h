//
//  LabPersonLogin.h
//  IvoclarLab
//
//  Created by Mac on 23/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAppManager.h"

@interface LabPersonLogin : UIViewController<NSXMLParserDelegate>


{
    NSMutableData * webData;
    NSString * currentDescription;
}

@property (weak, nonatomic) IBOutlet UITextField *labPersonUserName;

@property (weak, nonatomic) IBOutlet UITextField *labPersonPassword;

- (IBAction)labLoginSubmit:(id)sender;



-(void)connectionData:(NSData*)data status:(BOOL)status;


@end
