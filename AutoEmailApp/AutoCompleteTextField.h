//
//  AutoCompleteTextField.h
//  AutoEmailApp
//
//  Created by xiaominfc on 10/21/14.
//  Copyright (c) 2014 haitou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCompleteTextField : UITextField
@property(strong,nonatomic)NSMutableArray *contentSource;
-(void)updateData;
-(void)initData;


/**
 * 隐藏提示列表
 */


-(void)hideAutoTableView;


/**
 * 显示提示列表
 */

-(void)showAutoTableView;
@end
