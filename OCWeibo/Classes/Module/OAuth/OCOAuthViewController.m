//
//  OCOAuthViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/20.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCOAuthViewController.h"
#import "OCUserAccount.h"
#import "OCUserAccountViewModel.h"
#import <SVProgressHUD.h>

@interface OCOAuthViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation OCOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [SVProgressHUD showWithStatus:@"正在加载中..."];
  NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", client_id, redirect_uri];
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
  [self setUpNav];
}

/**
 * 设置导航栏
 */
- (void)setUpNav{
  self.navigationItem.title = @"登录";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"填充" style:UIBarButtonItemStylePlain target:self action:@selector(fill)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
}
/**
 * 替换view为webView
 */
- (void)loadView {
  UIWebView *webView = [[UIWebView alloc] init];
  self.view = webView;
  webView.delegate = self;
  self.webView = webView;
}

#pragma mark 点击事件
- (void)fill {
  NSString *jsString = @"document.getElementById('userId').value='18819457942'; document.getElementById('passwd').value='maple123456'";
  [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)cancle {
  [SVProgressHUD dismiss];
  [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [SVProgressHUD dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *urlString = request.URL.absoluteString;
  NSString *codePrefix = @"code=";
  //拦截回调地址，获得code
  if ([urlString hasPrefix:@"http://www.baidu.com"]) {
    if ([request.URL.query hasPrefix:codePrefix]) {
      //截取code
      NSString *code = [request.URL.query substringFromIndex:codePrefix.length];
      [[OCUserAccountViewModel sharedAccountViewModel] saveAccessTokenWithCode:code completion:^(NSError *error) {
        if (error) {
          //加载失败
          [SVProgressHUD showErrorWithStatus:@"加载accessToken失败"];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cancle];
          });
        }else {
          //加载成功
          [self cancle];
        }
      }];
    }
    return NO;
  }else {
    return YES;
  }
}

@end
