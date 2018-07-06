//
//  IKTRouter.m
//  IKTRouterDemo
//  https://github.com/IKTSmart/IKTRouter.git
//  Created by bcikt on 2018/7/3.
//  Copyright © 2018年 bcikt. All rights reserved.
//

#import "IKTRouter.h"
#import <objc/runtime.h>
#import <UIKit/UINavigationController.h>

@interface IKTRouter ()

@property (nonatomic, strong) UINavigationController *navigationController;

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
    
    if (args.count>0 &&[propertiesArray containsObject:@"routerArgs"]) {
        [controller setValue:[args mutableCopy] forKey:@"routerArgs"];
    }
    
    if (callBack && [propertiesArray containsObject:@"routerCallBack"]) {
        [controller setValue:callBack forKey:@"routerCallBack"];
    }
    
    if (_navigationController) {
        [_navigationController pushViewController:controller animated:YES];
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
