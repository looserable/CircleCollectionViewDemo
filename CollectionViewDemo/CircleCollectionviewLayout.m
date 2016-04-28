//
//  CircleFlowLayout.m
//  CollectionViewDemo
//
//  Created by john on 16/4/27.
//  Copyright © 2016年 jhon. All rights reserved.
//

#import "CircleCollectionviewLayout.h"
#define ITEM_SIZE 70

@interface CircleCollectionviewLayout()
//cell的数量
@property (nonatomic,assign)NSInteger cellCount;
//圆心的坐标
@property (nonatomic,assign)CGPoint center;
//直径的长度
@property (nonatomic,assign)CGFloat radius;
//保存删除的indexPath的数组
@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
//保存插入的indexPath的数组
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end

@implementation CircleCollectionviewLayout

//布局前的一些准备工作
-(void)prepareLayout{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _center = CGPointMake(size.width/2.0, size.height/2.0);
    _radius = MIN(size.width, size.height)/2.5;
}
//设置collectionView的contentSize，类似于ScrollView的contentSize
-(CGSize)collectionViewContentSize{
    [super collectionViewContentSize];
    return self.collectionView.frame.size;
}

//设置每一个item相关属性，大小，坐标
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attribute.center = CGPointMake(_center.x + _radius * cosf(2*indexPath.item*M_PI / _cellCount), _center.y + _radius * sinf(2*indexPath.item*M_PI/_cellCount));
    return attribute;
}

//将设置好的属性集合作为一个数组返回
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * attArray = [[NSMutableArray alloc]init];
    
    for(NSInteger i = 0 ; i < _cellCount ;i ++ ){
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attArray;
}

//当item的数量开始发生变化，即添加或者删除时，会调用该方法
/*
 The UICollectionViewUpdateItem class describes a single change to make to an item in a collection view. You do not create instances of this class directly. When updating its content, the collection view object creates them and passes them to the layout object’s prepareForCollectionViewUpdates: method, which can use them to prepare the layout object for the upcoming changes.
 */
//UICollectionViewUpdateItem 这个类用来描述一个对于collectionview中的item的一个简单的改变，你不用去创建这个累的实例。当你更新collectionview的内容的时候，视图的对象就会创建它们并且把它们传给layout的实例的prepareForCollectionViewUpdates 方法中，这个方法可以为这个即将到来的变化做出一些改变

-(void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems{
    
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.insertIndexPaths = [NSMutableArray array];
    self.deleteIndexPaths = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem * item in updateItems) {
        if (item.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:item.indexPathBeforeUpdate];
        }else if (item.updateAction == UICollectionUpdateActionInsert){
            [self.insertIndexPaths addObject:item.indexPathAfterUpdate];
        }
    }
}
//
-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    
    UICollectionViewLayoutAttributes *attribute = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([_insertIndexPaths containsObject:itemIndexPath]) {
        if (!attribute) {
            attribute = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
//        这里的动画是苹果自己实现的，这里对于属性的设置，对于插入操作来说，指的是item的初始状态。
        attribute.alpha = 0.0;
        attribute.center = CGPointMake(_center.x, _center.y);
    }
    
    return attribute;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    
    UICollectionViewLayoutAttributes * attribute = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([_deleteIndexPaths containsObject:itemIndexPath]) {
        if (!attribute) {
            attribute = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
//       同样的，这里的删除的动画也是苹果自己实现的，对于删除的操作来说，下面的属性的操作指的是item的消失的最后的一个状态。
        attribute.alpha = 0;
        attribute.center = CGPointMake(_center.x, _center.y);
    }
    return attribute;
}

-(void)finalizeCollectionViewUpdates{
    [super finalizeCollectionViewUpdates];
    
    _insertIndexPaths = nil;
    _deleteIndexPaths = nil;
}



@end
