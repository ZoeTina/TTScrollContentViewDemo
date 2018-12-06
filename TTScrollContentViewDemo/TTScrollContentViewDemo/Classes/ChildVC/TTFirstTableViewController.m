//
//  TTFirstTableViewController.m
//  TTScrollContentViewDemo
//
//  Created by 宁小陌 on 2018/12/6.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TTFirstTableViewController.h"

@interface TTFirstTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic ,strong)UITableView * myTableView;
@end

@implementation TTFirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-64-35)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"homePageCellIdentifier%@",indexPath ];
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"onetableForIndex.row =%ld",indexPath.row];
    
    return cell;
}

@end
