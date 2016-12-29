# SHTagView
标签菜单栏封装

效果图

![image](http://github.com/shihao123/SHTagView/demogif.gif)

1.将SHTagView.h和SHTagView.m文件加入工程

2.引入头文件#import "SHTagView.h"

3.加入代理<tagClickDelegate>

4.创建SHTagView对象，传入参数即可

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
    
    _tagView = [[SHTagView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) AndChildVCs:vcArr];
    _tagView.delegate = self;
    [self.view addSubview:_tagView];
    
5.标签点击回调方法

- (void)tagButtonClick:(UIButton *)sender
{
}

6.增加新的栏目

    OneViewController*ovc = [[OneViewController alloc]init];
    [self addChildViewController:ovc];
    ovc.title = @"新增";
    [self.tagView addOneChildController:ovc];
    
7.删除一个栏目

    [self.tagView removeOneChildController:self.selectTag];
 参数为该栏目所在位置
