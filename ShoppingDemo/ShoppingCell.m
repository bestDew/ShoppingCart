//
//  ShoppingCell.m
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/22.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import "ShoppingCell.h"

@implementation ShoppingCell

#pragma mark -- lazy load
- (UIImageView *)goodsImageView
{
    if (!_goodsImageView) {
        
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.clipsToBounds = YES;
        _goodsImageView.layer.borderWidth = 1;
        _goodsImageView.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00].CGColor;
        [self.contentView addSubview:_goodsImageView];
    }
    return _goodsImageView;
}

- (UILabel *)goodsName
{
    if (!_goodsName) {
        
        _goodsName = [[UILabel alloc] init];
        _goodsName.numberOfLines = 0;
        _goodsName.font = Font(14);
        [self.contentView addSubview:_goodsName];
    }
    return _goodsName;
}

- (UILabel *)introduction
{
    if (!_introduction) {
        
        _introduction = [[UILabel alloc] init];
        _introduction.textAlignment = NSTextAlignmentLeft;
        _introduction.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.61 alpha:1.00];
        _introduction.font = Font(12);
        [self.contentView addSubview:_introduction];
    }
    return _introduction;
}

- (UILabel *)betNnumber
{
    if (!_betNnumber) {
        
        _betNnumber = [[UILabel alloc] init];
        _betNnumber.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.61 alpha:1.00];
        _betNnumber.textAlignment = NSTextAlignmentLeft;
        _betNnumber.font = Font(12);
        [self.contentView addSubview:_betNnumber];
    }
    return _betNnumber;
}

- (UILabel *)price
{
    if (!_price) {
        
        _price = [[UILabel alloc] init];
        _price.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_price];
    }
    return _price;
}

+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"ShoppingCell";
    ShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ShoppingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.multipleSelectionBackgroundView = [[UIView alloc] init];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self custom];
    }
    return self;
}

- (void)custom
{
    self.goodsImageView.image = [UIImage imageNamed:@"nvbao"];
    
    [self labelSizeToFit:self.goodsName withText:@"PRADA秋冬款时尚女包欧美潮流女人"];
    
    self.introduction.text = @"简要说明简要说明";
    
    self.betNnumber.text = [NSString stringWithFormat:@"已售：%d", arc4random() % 10];    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_top).with.offset(7);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
    [_introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodsName.mas_centerX).with.offset(0);
        make.top.equalTo(self.goodsName.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.betNnumber.mas_top).with.offset(-10);
        make.width.equalTo(self.goodsName);
    }];
    
    [_betNnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.price.mas_top).with.offset(-5);
        make.width.equalTo(self.introduction);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.width.equalTo(self.introduction);
    }];
}

// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}

#pragma mark -- private 处理字符串
- (void)labelSizeToFit:(UILabel *)label withText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 3.0; // 行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
    [label sizeToFit];
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
