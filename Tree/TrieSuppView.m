//
//  TrieSuppView.m
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import "TrieSuppView.h"

@interface TrieSuppView ()
@property (strong, nonatomic) CAShapeLayer* shapeLayer;
@end

@implementation TrieSuppView

- (id)initWithFrame:(CGRect)frame
{
    if(!(self = [super initWithFrame:frame]))
        return nil;

    self.backgroundColor = [UIColor clearColor];

    return self;
}

// for very large data sets, prob a good idea to make shape layer the backing layer
/*
+ (Class)layerClass
{
    return [CAShapeLayer class];
}
 */

- (NSMutableArray*)controlPoints
{
    if(!_controlPoints)
    {
        _controlPoints = [NSMutableArray array];
    }
    return _controlPoints;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    [self.layer addSublayer:shapeLayer];
    [shapeLayer setNeedsDisplay];
    shapeLayer.delegate = self;
}

- (void)drawLayer:(nonnull CALayer*)layer inContext:(nonnull CGContextRef)ctx
{
    CAShapeLayer* shapeLayer = (CAShapeLayer*)layer;

    // comment following line to hide border
    //    shapeLayer.borderWidth = 2;

    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;

    shapeLayer.lineWidth = 2;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;

    UIBezierPath* path = [UIBezierPath bezierPath];
    if(self.controlPoints.count > 0)
    {
        CGPoint p0 = [self.controlPoints[0] CGPointValue];
        [path moveToPoint:p0];

        for(NSUInteger i = 1; i < self.controlPoints.count; ++i)
        {
            CGPoint p = [self.controlPoints[i] CGPointValue];
            [path addLineToPoint:p];
        }
        [path moveToPoint:p0];
    }
    [path closePath];

    shapeLayer.path = path.CGPath;
}

@end
