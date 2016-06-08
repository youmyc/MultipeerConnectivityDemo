//
//  MCManager.h
//  MultipeerConnectivityDemo
//
//  Created by youmy on 16/6/1.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject<MCSessionDelegate>
/** PeerID 对象表示设备，它包含发现设备和建立会话阶段所需的各种属性 */
@property (nonatomic, strong) MCPeerID * peerID;
/** Session对象是最重要的，因为它代表目前的对等点（这个程序将运行的设备）将创建的会话 */
@property (nonatomic, strong) MCSession * session;
/** 浏览器对象，实际上是代表苹果提供的用于浏览其他对等点的默认UI */
@property (nonatomic, strong) MCBrowserViewController * browser;
/** 广告对象，这是用来从目前的设备去宣传自己，使其容易被发现 */
@property (nonatomic, strong) MCAdvertiserAssistant * advertiser;

/**
 *  初始化
 *
 *  @param displayName 提供给init方法(作为该方法的参数)一个设备名字，这个名字会出现在其他对等实体上
 */
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
/** 设置浏览器对象 */
-(void)setupMCBrowser;
/** 备是否应该广播自己 */
-(void)advertiseSelf:(BOOL)shouldAdvertise;
@end
