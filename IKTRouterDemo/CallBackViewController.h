//
//  CallBackViewController.h
//  IKTRouterDemo
//
//  Created by bcikt on 2018/7/3.
//  Copyright © 2018年 bcikt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallBackViewController : UIViewController

@property (nonatomic, strong) NSDictionary *routerArgs;

@property (nonatomic, copy) RouterCallBack routerCallBack;

@end
