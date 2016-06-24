//
//  CartCell.h
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/23.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKCounter.h"

@interface CartCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) ZKCounter *counter;

+ (instancetype)cartCellWithTableView:(UITableView *)tableView;

@end
