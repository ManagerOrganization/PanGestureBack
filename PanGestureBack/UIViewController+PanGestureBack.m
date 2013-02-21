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

@interface PanGetureBackImageView : UIImageView

@property (nonatomic, assign) BOOL isBackDirection;

@end

@implementation PanGetureBackImageView

@end


@implementation UIViewController (PanGestureBack)

static CGFloat const kMinBackMovement = 80.f;
static CGFloat const kBackgroundWidth = 220.f;

static NSInteger const kBackgroundViewTag = 100001;
static NSInteger const kBackLabelTag = 100002;
static NSInteger const kBackImageTag = 100003;

- (void)setPanGetureBackgroundColor:(UIColor *)color {
  UIView *backgroundView  = (UIView *)[self.view viewWithTag:kBackgroundViewTag];
  if (backgroundView) {
    backgroundView.backgroundColor = color;
  }
}

- (void)setPanGetureBackTextFont:(UIFont *)font {
  UILabel *backLabel  = (UILabel *)[self.view viewWithTag:kBackLabelTag];
  if (backLabel) {
    backLabel.font = font;
  }
}

- (void)setPanGetureBackText:(NSString *)text {
  UILabel *backLabel  = (UILabel *)[self.view viewWithTag:kBackLabelTag];
  if (backLabel) {
    backLabel.text = text;
  }
}

- (void)setPanGetureBackTextColor:(UIColor *)color {
  UILabel *backLabel  = (UILabel *)[self.view viewWithTag:kBackLabelTag];
  if (backLabel) {
    backLabel.textColor = color;
  }
}

- (void)setPanGetureBackImage:(UIImage *)image {
  PanGetureBackImageView *backArrow  = (PanGetureBackImageView *)[self.view viewWithTag:kBackImageTag];
  if (backArrow) {
    backArrow.image = image;
  }
}

- (void)addPanGestureBack {
  
  if (self.navigationController.viewControllers.count <= 1) {
    return ;
  }

  UIView *backgroundView  = (UIView *)[self.view viewWithTag:kBackgroundViewTag];
  if (backgroundView) {
    return;
  }
  
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(_handlePan:)];
  panGesture.delegate = (id<UIGestureRecognizerDelegate>)self;
  panGesture.maximumNumberOfTouches = 1;
  panGesture.minimumNumberOfTouches = 1;
  [self.view addGestureRecognizer:panGesture];
  
  // Back View
  backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-kBackgroundWidth,
                                                            0,
                                                            kBackgroundWidth,
                                                            self.view.bounds.size.height)];
  backgroundView.backgroundColor = [UIColor whiteColor];
  backgroundView.tag = kBackgroundViewTag;
  [self.view addSubview:backgroundView];

  UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
  backLabel.tag = kBackLabelTag;  
  backLabel.text = @"返回";
  backLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
  backLabel.textColor = [UIColor blackColor];
  backLabel.center = CGPointMake(kBackgroundWidth - 20, self.view.bounds.size.width/2);
  [backgroundView addSubview:backLabel];
  
  UIImage *arrow = [UIImage imageNamed:@"back_arrow"];
  PanGetureBackImageView *backArrow = [[PanGetureBackImageView alloc] initWithImage:arrow];
  backArrow.tag = kBackImageTag;
  backArrow.frame = CGRectMake(0, 0, 16, 12);
  backArrow.center = CGPointMake(kBackgroundWidth - 55, self.view.bounds.size.width/2);
  [backgroundView addSubview:backArrow];
}


- (void)_handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
  
  UIView *mainView = [gestureRecognizer view];
  UILabel *backLabel  = (UILabel *)[self.view viewWithTag:kBackLabelTag];
  PanGetureBackImageView *backArrow  = (PanGetureBackImageView *)[self.view viewWithTag:kBackImageTag];
  
  CGPoint translation = [gestureRecognizer translationInView:[mainView superview]];
  
  if (mainView.center.x <= self.view.bounds.size.width/2 && translation.x <= 0) {
    // only from left to right
    return ;
  }
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
    //[backArrow layer].transform = CATransform3DMakeRotation(0, 0, 0, 0);
  }
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
    
    CGFloat movement = translation.x/3;
    [mainView setCenter:CGPointMake([mainView center].x + movement, [mainView center].y)];
    
    if ([mainView center].x > self.view.bounds.size.width/2 + 70) {
      // fix the backLabel
      [backLabel setCenter:CGPointMake(backLabel.center.x - movement, backLabel.center.y)];
      [backArrow setCenter:CGPointMake(backArrow.center.x - movement, backArrow.center.y)];
    }
    
    if ([mainView center].x > self.view.bounds.size.width/2 + kMinBackMovement && !backArrow.isBackDirection) {
      // rotate the arrow to back's direction
      backArrow.isBackDirection = YES;
      [UIView animateWithDuration:0.3f
                       animations:
      ^{
         [backArrow layer].transform = CATransform3DMakeRotation(M_PI , 0, 0, 1);
      }
                       completion:NULL];
    }
    
    if ([mainView center].x < self.view.bounds.size.width/2 + kMinBackMovement && backArrow.isBackDirection) {
      // rotate the arrow to initial direction
      backArrow.isBackDirection = NO;
      [UIView animateWithDuration:0.3f
                       animations:
      ^{
         [backArrow layer].transform = CATransform3DMakeRotation(0, 0, 0, 1);
      }
                       completion:NULL];
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:[mainView superview]];
  }
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    // return to initial state
    if ([mainView center].x > self.view.bounds.size.width/2 + kMinBackMovement) {
      [self.navigationController popViewControllerAnimated:YES];
      return ;
    }

    backArrow.isBackDirection = NO;
    [UIView animateWithDuration:[mainView center].x/1000
                     animations:
    ^{
        [backLabel setCenter:CGPointMake(kBackgroundWidth - 20, self.view.bounds.size.width/2)];
        [backArrow setCenter:CGPointMake(kBackgroundWidth - 55, self.view.bounds.size.width/2)];
        [backArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        [mainView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    }
                    completion:NULL];
    
  }
}

@end
