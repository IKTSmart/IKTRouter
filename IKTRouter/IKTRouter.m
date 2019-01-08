//
//  IKTRouter.m
//  IKTRouterDemo
//  https://github.com/IKTSmart/IKTRouter.git
//  Created by ETScorpion on 2018/7/3.
//  Copyright © 2018年 ETScorpion. All rights reserved.
//

#import "IKTRouter.h"
#import <objc/runtime.h>
#import <UIKit/UINavigationController.h>
#import <UIKit/UITabBarController.h>

@interface IKTRouter ()

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation IKTRouter


+ (instancetype)instalce{
    static IKTRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[IKTRouter alloc] init];
    });
    return router;
}

- (void)pushController:(NSString *)controllerName{
    [self pushController:controllerName Args:nil];
}

- (void)pushController:(NSString *)controllerName Args:(NSDictionary *)args{
    [self pushController:controllerName Args:args CallBack:nil];
}

- (void)pushController:(NSString *)controllerName Args:(NSDictionary *)args CallBack:(RouterCallBack)callBack{
    
    Class controllerClass = NSClassFromString(controllerName);
    id controller = [[controllerClass alloc] init];
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    if (!controllerClass || ![controller isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList(controllerClass, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    
    Class superControllerClass = [controllerClass superclass];
    u_int superCount;
    objc_property_t *superProperties = class_copyPropertyList(superControllerClass, &superCount);
    NSMutableArray *superPropertiesArray = [NSMutableArray arrayWithCapacity:superCount];
    
    for (int i = 0; i < superCount; i++) {
        const char *propertyName = property_getName(superProperties[i]);
        [superPropertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(superProperties);
    
    if (args.count>0 &&([propertiesArray containsObject:@"routerArgs"]||[superPropertiesArray containsObject:@"routerArgs"])) {
        [controller setValue:[args mutableCopy] forKey:@"routerArgs"];
    }

    if (callBack && ([propertiesArray containsObject:@"routerCallBack"]||[superPropertiesArray containsObject:@"routerCallBack"])) {
        [controller setValue:callBack forKey:@"routerCallBack"];
    }
    
    //尝试设置参数
    NSArray *keys = [args allKeys];
    for (NSString *key in keys){
        if ([propertiesArray containsObject:key]) {
            [controller setValue:[args objectForKey:key] forKey:key];
        }
    }
    
    if (_navigationController) {
        [_navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)pushController:(UIViewController *)controller animated:(BOOL)animated{
    
    if (_navigationController) {
        [_navigationController pushViewController:controller animated:YES];
    }
}

- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0){
    
    if (_navigationController) {
        [_navigationController presentViewController:controller animated:YES completion:completion];
    }
}

- (void)presentController:(NSString *)controllerName Animated:(BOOL)animated{
    
    if (!controllerName) {
        return;
    }
    [self presentController:controllerName Animated:animated Completion:nil];
}

- (void)presentController:(NSString *)controllerName Animated:(BOOL)animated Completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0){
    
    Class controllerClass = NSClassFromString(controllerName);
    id controller = [[controllerClass alloc] init];
    
    if ([controller isKindOfClass:[UIViewController class]] && _navigationController) {
        
        [_navigationController presentViewController:controller animated:animated completion:completion];
    }
    
}

- (void)dismissViewControllerAnimated:(BOOL)animiated completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0){
    
    if (_navigationController) {
        [_navigationController dismissViewControllerAnimated:animiated completion:completion];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated{
    if (_navigationController) {
        [_navigationController popToRootViewControllerAnimated:animated];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated TabIndex:(NSInteger)index{
    
    if (_navigationController) {
        [_navigationController popToRootViewControllerAnimated:animated];
        [_navigationController.tabBarController setSelectedIndex:index];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated{
    if (_navigationController) {
        [_navigationController popViewControllerAnimated:animated];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated TabIndex:(NSInteger)index{
    
    if (_navigationController) {
        [_navigationController popViewControllerAnimated:animated];
        
        __weak typeof(UINavigationController *) weakNavigation = _navigationController;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakNavigation.visibleViewController.tabBarController setSelectedIndex:index];
        });
    }
}

- (void)selectTabIndex:(NSInteger)index{
    
    if (_navigationController && _navigationController.tabBarController.viewControllers.count>index) {
        UINavigationController *lastNavigationVC = _navigationController;
        [_navigationController.tabBarController setSelectedIndex:index];
        [lastNavigationVC popToRootViewControllerAnimated:YES];
    }
}

- (void)selectTabIndexNoPop:(NSInteger)index{
    
    if (_navigationController && _navigationController.tabBarController.viewControllers.count>index) {
        [_navigationController.tabBarController setSelectedIndex:index];
    }
}

@end

#pragma mark - UInavigationController Router

@interface UINavigationController (IKTRouter)

@end

@implementation UINavigationController (IKTRouter)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"UINavigationController");
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_NavigationViewWillAppear:));
    });
}

- (void)aop_NavigationViewWillAppear:(BOOL)animation {
    [self aop_NavigationViewWillAppear:animation];
    
    [IKTRouter instalce].navigationController = self;
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
