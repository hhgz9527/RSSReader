//
//  AppDelegate.h
//  RSS Reader
//
//  Created by GaoYu on 14-4-16.
//  Copyright (c) 2014年 GaoYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord.h>
#import <MSDynamicsDrawerViewController.h>
@class MSDynamicsDrawerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,MSDynamicsDrawerViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (nonatomic, strong) UIImageView *windowBackground;

@end
