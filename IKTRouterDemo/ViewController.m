//
//  ViewController.m
//  IKTRouterDemo
//
//  Created by bcikt on 2018/7/3.
//  Copyright © 2018年 bcikt. All rights reserved.
//

#import "ViewController.h"
#import "IKTRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

//任意页面跳转
- (IBAction)everyPagePush:(id)sender {
    
    [[IKTRouter instalce] pushController:@"UIViewController"];
}

//带参数页面跳转
- (IBAction)argsPagePush:(id)sender {
    
    [[IKTRouter instalce] pushController:@"ArgsViewController" Args:@{@"par":@"router"}];
}

//回调页面跳转
- (IBAction)callBackPagePush:(id)sender {
    
    [[IKTRouter instalce] pushController:@"CallBackViewController" Args:@{@"po":@"callBack"} CallBack:^(NSDictionary *paramers) {
        NSLog(@"收到回调参数%@",paramers);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
