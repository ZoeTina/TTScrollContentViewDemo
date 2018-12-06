//
//  TTSegmentTitleView.h
//  TTScrollContentViewDemo
//
//  Created by 宁小陌 on 2018/12/6.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTSegmentTitleView;

typedef enum : NSUInteger {
    TTIndicatorTypeDefault,//默认与按钮长度相同
    TTIndicatorTypeEqualTitle,//与文字长度相同
    TTIndicatorTypeCustom,//自定义文字边缘延伸宽度
    TTIndicatorTypeNone,
} TTIndicatorType;//指示器类型枚举

@protocol TTSegmentTitleViewDelegate <NSObject>

@optional

/**
 *  切换标题
 *
 *  @param titleView FSSegmentTitleView
 *  @param startIndex 切换前标题索引
 *  @param endIndex 切换后标题索引
 */
- (void)TTSegmentTitleView:(TTSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 *  将要开始滑动
 *
 *  @param titleView TTSegmentTitleView
 */
- (void)TTSegmentTitleViewWillBeginDragging:(TTSegmentTitleView *)titleView;

/**
 *  将要停止滑动
 *
 *  @param titleView TTSegmentTitleView
 */
- (void)TTSegmentTitleViewWillEndDragging:(TTSegmentTitleView *)titleView;

@end

@interface TTSegmentTitleView : UIView

@property (nonatomic, weak) id<TTSegmentTitleViewDelegate>delegate;

/// 标题文字间距，默认20
@property (nonatomic, assign) CGFloat itemMargin;

/// 当前选中标题索引，默认0
@property (nonatomic, assign) NSInteger selectIndex;

/// 标题字体大小，默认15
@property (nonatomic, strong) UIFont *titleFont;

/// 标题选中字体大小，默认15
@property (nonatomic, strong) UIFont *titleSelectFont;

/// 标题正常颜色，默认black
@property (nonatomic, strong) UIColor *titleNormalColor;

/// 标题选中颜色，默认red
@property (nonatomic, strong) UIColor *titleSelectColor;

/// 指示器颜色，默认与titleSelectColor一样,在TTIndicatorTypeNone下无效
@property (nonatomic, strong) UIColor *indicatorColor;

/// 在FSIndicatorTypeCustom时可自定义此属性，为指示器一端延伸长度，默认5
@property (nonatomic, assign) CGFloat indicatorExtension;

/**
 *  对象方法创建FSSegmentTitleView
 *
 *  @param frame frame
 *  @param titlesArr 标题数组
 *  @param delegate delegate
 *  @param incatorType 指示器类型
 *  @return FSSegmentTitleView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<TTSegmentTitleViewDelegate>)delegate indicatorType:(TTIndicatorType)incatorType;

@end
