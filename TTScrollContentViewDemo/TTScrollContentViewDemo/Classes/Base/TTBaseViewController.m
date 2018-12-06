//
//  TTBaseViewController.m
//  TTScrollContentViewDemo
//
//  Created by 宁小陌 on 2018/12/6.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTBaseViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,assign)BOOL can_scroll;
@property(nonatomic,strong)UIScrollView *scrollview;

@end

@implementation TTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [kNotificationCenter addObserver:self selector:@selector(childScrollStop:) name:@"childScrollStop" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(childScrollStop:) name:@"childScrollCan" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(childScrollStop:) name:@"MainTableScroll" object:nil];
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

-(void)childScrollStop:(NSNotification *)user{
    if ([user.name isEqualToString:@"childScrollStop"]) {
        self.can_scroll = NO;
        [self.scrollview setContentOffset:CGPointZero];
        
    }else if ([user.name isEqualToString:@"childScrollCan"]){
        self.can_scroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        self.can_scroll = NO;
        [self.scrollview setContentOffset:CGPointZero];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_can_scroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (scrollView.contentOffset.y<=0) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainTableScroll" object:nil];
    }
    self.scrollview = scrollView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
