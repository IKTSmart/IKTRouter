


## IKTRouter
@(iOS)[路由|IKTRouter]

> 一行代码实现跳转
IKTRouter 路由

1、目标页面接受参数 声明属性 routerArgs

2、跳转页面响应目标页面回调 声明属性 routerCallBack

### 无参数页面
``` objectivec
(IBAction)everyPagePush:(id)sender {
	[[IKTRouter instalce] pushController:@"UIViewController"];
}
```

### 带参数页面
``` objectivec
(IBAction)argsPagePush:(id)sender {
	[[IKTRouter instalce] pushController:@"ArgsViewController" Args:@{@"par":@"router"}];
}
```

### 回调页面
``` objectivec
(IBAction)callBackPagePush:(id)sender {
	[[IKTRouter instalce] pushController:@"CallBackViewController" Args:@{@"po":@"callBack"} CallBack:^(NSDictionary *paramers) {
    NSLog(@"收到回调参数%@",paramers);
}];
}
```

### cocoapods下载
``` 
target 'DemoName' do

  pod 'IKTRouter'

end

```


## 反馈与建议
- QQ交流群：314846081
