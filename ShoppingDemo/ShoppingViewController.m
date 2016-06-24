//
//  ShoppingViewController.m
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/22.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ShoppingCell.h"
#import "ArrowView.h"

@interface ZKBarButtonItem : UIBarButtonItem
{
    BOOL _seleted; // 是否选中状态
}
@property (nonatomic) BOOL seleted;

@end

@implementation ZKBarButtonItem

@synthesize seleted = _seleted;

@end

@interface ShoppingViewController () <UITableViewDelegate, UITableViewDataSource, ArrowViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cart;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) ArrowView *arrowView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray <NSArray *> *arrays;
@property (nonatomic, assign) CGFloat endPoint_x;
@property (nonatomic, assign) CGFloat endPoint_y;
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isJoinCart;

@end

@implementation ShoppingViewController

#pragma mark -- lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1.00];
        _tableView.rowHeight = 120;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.editing = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(W(self.cart) - 10, 0, 20, 20)];
        _countLabel.backgroundColor = ThemeColor;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = Font(12);
        _countLabel.layer.masksToBounds = YES;
        _countLabel.layer.cornerRadius = W(_countLabel)/2;
        [self.cart addSubview:_countLabel];
    }
    return _countLabel;
}

- (ArrowView *)arrowView
{
    if (!_arrowView) {
        
        _arrowView = [[ArrowView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, (ScreenHeight)/2)];
        _arrowView.backgroundColor = [UIColor clearColor];
        _arrowView.delegate_btn = self;
        [self.view addSubview:_arrowView];
        
        __weak typeof(self) weakSelf = self;
        _arrowView.deselectCellBlock = ^(NSIndexPath *indexPath) {
            
            weakSelf.count --;
            [weakSelf numberChange];

            [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
        };
    }
    return _arrowView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.f;
    }
    return _backgroundView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray <NSArray *> *)arrays
{
    if (!_arrays) {
        
        _arrays = [[NSMutableArray alloc] init];
    }
    return _arrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    self.title = @"商城";
    self.count = 0;
    
    ZKBarButtonItem *rightItem = [[ZKBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAll:)];
    rightItem.tintColor = [UIColor whiteColor];
    rightItem.seleted = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 模拟数据源
    for (int i = 1; i < 31; i++) {
        NSString *str = [NSString stringWithFormat:@"￥%d", (arc4random() % 10000) + 1000];
        [self.dataSource addObject:str];
    }
    
    [self.tableView reloadData];
    
    self.cart = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cart.frame = CGRectMake(ScreenWidth - 100, ScreenHeight - 100, 80, 80);
    [self.cart setBackgroundImage:[UIImage imageNamed:@"iconpng"] forState:UIControlStateNormal];
    [self.cart addTarget:self action:@selector(cartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cart];
}

- (void)selectAll:(ZKBarButtonItem *)item
{
    item.seleted = !item.seleted;
    
    if (item.seleted == YES) {
        for (int i = 0; i < self.dataSource.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.arrays addObject:@[[self.dataSource objectAtIndex:indexPath.row], indexPath]];
        }
        self.count = self.dataSource.count;
    }else{
        for (int i = 0; i < self.dataSource.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        self.count = 0;
        [self.arrays removeAllObjects];
    }
    [self numberChange];
    self.arrowView.dataSource = self.arrays;
}

#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCell *cell = [ShoppingCell tableViewCellWithTableView:tableView];
    cell.price.attributedText = [self procesString:@"金额:" with:[self.dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isJoinCart = YES;
    self.count ++;
    
    ShoppingCell *cell = (ShoppingCell *)[tableView cellForRowAtIndexPath:indexPath];
    CGRect parentRect = [cell convertRect:cell.goodsImageView.frame toView:self.view];

    [self joinCartAnimationWithRect:parentRect];
    
    [self.arrays addObject:@[[self.dataSource objectAtIndex:indexPath.row], indexPath]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isJoinCart = NO;
    self.count --;
    
    [self numberChange];
    [self removeFromCartAnimation];
    
    [self.arrays removeObject:@[[self.dataSource objectAtIndex:indexPath.row], indexPath]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransform3D scale = CATransform3DMakeScale(0.5, 0.5, 0.5);
    cell.layer.transform = scale;
    
    [UIView animateWithDuration:0.5f animations:^{
        cell.layer.transform = CATransform3DIdentity;
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -- arrowView delegate_btn
- (void)cartButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.arrowView.dataSource = self.arrays;
    
    if (btn.selected) {
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundView.alpha = 0.5f;
            [self.view insertSubview:self.backgroundView belowSubview:self.cart];
            self.cart.frame = CGRectMake(ScreenWidth - 100, ScreenHeight/2 - 70, 80, 80);
            self.arrowView.frame = CGRectMake(0, ScreenHeight - (ScreenHeight)/2, ScreenWidth, (ScreenHeight)/2);
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundView.alpha = 0.f;
            self.cart.frame = CGRectMake(ScreenWidth - 100, ScreenHeight - 100, 80, 80);
            self.arrowView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, (ScreenHeight)/2);
        } completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
        }];
    }
}

- (void)determinBtnClick:(UIButton *)sender
{
    NSLog(@"确定按钮被点击了");
}

#pragma mark -- animation
- (void)joinCartAnimationWithRect:(CGRect)rect
{
    self.endPoint_x = ScreenWidth - 60;
    self.endPoint_y = ScreenHeight - 100;
    
    CGFloat startX = rect.origin.x  + 100;
    CGFloat startY = rect.origin.y;
    
    self.path = [UIBezierPath bezierPath];
    [self.path moveToPoint:CGPointMake(startX, startY)];
    [self.path addQuadCurveToPoint:CGPointMake(self.endPoint_x, self.endPoint_y) controlPoint:CGPointMake(startX + 180, startY - 200)];
    
    self.layer = [CALayer layer];
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"nvbao"].CGImage;
    self.layer.frame = CGRectMake(startX, startY, 100, 100);
    [self.view.layer addSublayer:self.layer];
    
    [self groupAnimation];
}

- (void)removeFromCartAnimation
{
    CGFloat startX = ScreenWidth - 40;
    CGFloat startY = ScreenHeight - 120;

    self.endPoint_x = ScreenWidth;
    self.endPoint_y = ScreenHeight;
    
    self.path = [UIBezierPath bezierPath];
    [self.path moveToPoint:CGPointMake(startX, startY)];
    [self.path addQuadCurveToPoint:CGPointMake(self.endPoint_x, self.endPoint_y) controlPoint:CGPointMake(ScreenWidth + 100, startY - 200)];
    
    self.layer = [CALayer layer];
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"nvbao"].CGImage;
    self.layer.frame = CGRectMake(startX, startY, 50, 50);
    [self.view.layer addSublayer:self.layer];
    
    [self groupAnimation];
}

