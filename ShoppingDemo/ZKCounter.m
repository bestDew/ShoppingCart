//
//  ZKCounter.m
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/22.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import "ZKCounter.h"

@implementation ZKCounter

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00].CGColor;
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightBtn];
    
    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.font = Font(15);
    self.textField.text = @"1";
    self.textField.userInteractionEnabled = NO;
    [self addSubview:self.textField];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.equalTo(@25);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.equalTo(@25);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.leftBtn.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.right.equalTo(self.rightBtn.mas_left).with.offset(0);
    }];
}

- (void)leftBtnClick
{
    if ([self.textField.text integerValue] > 0) {
        self.textField.text = [NSString stringWithFormat:@"%ld", [self.textField.text integerValue] - 1];
        self.block(self.textField.text);
    }
}

- (void)rightBtnClick
{
    self.textField.text = [NSString stringWithFormat:@"%ld", [self.textField.text integerValue] + 1];
    self.block(self.textField.text);
}

#pragma mark -- block回调
- (void)counterNumberChange:(counterBlock)counterText
{
    self.block = counterText;
}

@end
