//
//  TTPageContentView.h
//  TTScrollContentViewDemo
//
//  Created by 宁小陌 on 2018/12/6.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTPageContentView;

@protocol TTPageContentViewDelegate <NSObject>

@optional

/**
 TTPageContentView开始滑动

 @param contentView FSPageContentView
 */
- (void)TTContentViewWillBeginDragging:(TTPageContentView *)contentView;

/**
 *  TTPageContentView滑动调用
 *
 *  @param contentView TTPageContentView
 *  @param startIndex 开始滑动页面索引
 *  @param endIndex 结束滑动页面索引
 *  @param progress 滑动进度
 */
- (void)TTContentViewDidScroll:(TTPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 *  TTPageContentView结束滑动
 *
 *  @param contentView TTPageContentView
 *  @param startIndex 开始滑动索引
 *  @param endIndex 结束滑动索引
 */
- (void)TTContenViewDidEndDecelerating:(TTPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 *  scrollViewDidEndDragging
 *
 *  @param contentView TTPageContentView
 */
- (void)TTContenViewDidEndDragging:(TTPageContentView *)contentView;

@end

@interface TTPageContentView : UIView

/**
 *  对象方法创建TTPageContentView
 *
 *  @param frame frame
 *  @param childVCs 子VC数组
 *  @param parentVC 父视图VC
 *  @param delegate delegate
 *  @return TTPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<TTPageContentViewDelegate>)delegate;

@property (nonatomic, weak) id<TTPageContentViewDelegate>delegate;

/// 设置contentView当前展示的页面索引，默认为0
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/// 设置contentView能否左右滑动，默认YES
@property (nonatomic, assign) BOOL contentViewCanScroll;

@end
