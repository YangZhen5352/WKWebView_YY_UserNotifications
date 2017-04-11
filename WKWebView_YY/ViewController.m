//
//  ViewController.m
//  WKWebView_YY
//
//  Created by 杨振 on 2016/11/16.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#define LoadBundleFile(fileName) [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil] encoding:NSUTF8StringEncoding error:nil]

@interface ViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutWK];
}

- (void)layoutWK
{
    
    // 1.这个类专门用来配置WKWebView的：config
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    
    // 2.设置进程池
    WKProcessPool * pool = [[WKProcessPool alloc]init];
    config.processPool = pool;
    
    // 3.进行偏好设置
    WKPreferences * preference = [[WKPreferences alloc] init];
    //  最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 80;
    //  设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    //  设置是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 4.设置内容交互控制器 用于处理JavaScript与native交互 <固定写法>
    WKUserContentController * userController = [[WKUserContentController alloc]init];
    //  设置处理代理并且注册要被js调用的方法名称
    [userController addScriptMessageHandler:self name:@"AppModel"];
    /*
    //  js注入，注入一个测试方法。
//    NSString *javaScriptSource = LoadBundleFile(@"MyJs.js");
    // @"function userFunc(){window.webkit.messageHandlers.AppModel.postMessage({body:'传数据'})}";
    //   forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
//    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
//    [userController addUserScript:userScript];
    */
    config.userContentController = userController;
    
    // 5.创建：WKWebView
    WKWebView * WK = [[WKWebView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30) configuration:config];
    WK.navigationDelegate = self;
    WK.UIDelegate = self;
    [self.view addSubview:WK];
    
    // 添加自定义js代码
    NSString *temp = LoadBundleFile(@"webString.html");
    NSString *js = LoadBundleFile(@"MyJs.js");
    js = [js stringByAppendingString:@"</body>"];
    temp = [temp stringByReplacingOccurrencesOfString:@"</body>" withString:js];
    
    // 加载html页面
    [WK loadHTMLString:temp baseURL: nil];
}


#pragma mark -
#pragma mark - < WKScriptMessageHandler >
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //这里可以获取到JavaScript传递进来的消息
    NSLog(@"4.message --> %@ --> %@", message.name, message.body);
}

#pragma mark -
#pragma mark - < WKNavigationDelegate >

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // 类似UIWebView的 -webViewDidStartLoad:  页面开始加载时调用
    NSLog(@"2.didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //内容开始返回时调用
    NSLog(@"3.didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 类似 UIWebView 的 －webViewDidFinishLoad:  页面加载完成时调用
    NSLog(@"5.didFinishNavigation");
//    [self resetControl];
    if (webView.title.length > 0) {
        self.title = webView.title;
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:  页面加载失败时调用
    NSLog(@"6.didFailProvisionalNavigation");
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //这个代理方法表示当客户端收到服务器的响应头，根据response相关信息，可以决定这次跳转是否可以继续进行
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"7.decisionHandler");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:
(WKNavigation *)navigation
{
    //接收到服务器跳转请求之后调用
    NSLog(@"8.didReceiveServer");
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:
(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
//    在发送请求之前，决定是否跳转
    NSLog(@"1.shouldStartLoad --> %@",navigationAction.request);
    NSString *url = [navigationAction.request.URL.absoluteString
                     stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
}

#pragma mark -
#pragma mark - < WKUIDelegate >

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//    // 接口的作用是打开新窗口委托

    return nil;
}
@end
