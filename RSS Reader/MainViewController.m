//
//  MainViewController.m
//  RSS 阅读器
//
//  Created by GaoYu on 14-4-13.
//  Copyright (c) 2014年 GaoYu. All rights reserved.
//

#import "MainViewController.h"
#import "Entry.h"
#import "ContentViewController.h"



@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRssAddress)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(readed)];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 66)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    title_arr = [[NSMutableArray alloc] init];
    content_arr = [[NSMutableArray alloc] init];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    
//    NSArray *arr = [Entry MR_findAll];
//    if (arr != nil) {
//        for (NSManagedObjectContext *context in arr) {
//            [title_arr addObject:[context valueForKey:@"title"]];
//        }
//        [table reloadData];
//    }

}

-(void)readed{
    //查看存储的数据
//    NSArray *arr = [Entry MR_findAllSortedBy:@"title" ascending:NO];
//    NSLog(@"%@",arr);
//    for (NSManagedObjectContext *context in arr) {
//        NSLog(@"%@",[context valueForKey:@"title"]);
//    }
    [self deleteTitleinCoreData];
    [table reloadData];
}

-(void)parse:(NSString *)url{
    //解析xml，完成后刷新tableview
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _party = [RssParser loadParty:url];
        if (_party != nil) {
            [RssParser saveParty:_party];
            for (rss in _party.arr) {
                NSLog(@"标题：%@",rss.title);
                [title_arr addObject:rss.title];
                [content_arr addObject:rss.content];
                NSLog(@"%@",title_arr);
            }
            [table reloadData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程中本地缓存
            for (int i = 0; i<title_arr.count; i++) {
                Entry *entry = [Entry MR_createEntity];
                entry.title = [NSString stringWithFormat:@"%@",[title_arr objectAtIndex:i]];
                entry.content = [NSString stringWithFormat:@"%@",[content_arr objectAtIndex:i]];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        });
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addRssAddress{
    
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"输入地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeURL;
    textField.text = @"http://";
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            //解析
            [self parse:textField.text];
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return title_arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[title_arr objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentViewController *content = [[ContentViewController alloc] init];
    [self.navigationController pushViewController:content animated:YES];
    content.indexrow = indexPath.row;
}

-(void)deleteTitleinCoreData{
    //删除存储的
    NSArray *entry = [Entry MR_findAll];
    for (Entry *tmp in entry) {
        [tmp MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

}


@end
