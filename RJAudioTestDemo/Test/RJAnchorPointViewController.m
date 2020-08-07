//
//  RJAnchorPointViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/7.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAnchorPointViewController.h"

@interface RJAnchorPointViewController ()

/// <#Desription#>
@property (nonatomic, weak) UIView *testView;
/// <#Desription#>
@property (nonatomic, weak) UIView *containerView;
@end

@implementation RJAnchorPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *containerView = [[UIView alloc] init];
    [self.view addSubview:containerView];
    self.containerView = containerView;
    containerView.bounds = CGRectMake(0, 0, 100, 100);
    containerView.center = CGPointMake(100, 100);
    containerView.backgroundColor = [UIColor orangeColor];
    
    UIView *testView = [[UIView alloc] init];
    [containerView addSubview:testView];
    testView.frame = containerView.bounds;
    testView.backgroundColor = [UIColor redColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *containerView = self.containerView;
    // 更改父view的bounds，从而移动子view
    containerView.bounds = CGRectMake(-20, -20, containerView.frame.size.width, containerView.frame.size.height);
}

- (void)addAnchorPointView {
    UIView *testView1 = [[UIView alloc] init];
    [self.view addSubview:testView1];
    testView1.bounds = CGRectMake(0, 0, 100, 100);
    testView1.center = CGPointMake(100, 100);
    testView1.backgroundColor = [UIColor orangeColor];
    
    UIView *testView = [[UIView alloc] init];
    [self.view addSubview:testView];
    self.testView = testView;
    testView.bounds = CGRectMake(0, 0, 100, 100);
    testView.center = CGPointMake(100, 100);
    testView.backgroundColor = [UIColor redColor];
    NSLog(@"layer---frame:%@--bounds:%@--position:%@--anchorPoint:%@", NSStringFromCGRect(testView.layer.frame), NSStringFromCGRect(testView.layer.bounds), NSStringFromCGPoint(testView.layer.position), NSStringFromCGPoint(testView.layer.anchorPoint));
    NSLog(@"x:%lf", testView.layer.position.x - testView.layer.anchorPoint.x * testView.layer.bounds.size.width);
    NSLog(@"y:%lf", testView.layer.position.y - testView.layer.anchorPoint.y * testView.layer.bounds.size.height);
}

- (void)rotationTransform {
    UIView *testView = self.testView;
    CGPoint oldOrigin = testView.layer.frame.origin;
    // 更改锚点
    testView.layer.anchorPoint = CGPointMake(0, 0);
    // 改回原来的origin
    CGPoint newOrigin = testView.layer.frame.origin;
    CGPoint transition = CGPointMake(newOrigin.x - oldOrigin.x, newOrigin.y - oldOrigin.y);
    testView.layer.position = CGPointMake(testView.layer.position.x - transition.x, testView.layer.position.y - transition.y);
    // 旋转
    testView.transform = CGAffineTransformMakeRotation(M_PI_4);
}

- (void)resetFrameOrigin {
    UIView *testView = self.testView;
    CGRect testViewFrame = testView.layer.frame;
    CGPoint oldOrigin = testView.layer.frame.origin;
    // 更改锚点
    testView.layer.anchorPoint = CGPointMake(0, 0); // 根据公式计算，会更改frame.origin
    // 改回原来的origin
//    testView.layer.frame = testViewFrame; // 方法1
    // 方法2 推荐
    CGPoint newOrigin = testView.layer.frame.origin;
    CGPoint transition = CGPointMake(newOrigin.x - oldOrigin.x, newOrigin.y - oldOrigin.y);
    testView.layer.position = CGPointMake(testView.layer.position.x - transition.x, testView.layer.position.y - transition.y);

    NSLog(@"layer---frame:%@--bounds:%@--position:%@--anchorPoint:%@", NSStringFromCGRect(testView.layer.frame), NSStringFromCGRect(testView.layer.bounds), NSStringFromCGPoint(testView.layer.position), NSStringFromCGPoint(testView.layer.anchorPoint));
    NSLog(@"x:%lf", testView.layer.position.x - testView.layer.anchorPoint.x * testView.layer.bounds.size.width);
    NSLog(@"y:%lf", testView.layer.position.y - testView.layer.anchorPoint.y * testView.layer.bounds.size.height);
}



@end
