//
//  ViewController.m
//  Touches
//
//  Created by Alexey Baryshnikov on 30.05.2020.
//  Copyright © 2020 Alexey Baryshnikov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak)UIView *dragginView;
@property (nonatomic, assign)CGPoint touchOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewController];
//    UIView *rect = [self createView];
    for (int i = 0; i < 5; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 100/2, 100 + 110 * i, 100, 100)];
        view.backgroundColor = [self randomColor];
        view.layer.cornerRadius = 12;
        [self.view addSubview:view];
    }
    
    

}

#pragma mark *** Private methods ***

- (float)randomFloatFromZeroToOne {
    return (float) (arc4random() % 256) / 255;
}

- (UIColor *)randomColor {
    CGFloat r = [self randomFloatFromZeroToOne];
    CGFloat g = [self randomFloatFromZeroToOne];
    CGFloat b = [self randomFloatFromZeroToOne];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (void)logTouches:(NSSet *)touches withMethod:(NSString *)methodName {
    NSMutableString *string = [NSMutableString stringWithString:methodName];
    
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        [string appendFormat:@" %@", NSStringFromCGPoint(point)];
    }
    NSLog(@"%@", string);
}

- (void)setupViewController {
    self.view.backgroundColor = [UIColor blackColor];
    self.view.multipleTouchEnabled = YES;
}

- (UIView *)createView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    view.backgroundColor = [self randomColor];
    view.layer.cornerRadius = 12;
    return view;
}

#pragma mark *** Touches ***
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"touchesBegan");
    [self logTouches:touches withMethod:@"touchesBegan"];
    UITouch *touch = [touches anyObject];
    CGPoint pointOnMainView = [touch locationInView:self.view];
    
    UIView *view = [self.view hitTest:pointOnMainView withEvent:event];
    if (![view isEqual:self.view]) {
        self.dragginView = view;
        [self.view bringSubviewToFront:self.dragginView];
        
        CGPoint touchPoint = [touch locationInView:self.dragginView];
        self.touchOffset = CGPointMake(CGRectGetMidX(self.dragginView.bounds) - touchPoint.x, CGRectGetMidY(self.dragginView.bounds) - touchPoint.y);
        
        [self.dragginView.layer removeAllAnimations];
        [UIView animateWithDuration:0.3 animations:^{
            self.dragginView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.dragginView.alpha = 0.9;
        }];
        
    } else {
        self.dragginView = nil;
    }
    
//    NSLog(@"%@", [view pointInside:pointOnMainView withEvent:event] ? @"Outside" : @"Inside");
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"touchesMoved");
    [self logTouches:touches withMethod:@"touchesMoved"];
    if (self.dragginView) {
        UITouch *touch = [touches anyObject];
        CGPoint pointOnMainView = [touch locationInView:self.view];
        
        CGPoint corretion = CGPointMake(pointOnMainView.x + self.touchOffset.x, pointOnMainView.y + self.touchOffset.y);
        
        self.dragginView.center = corretion;

    }
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"touchesEnded");
    [self logTouches:touches withMethod:@"touchesEnded"];
    [UIView animateWithDuration:0.3 animations:^{
//        self.dragginView.transform = CGAffineTransformMakeScale(1, 1);
        self.dragginView.transform = CGAffineTransformIdentity;
        self.dragginView.alpha = 1;
    }];
    self.dragginView = nil;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"touchesCancelled");
    [self logTouches:touches withMethod:@"touchesCancelled"];
    self.dragginView = nil;
}
- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches {
//    NSLog(@"touchesEstimatedPropertiesUpdated");
    [self logTouches:touches withMethod:@"touchesEstimatedPropertiesUpdated"];
}


@end
