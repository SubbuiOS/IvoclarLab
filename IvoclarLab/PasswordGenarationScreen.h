//
//  PasswordGenarationScreen.h
//  IvoclarLab
//
//  Created by Subramanyam on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"

@interface PasswordGenarationScreen : ViewController<UITextFieldDelegate,NSXMLParserDelegate>

{
    NSUserDefaults * defaults;
    NSString * response;
}
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;


@property (weak, nonatomic) IBOutlet UITextField *reenterPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *passwordSubmitOutlet;

- (IBAction)passwordSubmit:(id)sender;

-(void)connectionData:(NSData*)data status:(BOOL)status;





@end
