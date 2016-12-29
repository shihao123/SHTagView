//
//  ViewController.m
//  SHTagViewDemo
//
//  Created by zhugang on 16/12/28.
//  Copyright © 2016年 shihao. All rights reserved.
//

#import "ViewController.h"
#import "SHTagView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
@interface ViewController ()<tagClickDelegate>
@property(nonatomic,strong)SHTagView*tagView;
@property(nonatomic,assign)NSInteger selectTag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"1111");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"SHTagViewDemo";
    self.selectTag = 0;
    UIBarButtonItem*rigntitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVC)];
    self.navigationItem.rightBarButtonItem = rigntitem;
    
    UIBarButtonItem*leftitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(removeVC)];
    self.navigationItem.leftBarButtonItem = leftitem;

    [self.view addSubview:self.tagView];
}
//新增栏目
- (void)addVC
{
    OneViewController*ovc = [[OneViewController alloc]init];
    [self addChildViewController:ovc];
    ovc.title = @"新增";
    [self.tagView addOneChildController:ovc];
}
//删除栏目
- (void)removeVC
{
    [self.tagView removeOneChildController:self.selectTag];
}

- (NSArray*)addChildVC
{
    OneViewController*ovc = [[OneViewController alloc]init];
    ovc.title = @"要闻";
    [self addChildViewController:ovc];

    TwoViewController*tvc = [[TwoViewController alloc]init];
    tvc.title = @"直播";
    [self addChildViewController:tvc];

    ThreeViewController*thvc = [[ThreeViewController alloc]init];
    thvc.title = @"最新";
    [self addChildViewController:thvc];

    FourViewController*fvc = [[FourViewController alloc]init];
    fvc.title = @"社会";
    [self addChildViewController:fvc];

    FiveViewController*fivc = [[FiveViewController alloc]init];
    fivc.title = @"国际";
    [self addChildViewController:fivc];
    
    NSArray*vcArr = @[ovc,tvc,thvc,fvc,fivc];
    
    return vcArr;
}
#pragma mark tagViewDelegate
- (void)tagButtonClick:(UIButton *)sender
{
    self.selectTag = sender.tag;
    NSLog(@"点击了第%ld个",sender.tag);
}
#pragma mark 懒加载
- (SHTagView*)tagView
{
    if (_tagView==nil) {
        NSArray*vcArr = [self addChildVC];
        _tagView = [[SHTagView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) AndChildVCs:vcArr];
        _tagView.delegate = self;
    }
    return _tagView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
