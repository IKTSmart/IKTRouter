//
//  ArgsViewController.m
//  IKTRouterDemo
//
//  Created by bcikt on 2018/7/3.
//  Copyright © 2018年 bcikt. All rights reserved.
//

#import "ArgsViewController.h"

@interface ArgsViewController ()

@end

@implementation ArgsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"传递参数";
    
    NSLog(@"接收到参数：%@",_routerArgs);
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
