//
//  ViewController.m
//  AutoEmailApp
//
//  Created by xiaominfc on 10/21/14.
//  Copyright (c) 2014 haitou. All rights reserved.
//

#import "ViewController.h"
#import "AutoEmailTextField.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet AutoEmailTextField *emailTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.emailTextField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view, typically from a nib.
}

//-(void)valueChanged:(id)sender{
//    NSLog(@"here");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
