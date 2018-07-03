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

@end
