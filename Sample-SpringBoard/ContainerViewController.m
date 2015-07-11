//
//  ContainerViewController.m
//  Sample-ScrollViewWith9BoxLayout
//
//  Created by zzdjk6 on 15/6/18.
//  Copyright (c) 2015年 zzdjk6. All rights reserved.
//

#import "ContainerViewController.h"
#import "ContentViewController.h"

static NSUInteger const kNumberOfPages = 5;

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *contentViewControllers;

- (IBAction)changePage:(UIPageControl *)sender;

@end

@implementation ContainerViewController

# pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];

    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < kNumberOfPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.contentViewControllers = controllers;
    
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = kNumberOfPages;
    self.pageControl.currentPage = 0;
}

- (void)viewDidLayoutSubviews {
    // after layout subviews, self.scrollView has it's real frame
    // now we can set it's contentSize precisely
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * kNumberOfPages,
                                             CGRectGetHeight(self.scrollView.frame));
    
    // preload page 0 and page 1 to avoid screen flash while swipping
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

#pragma mark - UIScrollViewDelegate

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

#pragma mark - IBAction

- (IBAction)changePage:(UIPageControl *)sender {
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

#pragma mark - Private

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page > kNumberOfPages - 1) {
        return;
    }
    
    // replace the placeholder if necessary
    ContentViewController *controller = [self.contentViewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        //        controller = [[LevelContentViewController alloc] init];
        controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ContentViewController class])];
        controller.bigLevel = page + 1;
        [self.contentViewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
}
@end
