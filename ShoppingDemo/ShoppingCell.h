//
//  ShoppingCell.h
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/22.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UILabel *introduction;
@property (nonatomic, strong) UILabel *betNnumber;
@property (nonatomic, strong) UILabel *price;

+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView;

@end
