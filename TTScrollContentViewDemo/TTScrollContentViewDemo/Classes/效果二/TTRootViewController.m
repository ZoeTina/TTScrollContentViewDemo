//
//  TTRootViewController.m
//  TTScrollContentViewDemo
//
//  Created by 宁小陌 on 2018/12/6.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TTRootViewController.h"
#import "TTBaseTableView.h"
/// 多页滚动
#import "TTScrollContentView.h"
#import "TTFirstTableViewController.h"
#import "TTSecondViewController.h"
#import "TTThirdViewController.h"

#define kFontWithNameMedium     @"PingFang-SC-Medium"
#define kFontSizeMedium14 [UIFont fontWithName:kFontWithNameMedium size:14]
#define kWhiteColor kColorWithRGB(255,255,255)
static CGFloat const headViewHeight = 256;


@interface TTRootViewController ()<UITableViewDelegate,UITableViewDataSource,TTSegmentTitleViewDelegate,TTPageContentViewDelegate>
@property (nonatomic, strong) TTBaseTableView * mainTableView;
@property (nonatomic, strong) UIScrollView * parentScrollView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) TTSegmentTitleView *titleView;
@property (nonatomic, strong) TTPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *childVCs;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation TTRootViewController
@synthesize mainTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.canScroll = YES;
    self.navigationItem.title = @"简书个人中心页面";
    [kNotificationCenter addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    self.titleArray = @[@"推荐",@"关注"];
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headImageView];
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

- (void)MainTableScroll:(NSNotification *)user{
    self.canScroll = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==mainTableView) {
        CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y;
        YYLog(@"tabOffsetY:%f",offsetY);
        if (offsetY>=tabOffsetY) {
            self.canScroll = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"childScrollCan" object:nil];
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
     */
    [cell.contentView addSubview:self.titleView];
    [cell.contentView addSubview:self.pageContentView];
    cell.contentView.backgroundColor = kColorWithRGB(244, 244, 244);
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(35));
        make.width.equalTo(@(100));
        make.top.right.equalTo(cell.contentView);
    }];
    [self.pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
//        make.width.equalTo(@(kScreenWidth));
//        make.height.equalTo(@(kScreenHeight));
        make.left.right.bottom.equalTo(cell.contentView);
    }];
    return cell;
}

#pragma mark --
- (void)TTSegmentTitleView:(TTSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
    self.title = self.titleArray[endIndex];
}

- (void)TTContenViewDidEndDecelerating:(TTPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
    self.title = self.titleArray[endIndex];
}


-(UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,kScreenWidth,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

-(TTBaseTableView *)mainTableView {
    if (!mainTableView){
        mainTableView= [[TTBaseTableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor blueColor];
        mainTableView.bounces = NO;
    }
    return mainTableView;
}

- (TTSegmentTitleView *)titleView{
    if (!_titleView) {
        NSArray *titleArray = @[@"推荐",@"关注"];
        _titleView = [[TTSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)
                                                       titles:titleArray
                                                     delegate:self indicatorType:TTIndicatorTypeEqualTitle];
        _titleView.titleFont = kFontSizeMedium14;
        _titleView.titleSelectFont = kFontSizeMedium14;
        _titleView.titleNormalColor = kColorWithRGB(0, 0, 0);
        _titleView.titleSelectColor = kColorWithRGB(168, 20, 4);
        _titleView.indicatorColor = kColorWithRGB(168, 20, 4);
        _titleView.selectIndex = 0;
        _titleView.backgroundColor = kColorWithRGB(244, 244, 244);
    }
    return _titleView;
}

- (TTPageContentView *)pageContentView{
    if (!_pageContentView) {
        _pageContentView = [[TTPageContentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)
                                                          childVCs:self.childVCs
                                                          parentVC:self
                                                          delegate:self];
        self.pageContentView.contentViewCurrentIndex = 0;
//        self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    }
    return _pageContentView;
}

- (NSMutableArray *)childVCs{
    if (!_childVCs) {
        _childVCs = [[NSMutableArray alloc] init];
        for (NSString *title in self.titleArray) {
            TTFirstTableViewController *vc = [[TTFirstTableViewController alloc]init];
            vc.title = title;
            [_childVCs addObject:vc];
        }
    }
    return _childVCs;
}

@end
