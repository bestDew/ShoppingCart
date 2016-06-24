//
//  BaseNavigationController.m
//  ShoppingDemo
//
//  Created by 张日奎 on 16/6/22.
//  Copyright © 2016年 博创联动. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = ThemeColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    // 2.设置导航栏标题颜色
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSFontAttributeName:Font(18)
                                     }];
    // 3.设置导航栏按钮文字颜色
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                      NSFontAttributeName:Font(15)
                                      } forState:UIControlStateNormal];
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
