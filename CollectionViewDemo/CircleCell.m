//
//  CircleCell.m
//  CollectionViewDemo
//
//  Created by john on 16/4/27.
//  Copyright © 2016年 jhon. All rights reserved.
//

#import "CircleCell.h"

@implementation CircleCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 35;
        self.contentView.layer.borderColor = [[UIColor whiteColor]CGColor];
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

@end
