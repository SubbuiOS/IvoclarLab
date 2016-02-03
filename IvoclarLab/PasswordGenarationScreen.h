//
//  PasswordGenarationScreen.h
//  IvoclarLab
//
//  Created by Subramanyam on 09/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "ViewController.h"

@interface PasswordGenarationScreen : ViewController<UITextFieldDelegate,NSXMLParserDelegate>

{
    NSString * response;
    NSString * filteredDoctorID;

}
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *reenterPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *passwordSubmitOutlet;

- (IBAction)passwordSubmit:(id)sender;

-(void)connectionData:(NSData*)data status:(BOOL)status;





@end
