//
//  TTFirstViewController.m
//  TTScrollContentViewDemo
//
//  Created by 宁小陌 on 2018/12/6.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TTFirstViewController.h"
#import "TTBaseTableView.h"
#import "WMPageController.h"

#import "TTFirstTableViewController.h"
#import "TTSecondViewController.h"
#import "TTThirdViewController.h"
#import "TTRootViewController.h"

@interface TTFirstViewController ()<UITableViewDelegate,UITableViewDataSource,WMPageControllerDelegate>
@property(nonatomic ,strong)TTBaseTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,assign)BOOL canScroll;
@end

static CGFloat const headViewHeight = 256;
@implementation TTFirstViewController
@synthesize mainTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.canScroll = YES;
    self.navigationItem.title = @"简书个人中心页面";
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [kNotificationCenter addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headImageView];
    [self.mainTableView addSubview:self.button];
}

- (void) buttonClick:(UIButton *)sender{
    TTRootViewController *vc = [[TTRootViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}
-(void)MainTableScroll:(NSNotification *)user{
    
    self.canScroll = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==mainTableView) {
        
        CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y;
        NSLog(@"tabOffsetY:%f",offsetY);
        if (offsetY>=tabOffsetY) {
            self.canScroll = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            [kNotificationCenter postNotificationName:@"childScrollCan" object:nil];
        }else{
            if (!self.canScroll) {
                [scrollView setContentOffset:CGPointZero];
            }
        }
    }
}

#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kScreenHeight-kNavBarHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}


#pragma mark -- setter/getter

-(UIView *)setPageViewControllers {
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"Line";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    pageController.view.backgroundColor = [UIColor redColor];
    pageController.progressWidth = 25;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    TTFirstTableViewController * oneVc  = [TTFirstTableViewController new];
    TTSecondViewController * twoVc  = [TTSecondViewController new];
    TTThirdViewController * thirdVc  = [TTThirdViewController new];
    
    NSArray *viewControllers = @[oneVc,twoVc,thirdVc];
    
    NSArray *titles = @[@"关注",@"推荐",@"喜欢"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    pageVC.delegate = self;
    pageVC.menuItemWidth = 50;
    pageVC.menuHeight = 44;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@",viewController);
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(0, -headViewHeight ,kScreenWidth,headViewHeight);
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,kScreenWidth,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (TTBaseTableView *)mainTableView {
    if (mainTableView == nil){
        mainTableView= [[TTBaseTableView alloc]initWithFrame:CGRectMake(0,64,kScreenWidth,kScreenHeight-kNavBarHeight)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
        mainTableView.bounces = NO;
    }
    return mainTableView;
}

@end
