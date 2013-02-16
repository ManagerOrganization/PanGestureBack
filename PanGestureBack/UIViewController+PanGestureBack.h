//
//  UIViewController+PanGestureBack.h
//  PanGestureBack
//
//  Created by GUO Lin on 2/8/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PanGestureBack)

- (void)addPanGestureBack;

- (void)setPanGetureBackgroundColor:(UIColor *)color;
- (void)setPanGetureBackTextFont:(UIFont *)font;
- (void)setPanGetureBackText:(NSString *)text;
- (void)setPanGetureBackTextColor:(UIColor *)color;
- (void)setPanGetureBackImage:(UIImage *)image;

@end
