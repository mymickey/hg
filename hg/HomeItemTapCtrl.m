//
//  HomeItemTapCtrl.m
//  hg
//
//  Created by mickey on 15/4/19.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "HomeItemTapCtrl.h"
#import "UIView+ItemDate.h"
#import "HistoryStore.h"

@interface HomeItemTapCtrl()<UITextFieldDelegate>
{
    NSString * opening;
    UITextField *textField;
    NSInteger currentEditItemIndex;
    CGRect oldRect;
}
@end

@implementation HomeItemTapCtrl
-(void)onColumnItemTap:(NSInteger)index seconds:(NSString *)seconds
{
    NSLog(@"onColumnItemTap:%@",seconds);
}
-(void)enableItemTapEvent:(UIView *)v
{
    self.view = v;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self addObserver:self forKeyPath:@"opening" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    oldRect = self.view.frame;
}
//视图被点击
-(void)onTap:(UITapGestureRecognizer *)tap
{
    UIView *view = self.view;
    CGPoint point = [tap locationInView:view];
    BOOL has = NO;
    NSArray *views = [view subviews];
    NSInteger i ;
    for (i = 0; [views count] > i; i++) {
        UIView *v = views[i];
        has = CGRectContainsPoint(v.frame, point);
        if (has) {
            break;
        }
    }
    if (has) {
        [self removeTextFieldOnSave];
        currentEditItemIndex = i;
        [self setValue:@"1" forKey:@"opening"];
    }else if(opening){
        [self setValue:@"0" forKey:@"opening"];
    }
}
-(UITextField *)createTextField:(NSString *)text
{
    textField = [[UITextField alloc] init];
    textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    textField.textColor = [UIColor whiteColor];
    textField.text = text;
    //textField.backgroundColor = [UIColor blackColor];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    [textField addTarget:self  action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    return textField;
}
-(void)textFieldFinished:sender
{
    [self setValue:@"0" forKey:@"opening"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath  isEqual: @"opening"]) {
        BOOL isOpen = [[change objectForKey:NSKeyValueChangeNewKey]  isEqual: @"1"];
        isOpen ? [self toEdit] : [self doenEdit];
    }
}
-(void)toEdit
{
    NSLog(@"add edit");
    UIView *view = [self.view subviews][currentEditItemIndex];
    CGFloat top = view.frame.size.height * currentEditItemIndex;
    UIButton *btn = [view subviews][1];
    NSString *oldTxt = btn.titleLabel.text;
    [self createTextField:oldTxt];
    CGRect rect = self.view.frame;
    textField.frame = CGRectMake(60, top, rect.size.width -70, 20);
    CGRect resultRect = CGRectMake(0,0-  top, oldRect.size.width, oldRect.size.height *2);
    [UIView animateWithDuration:.2 animations:^{
        self.view.frame = resultRect;
    } completion:^(BOOL finished){
        [self.view addSubview:textField];
        btn.hidden = YES;
        [textField becomeFirstResponder];
    }];
}
-(void)doenEdit
{
    [self removeTextFieldOnSave];
    CGRect resultRect = oldRect;
    [UIView animateWithDuration:.4 animations:^{
        self.view.frame = resultRect;
    } completion:^(BOOL finished){
        
    }];
}
-(void)beforeEdit
{
    [self removeTextFieldOnSave];
}
-(void)removeTextFieldOnSave
{
    if(!textField){return;}
    [textField removeTarget:self  action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    UIView *view = [self.view subviews][currentEditItemIndex];
    NSString *itemId = view.seconds;
    NSString *txt = textField.text;
    txt  = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    textField.delegate = nil;
    [textField removeFromSuperview];
    textField = nil;
    [self saveTxt:txt seconds:itemId];
    
}
-(void)saveTxt:(NSString *)txt seconds:(NSString *)seconds
{
    [HistoryStore modifyTxt:txt seconds:seconds date:[NSDate new]];
    UIView *view = [self.view subviews][currentEditItemIndex];
    UIButton *btn = [view subviews][1];
    btn.hidden = NO;
    [btn setTitle:txt forState:UIControlStateNormal];
}
- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > field.text.length)
    {
        return NO;
    }
    if ([string  isEqual: @""]) {
        return YES;
    }
    NSLog(@"text:%@",string);
    NSLog(@"text2:%@",field.text);
    NSString *newStr = [NSString stringWithFormat:@"%@%@",field.text,string];
    CGFloat width =  [newStr sizeWithFont:field.font].width;
    return width < field.frame.size.width;
}
@end
