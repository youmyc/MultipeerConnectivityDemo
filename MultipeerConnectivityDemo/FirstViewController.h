//
//  FirstViewController.h
//  MultipeerConnectivityDemo
//
//  Created by youmy on 16/6/1.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface FirstViewController : UIViewController <UITextFieldDelegate>
/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
/** 聊天窗口 */
@property (weak, nonatomic) IBOutlet UITextView *tvChat;
/** AppDelegate */
@property (nonatomic, strong) AppDelegate * appDelegate;
/** 确认发送消息 */
- (IBAction)sendMessage:(id)sender;
/** 取消发送消息 */
- (IBAction)cancelMessage:(id)sender;
@end

