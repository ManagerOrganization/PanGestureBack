_**If your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `UIViewController+PanGestureBack.m` in Target Settings > Build Phases > Compile Sources._

PanGestureBack 
--------------

**PanGestureBack** is a clean and easy-to-use implementation for pan gesture back. 

## Installation

* Drag the `PanGestureBack/PanGestureBack` folder into your project.
* Add the **QuartzCore** framework to your project.

## Usage

(see sample Xcode project in `/DemoPanGestureBack`)

PanGestureBack is created as category. You just send message `addPanGestureBack` in your UIViewController. That's all!

```objective-c
	- (void)viewDidAppear:(BOOL)animated {
  		[super viewDidAppear:animated];
  		[self addPanGestureBack];

  		[self setPanGetureBackTextFont:[UIFont systemFontOfSize:18]];
  		[self setPanGetureBackTextColor:[UIColor blackColor]];
	}
```

## 简介
**PanGestureBack** 简单而易于使用的横滑手势回退的实现。