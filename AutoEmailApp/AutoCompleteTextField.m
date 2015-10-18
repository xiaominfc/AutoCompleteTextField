//
//  AutoCompleteTextField.m
//  AutoEmailApp
//
//  Created by xiaominfc on 10/21/14.
//  Copyright (c) 2014 haitou. All rights reserved.
//

#import "AutoCompleteTextField.h"


#define CELLHEIGHT 24
#define AUTOCONTENTHEIGHT (5 * CELLHEIGHT)
#define AUTOCONTENTMARGIN 2
#define TEXTFONT 12


@interface AutoCompleteTextField()<UITableViewDataSource,UITableViewDelegate>

/**
 * show autocomplete content view
 */
@property(strong,nonatomic)UITableView *autoCompleteTableView;


/**
 * because self work for UIControlEventEditingChanged, for customer
 */

@property(weak,nonatomic)id actionTarget;

/**
 * bind with actionTarget
 */


@property(nonatomic)SEL valueChangedAction;


@end

@implementation AutoCompleteTextField



-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self initContent];
    return self;
}

-(void)initContent{
    [super addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.contentSource = [[NSMutableArray alloc] init];
}

-(void)valueChanged:(id)sender
{
    [self showAutoTableView];
    if(self.valueChangedAction && self.actionTarget){
        [self.actionTarget performSelector:_valueChangedAction withObject:sender];
    }
}


-(void)initData
{
    
}

-(BOOL)resignFirstResponder
{
    [self hideAutoTableView];
    return [super resignFirstResponder];
}

-(void)showAutoTableView{
    UIView *rootView = [self getRootView];
    if(!_autoCompleteTableView){
        CGRect rect = [self convertRect:self.bounds toView:rootView];
        if(rect.origin.y > AUTOCONTENTHEIGHT + AUTOCONTENTMARGIN + 20){ //20是状态栏的高度
           rect.origin.y = rect.origin.y - AUTOCONTENTHEIGHT - AUTOCONTENTMARGIN;
        }else {
            rect.origin.y = rect.origin.y + rect.size.height + AUTOCONTENTMARGIN;
        }
        
        rect.size.height = AUTOCONTENTHEIGHT;
        _autoCompleteTableView = [[UITableView alloc] initWithFrame:rect];
        _autoCompleteTableView.dataSource = self;
        _autoCompleteTableView.delegate = self;
        
        UIColor * borderColor = [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.4];
        
        _autoCompleteTableView.layer.borderColor = [borderColor CGColor];
        _autoCompleteTableView.layer.borderWidth = 0.5;
        _autoCompleteTableView.bounces = NO;
//        [_autoCompleteTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if ([_autoCompleteTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_autoCompleteTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_autoCompleteTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_autoCompleteTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    if(![rootView.subviews containsObject:_autoCompleteTableView]){
        _autoCompleteTableView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^(void){
            _autoCompleteTableView.alpha = 1;
        }completion:^(BOOL finished){
            _autoCompleteTableView.alpha = 1;
            
        }];
        [rootView addSubview:_autoCompleteTableView];
    }
    
    [self updateData];
    if(_autoCompleteTableView){
        [_autoCompleteTableView reloadData];
    }
}

-(void)updateData{
    
}



-(void)hideAutoTableView{
    if(_autoCompleteTableView) {
        [UIView animateWithDuration:0.3 animations:^(void){
            _autoCompleteTableView.alpha = 0;
        }completion:^(BOOL finished){
            _autoCompleteTableView.alpha = 0;
            [_autoCompleteTableView removeFromSuperview];
        }];
    }
}

-(UIView*)getRootView{
    
    UIView *rootView = self.superview;
    while (rootView.superview) {
        rootView = rootView.superview;
        break;
    }
    return rootView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = [_contentSource objectAtIndex:[indexPath row]];
    self.text = content;
    [self hideAutoTableView];
}


-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if(controlEvents == UIControlEventEditingChanged){
        _actionTarget = target;
        _valueChangedAction = action;
        [super addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    }else {
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
}

-(void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if(controlEvents == UIControlEventEditingChanged){
        self.actionTarget = nil;
        self.valueChangedAction = nil;
    }else {
        [super removeTarget:target action:action forControlEvents:controlEvents];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AUTOTABLECELL"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AUTOTABLECELL"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:TEXTFONT];
    cell.textLabel.text = [_contentSource objectAtIndex:[indexPath row]];
    cell.contentMode = UIViewContentModeLeft;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_contentSource) {
        return _contentSource.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



@end
