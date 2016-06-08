//
//  FirstViewController.m
//  MultipeerConnectivityDemo
//
//  Created by youmy on 16/6/1.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 声明并实例化一个 AppDelegate 对象
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // 接收到数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMyMessage];
    return YES;
}

#pragma mark - Actions
- (IBAction)sendMessage:(id)sender{
    [self sendMyMessage];
}

- (IBAction)cancelMessage:(id)sender{
    [_txtMessage resignFirstResponder];
}

// 发送消息
- (void)sendMyMessage{
    // 将信息转化为NSData（可以是图片或音频）
    NSData * dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    // 获取已连接的设备
    NSArray * allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError * error;
    
    // 利用session发送消息
    [_appDelegate.mcManager.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        // 打印错误描述
        NSLog(@"%@",error.localizedDescription);
    }
    
    // 将消息显示在聊天窗口中
    [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n",_txtMessage.text]]];
    // 清空输入框
    _txtMessage.text = @"";
    // 收回键盘
    [_txtMessage resignFirstResponder];
}

#pragma mark - notification
// 接收到的消息通知
- (void)didReceiveDataWithNotification:(NSNotification *)notification{
    // 发消息的设备peerID
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    // 发消息的设备名称
    NSString *peerDisplayName = peerID.displayName;
    // 消息内容
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    // 转换为文本内容
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    // 追加到聊天窗口
    [_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}
@end
