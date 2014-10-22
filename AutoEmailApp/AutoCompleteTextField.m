//
//  AutoCompleteTextField.m
//  AutoEmailApp
//
//  Created by xiaominfc on 10/21/14.
//  Copyright (c) 2014 haitou. All rights reserved.
//

#import "AutoCompleteTextField.h"


#define CELLHEIGHT 20
#define AUTOCONTENTHEIGHT 100
#define AUTOCONTENTMARGIN 2


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
@synthesize contentSource;


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
        [self.actionTarget performSelector:self.valueChangedAction withObject:sender];
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
    if(!self.autoCompleteTableView){
        CGRect rect = [self convertRect:self.bounds toView:rootView];
        if(rect.origin.y > AUTOCONTENTHEIGHT + AUTOCONTENTMARGIN + 20){ //20是状态栏的高度
           rect.origin.y = rect.origin.y - AUTOCONTENTHEIGHT + AUTOCONTENTMARGIN;
        }else {
            rect.origin.y = rect.origin.y + rect.size.height + AUTOCONTENTMARGIN;
        }
        
        rect.size.height = AUTOCONTENTHEIGHT;
        self.autoCompleteTableView = [[UITableView alloc] initWithFrame:rect];
        self.autoCompleteTableView.dataSource = self;
        self.autoCompleteTableView.delegate = self;
        self.autoCompleteTableView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.autoCompleteTableView.layer.borderWidth = 0.5;
        self.autoCompleteTableView.bounces = NO;
        [self.autoCompleteTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [self.autoCompleteTableView.layer setShadowOffset:CGSizeMake(4 , 4)];
//        [self.autoCompleteTableView.layer setShadowColor:[[UIColor blackColor] CGColor]];
//        [self.autoCompleteTableView.layer setShadowOpacity:0.8];
//        [self.autoCompleteTableView.layer setShadowRadius:4];
    }
    
    if(![rootView.subviews containsObject:self.autoCompleteTableView]){
        self.autoCompleteTableView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^(void){
            self.autoCompleteTableView.alpha = 1;
        }completion:^(BOOL finished){
            self.autoCompleteTableView.alpha = 1;
        }];
        [rootView addSubview:self.autoCompleteTableView];
    }
    
    [self updateData];
    if(self.autoCompleteTableView){
        [self.autoCompleteTableView reloadData];
    }
}

-(void)updateData{
    
}



-(void)hideAutoTableView{
    if(self.autoCompleteTableView) {
        [UIView animateWithDuration:0.3 animations:^(void){
            self.autoCompleteTableView.alpha = 0;
        }completion:^(BOOL finished){
            self.autoCompleteTableView.alpha = 0;
            [self.autoCompleteTableView removeFromSuperview];
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
    NSString *content = [contentSource objectAtIndex:[indexPath row
                                  ]];
    self.text = content;
    [self hideAutoTableView];
}


-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if(controlEvents == UIControlEventEditingChanged){
        self.actionTarget = target;
        self.valueChangedAction = action;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.textLabel.text = [contentSource objectAtIndex:[indexPath row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



@end
