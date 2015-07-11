//
//  ContentViewController.m
//  Sample-ScrollViewWith9BoxLayout
//
//  Created by zzdjk6 on 15/6/18.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

@import QuartzCore;

#import "ContentViewController.h"

static float const aspectRaito = 10.f/16.f;

@interface ContentViewController ()

@property (assign, nonatomic) BOOL inited;

@end

@implementation ContentViewController

#pragma mark - View Events

- (void)awakeFromNib {
    self.bigLevel = 1;
    self.inited = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    // only init once
    if (self.inited == YES) {
        return;
    }
    
    [self initLayout];
//    [self layoutBoxes];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.text = [NSString stringWithFormat:@"(%lu,%ld)",(unsigned long)self.bigLevel,(long)(indexPath.item + 1)];
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"You selected: %@",[NSString stringWithFormat:@"(%lu,%ld)",(unsigned long)self.bigLevel,(long)(indexPath.item + 1)]);
}

#pragma mark - Private

- (void)initLayout {
    float minGapH = 20.f;
    float minGapV = 15.f;
    float topOffset = 20.f;
    
    // avoid float number precision problem
    float innerWidth = self.collectionView.frame.size.width - 2 * minGapH - 1;
    float innerHeight = self.collectionView.frame.size.height - topOffset - 1;
    
    // try layout by minGapH first
    float width = (innerWidth - 2 * minGapH) / 3.f;
    float height = width / aspectRaito;
    if (height * 3 + 2 * minGapV > innerHeight) {
        // can't layout by minGapH, layout by minGapV
        height = (innerHeight - 2 * minGapV) / 3.f;
        width = height * aspectRaito;
    }
    
    float gapH = (innerWidth - 3 * width) / 2.f;
    float gapV = (innerHeight - 3 * height) / 2.f;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumInteritemSpacing = gapH;
    layout.minimumLineSpacing = gapV;
    layout.sectionInset = UIEdgeInsetsMake(topOffset, minGapH, 0, minGapH);
}

@end