- (void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = self.path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation, scaleAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [self.layer addAnimation:groups forKey:nil];
    [self performSelector:@selector(removeFromLayer:) withObject:self.layer afterDelay:0.8f];
}

- (void)removeFromLayer:(CALayer *)layerAnimation
{
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        if (self.isJoinCart == YES) {
            
            CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            shakeAnimation.duration = 0.25f;
            shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
            shakeAnimation.toValue = [NSNumber numberWithFloat:1];
            shakeAnimation.autoreverses = YES;
            [self.cart.layer addAnimation:shakeAnimation forKey:nil];
            [self numberChange];
        }
    }
}

- (void)numberChange
{
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)self.count];
    
    if (self.count == 0) {
        self.countLabel.hidden = YES;
    }else{
        self.countLabel.hidden = NO;
    }
}

#pragma mark -- arrowViewDelegate
- (void)clearBtnClick:(UIButton *)sender
{
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    self.count = 0;
    self.countLabel.hidden = YES;
    [self.arrays removeAllObjects];
}

#pragma mark -- private
- (NSAttributedString *)procesString:(NSString *)str1 with:(NSString *)str2
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", str1, str2]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.60 green:0.60 blue:0.61 alpha:1.00] range:NSMakeRange(0,str1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.92 green:0.16 blue:0.23 alpha:1.00] range:NSMakeRange(str1.length + 1, str2.length)];
    
    [str addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange(0, str1.length)];
    [str addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange(4, str2.length)];
    
    return str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.cart.selected = !self.cart.selected;

    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = 0.f;
        self.cart.frame = CGRectMake(ScreenWidth - 100, ScreenHeight - 100, 80, 80);
        self.arrowView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, (ScreenHeight)/2);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
