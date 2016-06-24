//
//  CartCell.m
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/23.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell

#pragma mark -- lazy load
- (UIImageView *)icon
{
    if (!_icon) {
        
        _icon = [[UIImageView alloc] init];
        _icon.layer.borderWidth = 1;
        _icon.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00].CGColor;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)goodsName
{
    if (!_goodsName) {
        
        _goodsName = [[UILabel alloc] init];
        _goodsName.font = Font(14);
        _goodsName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_goodsName];
    }
    return _goodsName;
}

- (UILabel *)price
{
    if (!_price) {
        
        _price = [[UILabel alloc] init];
        _price.textAlignment = NSTextAlignmentRight;
        _price.textColor = ThemeColor;
        _price.font = Font(14);
        [self.contentView addSubview:_price];
    }
    return _price;
}

- (ZKCounter *)counter
{
    if (!_counter) {
        
        _counter = [[ZKCounter alloc] init];
    }
    return _counter;
}

+ (instancetype)cartCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CartCell";
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.icon.image = [UIImage imageNamed:@"nvbao"];
    self.goodsName.text = @"PRADA时尚女包";
    [self.contentView addSubview:self.counter];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(7);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(7);
        make.left.equalTo(self.icon.mas_right).with.offset(10);
        make.height.equalTo(@30);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(7);
        make.right.equalTo(self.counter.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [_counter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(80, 24));
    }];
}

#pragma mark -- cell从复用池取出复用时调用
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // 将计数器数值初始化为1
    self.counter.textField.text = @"1";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
