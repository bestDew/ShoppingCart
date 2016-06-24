//
//  ArrowView.h
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/23.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArrowViewDelegate <NSObject>

- (void)clearBtnClick:(UIButton *)sender;
- (void)determinBtnClick:(UIButton *)sender;

@end

@interface ArrowView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, retain) id <ArrowViewDelegate> delegate_btn;
@property(nonatomic, copy) void (^deselectCellBlock)(NSIndexPath  *indexPath);

@end
