//
//  AppDelegate.h
//  MultipeerConnectivityDemo
//
//  Created by youmy on 16/6/1.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MCManager * mcManager;

@end

