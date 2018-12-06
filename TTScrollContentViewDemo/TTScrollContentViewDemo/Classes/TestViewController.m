//
//  TestViewController.m
//  TTScrollContentViewDemo
//
//  Created by 宁小陌 on 2018/12/6.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TestViewController.h"
#import "TTScrollContentView.h"
#import "ChildViewController.h"

@interface TestViewController ()<TTPageContentViewDelegate,TTSegmentTitleViewDelegate>
@property (nonatomic, strong) TTPageContentView *pageContentView;
@property (nonatomic, strong) TTSegmentTitleView *titleView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"pageContentView";
    self.titleView = [[TTSegmentTitleView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 50) titles:@[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电",@"其他"] delegate:self indicatorType:TTIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:15];
    self.titleView.selectIndex = 2;
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in @[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电",@"其他"]) {
        ChildViewController *vc = [[ChildViewController alloc]init];
        vc.title = title;
        [childVCs addObject:vc];
    }
    self.pageContentView = [[TTPageContentView alloc]initWithFrame:CGRectMake(0, 114, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 2;
//    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.view addSubview:_pageContentView];
}

#pragma mark --
- (void)TTSegmentTitleView:(TTSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
    self.title = @[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电",@"其他"][endIndex];
}

- (void)TTContenViewDidEndDecelerating:(TTPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    self.title = @[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电",@"其他"][endIndex];
}


@end
