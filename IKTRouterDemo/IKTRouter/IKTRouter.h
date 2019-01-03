//
//  IKTRouter.h
//  IKTRouterDemo
//  https://github.com/IKTSmart/IKTRouter.git
//  Created by bcikt on 2018/7/3.
//  Copyright © 2018年 bcikt. All rights reserved.
//

#import <Foundation/Foundation.h>

/* ---------
 * IKTRouter 路由
 * 1、目标页面接受参数 声明属性 routerArgs
 * 2、跳转页面响应目标页面回调 声明属性 routerCallBack
 * ---------
 */
typedef void(^RouterCallBack)(NSDictionary *paramers);

@interface IKTRouter : NSObject

+ (instancetype)instalce;

- (void)pushController:(NSString *)controllerName;

- (void)pushController:(NSString *)controllerName Args:(NSDictionary *)args;

- (void)pushController:(NSString *)controllerName Args:(NSDictionary *)args CallBack:(RouterCallBack)callBack;

- (void)pushController:(UIViewController *)controller animated:(BOOL)animated;

- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);

- (void)presentController:(NSString *)controllerName Animated:(BOOL)animated;

- (void)presentController:(NSString *)controllerName Animated:(BOOL)animated Completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);

- (void)dismissViewControllerAnimated:(BOOL)animiated completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);

- (void)popToRootViewControllerAnimated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated TabIndex:(NSInteger)index;

- (void)popViewControllerAnimated:(BOOL)animated;

- (void)popViewControllerAnimated:(BOOL)animated TabIndex:(NSInteger)index;

- (void)selectTabIndex:(NSInteger)index;

@end
