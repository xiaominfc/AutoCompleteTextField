//
//  AutoEmailTextField.m
//  AutoEmailApp
//
//  Created by xiaominfc on 10/21/14.
//  Copyright (c) 2014 haitou. All rights reserved.
//

#import "AutoEmailTextField.h"

@interface AutoEmailTextField()



@end

@implementation AutoEmailTextField

-(void)updateData{
    [self.contentSource removeAllObjects];
    
    NSString *text = [NSString stringWithString:self.text];

    if(text.length == 0) {
        [self hideAutoTableView];
    }else {
        NSArray *array = [text componentsSeparatedByString:@"@"];
        text = [array objectAtIndex:0];
        [self.contentSource addObject:[NSString stringWithFormat:@"%@@qq.com",text]];
        [self.contentSource addObject:[NSString stringWithFormat:@"%@@gmail.com",text]];
        [self.contentSource addObject:[NSString stringWithFormat:@"%@@126.com",text]];
        [self.contentSource addObject:[NSString stringWithFormat:@"%@@163.com",text]];
        [self.contentSource addObject:[NSString stringWithFormat:@"%@@hotmail.com",text]];
    }
}

@end
