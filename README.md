# IKTRouter
路由跳转
一行代码实现跳转


/* ---------
 * IKTRouter 路由
 * 1、目标页面接受参数 声明属性 routerArgs
 * 2、跳转页面响应目标页面回调 声明属性 routerCallBack
 * ---------
 */

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




QQ交流群：314846081
