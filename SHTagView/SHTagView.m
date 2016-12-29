//
//  SHTagView.m
//  SHTagViewDemo
//
//  Created by zhugang on 16/12/28.
//  Copyright © 2016年 shihao. All rights reserved.
//

#import "SHTagView.h"
#define SWeight [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height
#define tagButtonW 90
@interface SHTagView()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *tagButtons;
@property (nonatomic, strong) NSMutableArray *childVCViews;

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIScrollView *tagScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *childControllers;
@end

@implementation SHTagView
- (id)initWithFrame:(CGRect)frame AndChildVCs:(NSArray*)vcArray
{
    if (self=[super initWithFrame:frame]) {
        [self.childControllers addObjectsFromArray:vcArray];
        [self createUI];
    }
    return self;
}

#pragma mark 创建UI
- (void)createUI
{
    UIScrollView *tagSv = [[UIScrollView alloc] init];
    tagSv.frame = CGRectMake(0, 0, SWeight, 44);
    tagSv.showsHorizontalScrollIndicator = NO;
    CGFloat tagContentSizeX = self.childControllers.count * tagButtonW>SWeight?self.childControllers.count * tagButtonW:SWeight;
    tagSv.contentSize = CGSizeMake(tagContentSizeX, 0);
    [self addSubview:tagSv];
    _tagScrollView = tagSv;

    UIScrollView *contentSv = [[UIScrollView alloc] init];
    CGFloat y = CGRectGetMaxY(tagSv.frame);
    contentSv.frame = CGRectMake(0, y, SWeight,SHeight - y);
    contentSv.pagingEnabled = YES;
    contentSv.bounces = NO;
    contentSv.showsHorizontalScrollIndicator = NO;
    contentSv.delegate = self;
    contentSv.contentSize = CGSizeMake(self.childControllers.count * SWeight, 0);
    [self addSubview:contentSv];
    _contentScrollView = contentSv;
    
    for (NSInteger i = 0; i < self.childControllers.count; i++) {
        UIViewController*vc = self.childControllers[i];
        UIButton *tagBtn = [[UIButton alloc]init];
        tagBtn.tag = i;
        [tagBtn setTitle:vc.title forState:UIControlStateNormal];
        tagBtn.frame = CGRectMake(tagButtonW*i, 0, tagButtonW, CGRectGetHeight(tagSv.frame));
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagButtons addObject:tagBtn];
        if (i == 0) {
            [self tagClick:tagBtn];
        }
        [_tagScrollView addSubview:tagBtn];
    }
    
}
#pragma mark 增加新的栏目
- (void)addOneChildController:(UIViewController*)controller;
{
    [self.childControllers addObject:controller];
    CGFloat tagContentSizeX = self.childControllers.count * tagButtonW>SWeight?self.childControllers.count * tagButtonW:SWeight;
    self.tagScrollView.contentSize = CGSizeMake(tagContentSizeX, 0);
    self.contentScrollView.contentSize = CGSizeMake(self.childControllers.count * SWeight, 0);
    UIButton *tagBtn = [[UIButton alloc]init];
    tagBtn.tag = self.childControllers.count-1;
    [tagBtn setTitle:controller.title forState:UIControlStateNormal];
    tagBtn.frame = CGRectMake(tagButtonW*tagBtn.tag, 0, tagButtonW, CGRectGetHeight(self.tagScrollView.frame));
    [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tagBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tagButtons addObject:tagBtn];
    [self.tagScrollView addSubview:tagBtn];
}
#pragma mark 删除一个栏目
- (void)removeOneChildController:(NSInteger)index
{
    UIViewController*removeVC = self.childControllers[index];
    [removeVC.view removeFromSuperview];
    [removeVC removeFromParentViewController];
    [self.childControllers removeObjectAtIndex:index];
    
    self.contentScrollView.contentSize = CGSizeMake(self.childControllers.count * SWeight, 0);
    for (NSInteger i = 0; i<self.childControllers.count; i++) {
        UIViewController*vc = self.childControllers[i];
        vc.view.frame = CGRectMake(i*SWeight, 0, SWeight , CGRectGetHeight(self.contentScrollView.frame));
    }
    
    UIButton*removeBtn = self.tagButtons [index];
    BOOL isSelect ;
    if (removeBtn == _selectButton) {
        isSelect = YES;
    }else{
        isSelect = NO;
    }
    [removeBtn removeFromSuperview];
    [self.tagButtons removeObjectAtIndex:index];
    CGFloat tagContentSizeX = self.tagButtons.count * tagButtonW>SWeight?self.tagButtons.count * tagButtonW:SWeight;
    self.tagScrollView.contentSize = CGSizeMake(tagContentSizeX, 0);
    for (NSInteger i = 0; i<self.tagButtons.count; i++) {
        UIButton*btn = self.tagButtons[i];
        btn.tag = i;
        if (isSelect) {
            if (i == 0) {
                [self tagClick:btn];
            }
        }
        btn.frame = CGRectMake(tagButtonW*i, 0, tagButtonW, CGRectGetHeight(self.tagScrollView.frame));
    }

    
}
#pragma mark 按钮点击事件
- (void)tagClick:(UIButton*)sender
{
    [self selectButton:sender];
    [self addChildVC:sender.tag];
    self.contentScrollView.contentOffset = CGPointMake(sender.tag*SWeight, 0);
    if ([self.delegate respondsToSelector:@selector(tagButtonClick:)]) {
        [self.delegate tagButtonClick:sender];
    }
}
//选中某个按钮做处理
- (void)selectButton:(UIButton *)sender
{
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    CGFloat offsetX = sender.center.x - SWeight * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.tagScrollView.contentSize.width - SWeight;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.tagScrollView setContentOffset: CGPointMake(offsetX, 0) animated:YES];
    _selectButton = sender;

}
//往contentScrollView增加controller的view
- (void)addChildVC:(NSInteger)index
{
    UIViewController *vc = self.childControllers[index];
    if (vc.view.superview) {
        return;
    }
    CGFloat x = index * SWeight;
    vc.view.frame = CGRectMake(x, 0, SWeight , CGRectGetHeight(self.contentScrollView.frame));
    [self.childVCViews addObject:vc.view];
    [self.contentScrollView addSubview:vc.view];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x / SWeight;
    UIButton *tagButton = self.tagButtons[i];
    [self selectButton:tagButton];
    [self addChildVC:i];
}
#pragma mark 懒加载
- (NSMutableArray*)tagButtons
{
    if (_tagButtons==nil) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}
- (NSMutableArray*)childVCViews
{
    if (_childVCViews==nil) {
        _childVCViews = [NSMutableArray array];
    }
    return _childVCViews;
}

- (NSMutableArray*)childControllers
{
    if (_childControllers==nil) {
        _childControllers = [NSMutableArray array];
    }
    return _childControllers;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
