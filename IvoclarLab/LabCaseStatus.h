//
//  LabCaseStatus.h
//  IvoclarLab
//
//  Created by Mac on 24/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabCaseStatus : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSMutableArray * statusArray;

}
@property (weak, nonatomic) IBOutlet UIPickerView *statusPicker;
- (IBAction)statusButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *statusButtonOutlet;

@end
