//
//  ALBubbleView.h
//  BubbleChat
//
//  Created by Alvaro Olave on 29/1/16.
//  Copyright © 2016 AluxionLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kBubbleType) {
    kBubbleTypeRectBeakVertical,
    kBubbleTypeRectBeakHorizontal,
    kBubbleTypeRectBeakCurve,
    kBubbleTypeRectBeakNone
};


@interface ALBubbleView : UIView

-(instancetype)initWithFrame:(CGRect)frame borderColor:(UIColor*)color borderWidth:(float)width cornerRadious:(int)radious reflex:(BOOL)reflex bubbleType:(kBubbleType) bubbleType;

- (void)setKindOfBubble:(kBubbleType)bubbleType;
- (void)setFillColor:(UIColor *)fillColor;
- (void)setBorderColor:(UIColor *)borderColor;

@end
