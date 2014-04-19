//
//  ContentViewController.m
//  RSS 阅读器
//
//  Created by GaoYu on 14-4-16.
//  Copyright (c) 2014年 GaoYu. All rights reserved.
//

#import "ContentViewController.h"
#import "Entry.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self getContent];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //从CoreData中取得内容
    NSMutableArray *content_arr = [[NSMutableArray alloc] init];
    NSArray *arr = [Entry MR_findAllSortedBy:@"content" ascending:NO];
    for (NSManagedObjectContext *c in arr) {
        [content_arr addObject:[c valueForKey:@"content"]];
    }
    NSString *str = [NSString stringWithFormat:@"%@",content_arr[_indexrow]];
    //才发现webview直接可以解析html，现在可以正常显示文本了，不过尺寸有点问题，最下方有一行字在屏幕外面
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [webview loadHTMLString:str baseURL:nil];
    [self.view addSubview:webview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getContent{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    //设置要检索那种类型的实体对象
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:appDelegate.managedObjectContext];
//    //    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
//    //    NSArray *arr = [[NSArray alloc] initWithObjects:sort, nil];
//    //创建取回数据请求
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    //指定结果的排序
//    //    [request setSortDescriptors:arr];
//    //设置请求实体
//    [request setEntity:entity];
//    
//    NSError *error = nil;
//    NSMutableArray *result1 = [[appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    if (request == nil) {
//        NSLog(@"%@",error);
//    }
//    result = [[NSMutableArray alloc] init];
//    for (NSManagedObject *enti in result1) {
//        [result addObject:[enti valueForKey:@"content"]];
//    }
}
@end
