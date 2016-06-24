//
//  ZKCounter.h
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/22.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^counterBlock)(NSString *counterText);
@interface ZKCounter : UIView 

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) counterBlock block;

- (void)counterNumberChange:(counterBlock)counterText;

@end
