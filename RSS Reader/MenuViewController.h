//
//  MenuViewController.h
//  RSS Reader
//
//  Created by GaoYu on 14-4-21.
//  Copyright (c) 2014年 GaoYu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuViewController : UITableViewController

@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (nonatomic, retain)NSString *str;

@end
