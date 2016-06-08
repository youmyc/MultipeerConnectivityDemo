//
//  ConnectionsViewController.m
//  MultipeerConnectivityDemo
//
//  Created by youmy on 16/6/1.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "AppDelegate.h"

@interface ConnectionsViewController()<MCBrowserViewControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) AppDelegate * appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices; // 设备列表
@end

@implementation ConnectionsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // 我们使用sharedApplication类方法初始化appDelegate对象。这样操作之后，我们能够调用mcManager对象任何需要的公共方法，这正是我们接下来要做的
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate mcManager] advertiseSelf:_swVisible.isOn];
    
    [_txtName setDelegate:self];
    
    // 状态通知 有三个状态： MCSessionStateConnected , MCSessionStateConnecting  and  MCSessionStateNotConnected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    // 初始化数据源
    _arrConnectedDevices = [[NSMutableArray alloc] init];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)browseForDevices:(id)sender{
    // 初始化浏览器对象
    [[_appDelegate mcManager] setupMCBrowser];
    // 设置浏览器对象代理
    [[[_appDelegate mcManager] browser] setDelegate:self];
    // 模态打开MCBrowserViewController
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}
- (IBAction)toggleVisibility:(id)sender{
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
}
- (IBAction)disconnect:(id)sender{
    // 断开连接
    [_appDelegate.mcManager.session disconnect];
    // 输入框设为可编辑
    _txtName.enabled = YES;
    // 清空设备列表
    [_arrConnectedDevices removeAllObjects];
    [_tblConnectedDevices reloadData];
}

#pragma mark - MCBrowserViewControllerDelegate
// 当点击Done按钮时触发
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

// 当点击cancel按钮时触发
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtName resignFirstResponder];
    
    _appDelegate.mcManager.peerID = nil;
    _appDelegate.mcManager.session = nil;
    _appDelegate.mcManager.browser = nil;
    
    if ([_swVisible isOn]) {
        [_appDelegate.mcManager.advertiser stop];
    }
    _appDelegate.mcManager.advertiser = nil;
    
    // 将输入框的值作为设备名称
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtName.text];
    [_appDelegate.mcManager setupMCBrowser];
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
    return YES;
}

#pragma mark - notification
- (void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    // 设备ID
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    // 设备名称
    NSString *peerDisplayName = peerID.displayName;
    // 会话状态
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) { // 正在连接
        if (state == MCSessionStateConnected) { // 已连接
            [_arrConnectedDevices addObject:peerDisplayName]; // 将其添加到数组中
        }
        else if (state == MCSessionStateNotConnected){ // 断开连接
            if ([_arrConnectedDevices count] > 0) {
                // 找到已连接的设备
                NSInteger indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
                // 将其从数据中移除
                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
            }
        }
        
        // 刷新设备列表
        [_tblConnectedDevices reloadData];
        
        BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
        [_btnDisconnect setEnabled:!peersExist];
        [_txtName setEnabled:peersExist];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrConnectedDevices count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
@end
