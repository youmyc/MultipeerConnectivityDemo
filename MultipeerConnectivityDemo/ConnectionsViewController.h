//
//  ConnectionsViewController.h
//  MultipeerConnectivityDemo
//
//  Created by youmy on 16/6/1.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectionsViewController : UIViewController<MCBrowserViewControllerDelegate>
/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextField *txtName;
/** 是否让设备可见 */
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
/** 设备列表 */
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
/** 断开按钮 */
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;

/** 扫描设备 */
- (IBAction)browseForDevices:(id)sender;
/** 设备是否可见 */
- (IBAction)toggleVisibility:(id)sender;
/** 断开连接 */
- (IBAction)disconnect:(id)sender;
@end
