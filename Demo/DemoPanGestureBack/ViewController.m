//
//  ViewController.m
//  DemoPanGestureBack
//
//  Created by GUO Lin on 2/8/13.
//  Copyright (c) 2013 lincode. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+PanGestureBack.h"


@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor lightGrayColor];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  button.frame = CGRectMake(40, 80, 240, 40);
  [button setTitle:@"Go to Next ViewController" forState:UIControlStateNormal];
  [button addTarget:self
             action:@selector(gotoNext)
   forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];

  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 140, 240, 60)];
  label.numberOfLines = 3;
  label.backgroundColor = [UIColor clearColor];
  label.text = @"Go to next view controller, then use right direction pan gesture to go back.";
  
  [self.view addSubview:label];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self addPanGestureBack];
  
  // Config the text
  [self setPanGetureBackTextFont:[UIFont systemFontOfSize:16]];
  [self setPanGetureBackTextColor:[UIColor blackColor]];
  [self setPanGetureBackText:@"Back"];
}

- (void)gotoNext {
  ViewController *nextController = [[ViewController alloc] init];
  [self.navigationController pushViewController:nextController animated:YES];
}

@end
