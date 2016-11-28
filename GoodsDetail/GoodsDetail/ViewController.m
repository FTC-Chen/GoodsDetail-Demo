//
//  ViewController.m
//  GoodsDetail
//
//  Created by anyongxue on 2016/11/28.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "ViewController.h"


#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UITableView *couTableView;

@property (nonatomic,strong)UIWebView *couWebView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ViewController
{
    CGFloat minY;
    
    CGFloat maxY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //简易的上拉阻力加载  上不为tableView  下部为webview
    [self ceratTableView];

    //tableView下面添加一个webview
    [self ceratWebView];
}


- (void)ceratTableView{
    
    //创背景视图
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 2*KScreenHeight)];
    
    [self.view addSubview:self.bgView];
    
    
    _couTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, KScreenHeight-30) style:UITableViewStylePlain];
    
    [_couTableView setDelegate:self];
    
    [_couTableView setDataSource:self];
    
    //创建tableView的尾部视图
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.couTableView.frame), KScreenWidth, 44)];
    
    footView.backgroundColor =[UIColor colorWithRed:0.85 green:0.85 blue:0.7 alpha:1];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, (44-16)/2, KScreenWidth-160, 16)];
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.text = @"继续拖动,查看详情";
    footLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    footLabel.font = [UIFont systemFontOfSize:13];
    [footView addSubview:footLabel];
    
    [_couTableView setTableFooterView:footView];
    
    [self.bgView addSubview:self.couTableView];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier=@"mainCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"商品详情,阻力上拉";
    
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    
    return cell;
}

- (void)ceratWebView{
   
    self.couWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.couTableView.frame), KScreenWidth, KScreenHeight)];
    
    self.couWebView.scrollView.delegate = self;
    
    self.couWebView.delegate = self;
    
    [self.couWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.hao123.com"]]];
    
    [self.bgView addSubview:self.couWebView];
    
}

/*  每次拖拽都会回调
*  @param decelerate YES时，为滑动减速动画，NO时，没有滑动减速动画
*/
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate) {
        
        CGFloat offset = scrollView.contentOffset.y;

        NSLog(@"%f",offset);
        
        if (scrollView == self.couTableView) {
            
            if (offset<0) {
                minY = MIN(minY, offset);
            }else{
                maxY = MAX(maxY, offset);
            }
        }else{
            
            minY = MIN(minY, offset);
        }
        
        //上拉
        CGFloat maxTopDragHeight = 100;
    
        //滚到webView页面
        if (maxY >= self.couTableView.contentSize.height-KScreenHeight+maxTopDragHeight) {
            
            [UIView animateWithDuration:0.4 animations:^{
            
                self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, - (KScreenHeight));
           
            } completion:^(BOOL finished) {
                maxY = 0.0f;
            }];
        }
        
        //上拉
        CGFloat maxBottomDragHeight = 80;
        
        //滚动到tableView
        if (minY <= -maxBottomDragHeight) {
            
            [UIView animateWithDuration:0.4 animations:^{
               
                self.bgView.transform = CGAffineTransformIdentity;
            
            } completion:^(BOOL finished) {
        
                minY = 0.0f;
            }];

        }
    
    }
}


- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
