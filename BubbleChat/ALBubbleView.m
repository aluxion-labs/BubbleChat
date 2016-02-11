//
//  ALBubbleView.m
//  BubbleChat
//
//  Created by Alvaro Olave on 29/1/16.
//  Copyright © 2016 AluxionLabs. All rights reserved.
//

#import "ALBubbleView.h"

static const CGFloat kDefaultBorderWidth                = 2.f;
static const NSInteger kDefaultCornerRadious            = 6;
static const kBubbleType kDefaultBubbleType            = kBubbleTypeRectBeakNone;

@interface ALBubbleView ()

@property (nonatomic) int cornerRadious;
@property (nonatomic) UIColor *strokePathColor;
@property (nonatomic) UIColor *fillPathColor;
@property (nonatomic) float borderWidth;
@property (nonatomic) BOOL reflex;
@property (nonatomic) kBubbleType bubbleType;

@end

@implementation ALBubbleView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _cornerRadious = kDefaultCornerRadious;
        _strokePathColor = [UIColor blueColor];
        _fillPathColor = nil;
        _borderWidth = kDefaultBorderWidth;
        _bubbleType = kDefaultBubbleType;
        _reflex = NO;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame borderColor:(UIColor*)color borderWidth:(float)width cornerRadious:(int)radious reflex:(BOOL)reflex bubbleType:(kBubbleType) bubbleType
{
    if (self = [super initWithFrame:frame]) {
        _cornerRadious = radious;
        _strokePathColor = color;
        _fillPathColor = nil;
        _borderWidth = width;
        _bubbleType = bubbleType;
        _reflex = reflex;
    }
    return self;
}

- (void)setKindOfBubble:(kBubbleType)bubbleType
{
    self.bubbleType = bubbleType;
    
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    self.fillPathColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.strokePathColor = borderColor;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    int cornerRadious = self.cornerRadious;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, self.borderWidth);

    CGContextMoveToPoint(context, rect.origin.x + (2 * cornerRadious), rect.origin.y + cornerRadious);
    // Superior-left corner
    CGContextAddQuadCurveToPoint(context, rect.origin.x + cornerRadious, rect.origin.y + cornerRadious,rect.origin.x + cornerRadious, rect.origin.y + (2 * cornerRadious));
    
    //Inferior-left corner
    [self drawInferiorLeftCornerInContext:context withRect:rect];
    
    CGContextAddLineToPoint(context, rect.size.width - (2 * cornerRadious), rect.size.height - 2 * cornerRadious);
    
    //Inferior-right corner
    CGContextAddQuadCurveToPoint(context, rect.size.width - cornerRadious, rect.size.height - 2 * cornerRadious, rect.size.width - cornerRadious, rect.size.height - 3 * cornerRadious);
    
    CGContextAddLineToPoint(context, rect.size.width - cornerRadious, rect.origin.y + (2 * cornerRadious));
    //Superior-right corner
    CGContextAddQuadCurveToPoint(context, rect.size.width - cornerRadious, rect.origin.y + cornerRadious, rect.size.width - (2 * cornerRadious), rect.origin.y + cornerRadious);
    
    CGContextClosePath(context);

    [self paintBubbleInContext:context];
    
    if (self.reflex) {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        for (UIView *view in self.subviews) {
            view.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        }
    }
    
}

- (void)drawInferiorLeftCornerInContext:(CGContextRef)context withRect:(CGRect)rect
{
    switch (self.bubbleType) {
        case kBubbleTypeRectBeakVertical:{
            CGContextAddLineToPoint(context, rect.origin.x + self.cornerRadious, rect.size.height - self.cornerRadious);
            
            CGContextAddQuadCurveToPoint(context, rect.origin.x + self.cornerRadious , rect.size.height - 2 * self.cornerRadious, rect.origin.x + 3 * self.cornerRadious, rect.size.height - 2 * self.cornerRadious);
            break;
        }
            
        case kBubbleTypeRectBeakHorizontal:{
            CGContextAddLineToPoint(context, rect.origin.x + self.cornerRadious, rect.size.height - 3 * self.cornerRadious);
            
            CGContextAddQuadCurveToPoint(context, rect.origin.x + self.cornerRadious , rect.size.height - 2 * self.cornerRadious, rect.origin.x + 2 , rect.size.height - 2 * self.cornerRadious);
            
            break;
        }
            
        case kBubbleTypeRectBeakCurve:{
            CGContextAddLineToPoint(context, rect.origin.x + self.cornerRadious, rect.size.height - 3 * self.cornerRadious);
            
            CGContextAddQuadCurveToPoint(context, rect.origin.x + self.cornerRadious , rect.size.height - 2 * self.cornerRadious, rect.origin.x + 1 , rect.size.height - 2 * self.cornerRadious + 3);
            CGContextAddQuadCurveToPoint(context, rect.origin.x + self.cornerRadious , rect.size.height - 2 * self.cornerRadious, rect.origin.x + self.cornerRadious + 2 , rect.size.height - 2 * self.cornerRadious);
            
            break;
        }
        case kBubbleTypeRectBeakNone:{
            CGContextAddLineToPoint(context, rect.origin.x + self.cornerRadious, rect.size.height - 3 * self.cornerRadious);
            
            CGContextAddQuadCurveToPoint(context, rect.origin.x + self.cornerRadious, rect.size.height - 2 * self.cornerRadious, rect.origin.x + 2 * self.cornerRadious, rect.size.height - 2 * self.cornerRadious);
            
            break;
        }
    }
}

- (void)paintBubbleInContext:(CGContextRef)context
{
    if (self.fillPathColor && self.strokePathColor) {
        CGContextSetFillColorWithColor(context, self.fillPathColor.CGColor);
        CGContextSetStrokeColorWithColor(context, self.strokePathColor.CGColor);
        
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else if (self.fillPathColor){
        CGContextSetFillColorWithColor(context, self.fillPathColor.CGColor);
        CGContextFillPath(context);
    }
    else if (self.strokePathColor) {
        CGContextSetStrokeColorWithColor(context, self.strokePathColor.CGColor);
        CGContextStrokePath(context);
    }
}

@end
