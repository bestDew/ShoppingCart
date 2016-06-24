//
//  ArrowView.m
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/23.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import "ArrowView.h"
#import "CartCell.h"

@interface ArrowView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UILabel *totalMoney;
@property (nonatomic, strong) UIButton *determinBtn;

@property (nonatomic, strong) NSMutableDictionary *dic; // 保存计数器数值

@end

@implementation ArrowView

#pragma mark -- setter/getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"购物车";
        _titleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.66 alpha:1.00];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)clearBtn
{
    if (!_clearBtn) {
        
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.66 alpha:1.00] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UITableView *)listView
{
    if (!_listView) {
        
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, W(self), H(self) - 108) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.tableFooterView = [[UIView alloc] init]; // 去除多余的cell
    }
    return _listView;
}

- (UILabel *)totalMoney
{
    if (!_totalMoney) {
        
        _totalMoney = [[UILabel alloc] init];
        _totalMoney.textColor = ThemeColor;
        _totalMoney.text = @"共:￥30000";
        _totalMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _totalMoney;
}

- (UIButton *)determinBtn
{
    if (!_determinBtn) {
       
        _determinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_determinBtn setTitle:@"选好了" forState:UIControlStateNormal];
        _determinBtn.backgroundColor = ThemeColor;
        [_determinBtn addTarget:self action:@selector(determinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determinBtn;
}

- (NSMutableDictionary *)dic
{
    if (!_dic) {
        
        _dic = [[NSMutableDictionary alloc] init];
    }
    return _dic;
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self.listView reloadData];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.clearBtn];
    [self addSubview:self.listView];
    [self addSubview:self.totalMoney];
    [self addSubview:self.determinBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(W(self) - 95, 32, 80, 20);
    self.clearBtn.frame = CGRectMake(0, 32, 80, 20);
    self.listView.frame = CGRectMake(0, 64, W(self), H(self) - 108);
    self.totalMoney.frame = CGRectMake(0, H(self) - 44, 100, 44);
    self.determinBtn.frame = CGRectMake(W(self) - 100, H(self) - 44, 100, 44);
}

#pragma mark -- 重写drawRect:方法
-(void)drawRect:(CGRect)rect
{
    CGRect frame = rect;
    frame.origin.y = frame.origin.y + 20;
    rect = frame;
    [self drawArrowRectangle:rect];
}

- (void)drawArrowRectangle:(CGRect) frame
{
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 创建一个新的空图形路径
    CGContextBeginPath(contextRef);
    
    // 启始位置坐标x，y
    CGFloat origin_x = frame.origin.x;
    CGFloat origin_y = frame.origin.y;
    
    CGFloat point_1_x = frame.size.width - 63;
    CGFloat point_1_y = origin_y;
    
    // 尖角的顶点位置坐标
    CGFloat point_2_x = point_1_x + 8;
    CGFloat point_2_y = point_1_y - 10;
    
    CGFloat point_3_x = point_2_x + 8;
    CGFloat point_3_y = point_1_y;
    
    CGFloat point_4_x = frame.size.width;
    CGFloat point_4_y = point_1_y;
    
    CGFloat point_5_x = frame.size.width;
    CGFloat point_5_y = frame.size.height;
    
    CGFloat point_6_x = origin_x;
    CGFloat point_6_y = frame.size.height;
    
    CGContextMoveToPoint(contextRef, origin_x, origin_y);
    
    CGContextAddLineToPoint(contextRef, point_1_x, point_1_y);
    CGContextAddLineToPoint(contextRef, point_2_x, point_2_y);
    CGContextAddLineToPoint(contextRef, point_3_x, point_3_y);
    CGContextAddLineToPoint(contextRef, point_4_x, point_4_y);
    CGContextAddLineToPoint(contextRef, point_5_x, point_5_y);
    CGContextAddLineToPoint(contextRef, point_6_x, point_6_y);
    
    CGContextClosePath(contextRef);
    
    UIColor *costomColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1.00];
    CGContextSetFillColorWithColor(contextRef, costomColor.CGColor);
    
    CGContextFillPath(contextRef);
    
}

- (void)clearBtnClick:(UIButton *)sender
{
    [self.dic removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.listView reloadData];
    
    if ([_delegate_btn respondsToSelector:@selector(clearBtnClick:)]) {
        [_delegate_btn clearBtnClick:sender];
    }
}

- (void)determinBtnClick:(UIButton *)sender
{
    if (self.dataSource.count == 0) {
        return;
    }
    
    if ([_delegate_btn respondsToSelector:@selector(determinBtnClick:)]) {
        [_delegate_btn determinBtnClick:sender];
    }
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell *cell = [CartCell cartCellWithTableView:tableView];
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    [cell.counter counterNumberChange:^(NSString *counterText) {
        if ([counterText isEqualToString:@"0"]) {
            [self deleteCellAtIndexPath:indexPath];
        }else{
            [self.dic setValue:counterText forKey:key];
        }
    }];

    cell.price.text = [self.dataSource objectAtIndex:indexPath.row][0];
    if ([self.dic objectForKey:key]) {
        cell.counter.textField.text = [self.dic objectForKey:key];
    }
    
    return cell;
}

#pragma mark -- private
- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath
{
    self.deselectCellBlock([self.dataSource objectAtIndex:indexPath.row][1]);
    
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.listView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listView reloadData];
    });
}

@end
