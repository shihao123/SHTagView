//
//  SHTagView.h
//  SHTagViewDemo
//
//  Created by zhugang on 16/12/28.
//  Copyright © 2016年 shihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tagClickDelegate <NSObject>

- (void)tagButtonClick:(UIButton*)sender;

@end
@interface SHTagView : UIView
@property(nonatomic,assign)id<tagClickDelegate>delegate;
- (id)initWithFrame:(CGRect)frame AndChildVCs:(NSArray*)vcArray;
- (void)addOneChildController:(UIViewController*)controller;
- (void)removeOneChildController:(NSInteger)index;
@end
