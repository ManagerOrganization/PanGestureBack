//
//  UIViewController+PanGestureBack.m
//  PanGestureBack
//
//  Created by GUO Lin on 2/8/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+PanGestureBack.h"

@interface BackArrowView : UIImageView

@property (nonatomic, assign) BOOL isBackDirection;

@end

@implementation BackArrowView


@end


@implementation UIViewController (PanGestureBack)

static CGFloat const kMinBackMovement = 80.f;
static CGFloat const kBackgroundWidth = 200.f;

static NSInteger const kBackLabelTag = 100001;
static NSInteger const kBackArrowTag = 100002;

static BOOL isBackDirectionArrow = NO;


- (void)addPanGestureBack {
  
  if (self.navigationController.viewControllers.count <= 1) {
    return ;
  }
  
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(_handlePan:)];
  panGesture.delegate = (id<UIGestureRecognizerDelegate>)self;
  panGesture.maximumNumberOfTouches = 1;
  panGesture.minimumNumberOfTouches = 1;
  [self.view addGestureRecognizer:panGesture];
  
  // Back View
  UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-kBackgroundWidth,
                                                                    0,
                                                                    kBackgroundWidth,
                                                                    self.view.bounds.size.height)];
  backgroundView.backgroundColor = [UIColor whiteColor];
  
  [self.view addSubview:backgroundView];
  UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
  backLabel.tag = kBackLabelTag;  
  backLabel.text = @"返回";
  backLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
  backLabel.textColor = [UIColor blackColor];
  backLabel.center = CGPointMake(kBackgroundWidth - 20, self.view.bounds.size.width/2);
  [backgroundView addSubview:backLabel];
  
  UIImage *arrow = [UIImage imageNamed:@"back_arrow"];
  BackArrowView *backArrow = [[BackArrowView alloc] initWithImage:arrow];
  backArrow.tag = kBackArrowTag;
  backArrow.frame = CGRectMake(0, 0, 16, 12);
  backArrow.center = CGPointMake(kBackgroundWidth - 45, self.view.bounds.size.width/2);
  [backgroundView addSubview:backArrow];
}


- (void)_handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
  
  UIView *mainView = [gestureRecognizer view];
  UILabel *backLabel  = (UILabel *)[self.view viewWithTag:kBackLabelTag];
  BackArrowView *backArrow  = (BackArrowView *)[self.view viewWithTag:kBackArrowTag];
  
  CGPoint translation = [gestureRecognizer translationInView:[mainView superview]];
  
  if (mainView.center.x <= self.view.bounds.size.width/2 && translation.x <= 0) {
    // only from left to right
    return ;
  }
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
      [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
    
    CGFloat movement = translation.x/3;
    [mainView setCenter:CGPointMake([mainView center].x + movement, [mainView center].y)];
    
    if ([mainView center].x > self.view.bounds.size.width/2 + 60) {
      // fix the backLabel
      [backLabel setCenter:CGPointMake(backLabel.center.x - movement, backLabel.center.y)];
      [backArrow setCenter:CGPointMake(backArrow.center.x - movement, backArrow.center.y)];
    }
    
    if ([mainView center].x > self.view.bounds.size.width/2 + kMinBackMovement && !backArrow.isBackDirection) {
      // rotate the arrow to back's direction
      backArrow.isBackDirection = YES;
      [UIView animateWithDuration:0.3
                       animations:
       ^{
         [backArrow layer].transform = CATransform3DMakeRotation(M_PI , 0, 0, 1);
       }
                       completion:NULL];
    }
    
    if ([mainView center].x < self.view.bounds.size.width/2 + kMinBackMovement && backArrow.isBackDirection) {
      // rotate the arrow to initial direction
      backArrow.isBackDirection = NO;
      [UIView animateWithDuration:0.3
                       animations:
       ^{
         [backArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
       }
                       completion:NULL];
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:[mainView superview]];
  }
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    
    if ([mainView center].x > self.view.bounds.size.width/2 + kMinBackMovement) {
      [self.navigationController popViewControllerAnimated:YES];
      return ;
    }
    
    // return to initial state
    backArrow.isBackDirection = NO;
    [UIView animateWithDuration:[mainView center].x/1000
                     animations:
     ^{
       [backLabel setCenter:CGPointMake(kBackgroundWidth - 20, self.view.bounds.size.width/2)];
       [backArrow setCenter:CGPointMake(kBackgroundWidth - 45, self.view.bounds.size.width/2)];
       [mainView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
     }
                     completion:NULL];
  }
}

@end
