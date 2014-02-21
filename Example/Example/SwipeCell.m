//
//  SwipeCell.m
//  Example
//
//  Created by Donovan Söderlund on 20/02/14.
//  Copyright (c) 2014 Donovan Söderlund. All rights reserved.
//

#import "SwipeCell.h"

@implementation SwipeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftAreaEnabled = YES;
        self.leftAreaWidth = 100;
        
        self.rightAreaEnabled = YES;
        self.rightAreaWidth = 150;
        
        self.rightArea.backgroundColor = [UIColor colorWithRed:1.00f green:0.23f blue:0.19f alpha:1.00f];
        
        // Adding button
        UIButton *rightButton = [[UIButton alloc] initWithFrame:self.rightArea.bounds];
        // If you plan to use different height cells a resizing mask is recommended.
        rightButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"Action" forState:UIControlStateNormal];
        [self.rightArea addSubview:rightButton];
    }
    return self;
}

- (void)rightButtonAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Action" message:@"Right button was pressed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
