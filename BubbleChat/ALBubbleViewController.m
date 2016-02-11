//
//  ALBubbleViewController.m
//  BubbleChat
//
//  Created by Alvaro Olave on 29/1/16.
//  Copyright © 2016 AluxionLabs. All rights reserved.
//

#import "ALBubbleViewController.h"
#import "ALBubbleView.h"

@interface ALBubbleViewController ()

@end

@implementation ALBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self createBubbles];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBubbles{

     ALBubbleView *bubbleViewBeakCurve = [[ALBubbleView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 100.f)
                                                            borderColor:[UIColor blueColor]
                                                            borderWidth:2.f
                                                          cornerRadious:6
                                                                 reflex:NO
                                                             bubbleType:kBubbleTypeRectBeakCurve];
    
    bubbleViewBeakCurve.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bubbleViewBeakCurve];
    
    ALBubbleView *bubbleViewVertical = [[ALBubbleView alloc] initWithFrame:CGRectMake(0, 150, 150.f, 100.f)
                                                       borderColor:[UIColor redColor]
                                                       borderWidth:4.f
                                                     cornerRadious:10
                                                            reflex:YES
                                                        bubbleType:kBubbleTypeRectBeakVertical];
    
    bubbleViewVertical.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bubbleViewVertical];
    
    ALBubbleView *bubbleViewHorizontal = [[ALBubbleView alloc] initWithFrame:CGRectMake(50, 300, 100.f, 150.f)
                                                                 borderColor:nil
                                                                 borderWidth:2.f
                                                               cornerRadious:8
                                                                      reflex:YES
                                                                  bubbleType:kBubbleTypeRectBeakHorizontal];
    
    bubbleViewHorizontal.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bubbleViewHorizontal];
    
    [bubbleViewHorizontal setFillColor:[UIColor greenColor]];
    
    ALBubbleView *bubbleViewNone = [[ALBubbleView alloc] initWithFrame:CGRectMake(200, 250, 100.f, 80.f)
                                                                 borderColor:[UIColor grayColor]
                                                                 borderWidth:4.f
                                                               cornerRadious:8
                                                                      reflex:NO
                                                                  bubbleType:kBubbleTypeRectBeakNone];
    
    bubbleViewNone.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bubbleViewNone];
    
    [bubbleViewNone setFillColor:[UIColor redColor]];
    
}

+ (NSString *)nibName
{
    return @"ALBubbleViewController";
}
@end
