//
//  CaseEntryViewController.m
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "CaseEntryViewController.h"

@interface CaseEntryViewController ()

@end

UITableView * dropDownTV;

UITableViewCell * cell;

NSMutableArray * arr;

@implementation CaseEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.CESidebarButton setTarget: self.revealViewController];
        [self.CESidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    arr = [[NSMutableArray alloc]initWithObjects:@"h1",@"h2",@"h3",@"h4",@"h5",@"h6", nil];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dropDownButton:(id)sender {
    

    
    
    dropDownTV = [[UITableView alloc]initWithFrame:CGRectMake(57, 150, 230, 200) style:UITableViewStylePlain];
    
    dropDownTV.hidden = NO;
    
    dropDownTV.delegate = self;
    dropDownTV.dataSource = self;
    [self.view addSubview:dropDownTV];
    
   
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString * cellIdentifier = @"cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }
    
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    _dropDownButtonOutlet.titleLabel.text = [arr objectAtIndex:indexPath.row];
    
    tableView.hidden = YES;
    
    
    
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
