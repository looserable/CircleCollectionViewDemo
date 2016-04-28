//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by john on 16/4/27.
//  Copyright © 2016年 jhon. All rights reserved.
//

#import "ViewController.h"
#import "CircleCell.h"
#import "CircleCollectionviewLayout.h"
@interface ViewController ()<UICollectionViewDataSource>
{
    UICollectionView * CirclecollectionView;
    NSInteger _cellCount;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _cellCount = 20;
    CircleCollectionviewLayout * circleLayout = [[CircleCollectionviewLayout alloc]init];
    
    CirclecollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:circleLayout];
    CirclecollectionView.dataSource = self;
    [CirclecollectionView registerClass:[CircleCell class] forCellWithReuseIdentifier:@"circleCell"];
    CirclecollectionView.backgroundColor = [UIColor whiteColor];
    [CirclecollectionView reloadData];
    
    
    [self.view addSubview:CirclecollectionView];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [CirclecollectionView addGestureRecognizer:tap];

    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"circleCell" forIndexPath:indexPath];
    return cell;
}

- (void)tapClick:(UITapGestureRecognizer *)sender{
//    求出点击的位置与坐标
    CGPoint point = [sender locationInView:CirclecollectionView];
//    根据坐标去求取它在collectionview中是哪一个item
    NSIndexPath * tapIndexPath = [CirclecollectionView indexPathForItemAtPoint:point];
//    如果这个对应的item有值，证明存在，那么删除该item
    if (tapIndexPath) {
//        首先需要把数据从数据源里面剔除，保证程序不会崩溃
        _cellCount -= 1;
//        这个操作会出发layout里面的动画。
        [CirclecollectionView performBatchUpdates:^{
            [CirclecollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:tapIndexPath]];
        } completion:nil];
    }else{//反之，如果不存在，那么应该添加一个item
        _cellCount += 1;
        [CirclecollectionView performBatchUpdates:^{
            [CirclecollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:nil];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
