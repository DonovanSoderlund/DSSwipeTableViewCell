// DSSwipeTableViewCell.m
//
// Copyright (c) 2014 Donovan Söderlund ( http://donovan.se )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DSSwipeTableViewCell.h"

#define DEFAULT_BUTTON_SIZE 100
#define DEFAULT_BUTTON_COLOR [UIColor colorWithWhite:.9 alpha:1]
#define PAN_CANCEL_DISTANCE 10
#define RUBBER_BANDING_FACTOR .7 // [0, 1] 0 is loose, 1 is no rubber banding

@interface DSSwipeTableViewCell () {
    
    // Keeps track of where view was at pan start
    CGPoint swipeViewOrigin;
    
    // To control panning and tableView scrolling
    BOOL panInProgress;
    BOOL scrollInProgress;
}

@end

@implementation DSSwipeTableViewCell

@synthesize leftAreaWidth = _leftAreaWidth, rightAreaWidth = _rightAreaWidth;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // Add pan gesture
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureRecognized:)];
        panGestureRecognizer.delegate = self;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self.contentView addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        if (point.x < self.contentView.frame.origin.x) {
            return [_leftArea hitTest:[_leftArea convertPoint:point fromView:self] withEvent:event];
        }
        else if (point.x > self.contentView.frame.origin.x + self.contentView.frame.size.width) {
            return [_rightArea hitTest:[_rightArea convertPoint:point fromView:self] withEvent:event];
        }
        else {
            return self.contentView;
        }
    }
    return nil;
}

- (UIPanGestureRecognizer*)panGestureRecognizer {
    for (id currentObject in self.contentView.gestureRecognizers) {
        if ([currentObject class] == [UIPanGestureRecognizer class]) {
            return currentObject;
        }
    }
    return nil;
}

- (void)_panGestureRecognized:(id)sender {
    
    UIPanGestureRecognizer *panGestureRecognizer = [self panGestureRecognizer];
    
    // on the first touch, get the center coordinates (x and y) of the view
    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        swipeViewOrigin = panGestureRecognizer.view.center;
    }
    
    if (!_swipingEnabled) {
        panGestureRecognizer.view.center = swipeViewOrigin;
        return;
    }
    
    // add translated point to reference points
    CGPoint translatedPoint = [panGestureRecognizer translationInView:self];
    CGPoint viewLocationPoint = CGPointMake(swipeViewOrigin.x+translatedPoint.x, swipeViewOrigin.y);
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat viewOffsetX = viewLocationPoint.x - centerX;
    
    // hide opposite viewArea
    _leftArea.hidden = (viewOffsetX <= 0);
    _rightArea.hidden = (viewOffsetX >= 0);
    
    // set view location
    if ([panGestureRecognizer locationInView:self].x > 30) panGestureRecognizer.view.center = viewLocationPoint;
    
    // rubber banding
    CGFloat currentLeftButtonWidth = _leftArea.frame.size.width;
    CGFloat currentRightButtonWidth = _rightArea.frame.size.width;
    
    // left rubber banding
    if (viewOffsetX > currentLeftButtonWidth) {
        CGFloat rubberBanding = -(viewOffsetX-currentLeftButtonWidth) * ([self leftAreaEnabled] ? RUBBER_BANDING_FACTOR : 1);
        panGestureRecognizer.view.center = CGPointMake(swipeViewOrigin.x+translatedPoint.x+rubberBanding, swipeViewOrigin.y);
    }
    // right rubber banding
    else if (viewOffsetX < -currentRightButtonWidth) {
        CGFloat rubberBanding = -(viewOffsetX+currentRightButtonWidth) * ([self rightAreaEnabled] ? RUBBER_BANDING_FACTOR : 1);
        panGestureRecognizer.view.center = CGPointMake(swipeViewOrigin.x+translatedPoint.x+rubberBanding, swipeViewOrigin.y);
    }
    
    // cancel if vertical scroll
    if (abs(translatedPoint.y) > PAN_CANCEL_DISTANCE && !panInProgress) {
        panGestureRecognizer.enabled = NO;
        panGestureRecognizer.enabled = YES;
        [self resetAnimated:NO];
    }
    else if (abs(translatedPoint.x) > PAN_CANCEL_DISTANCE && !panInProgress) {
        panInProgress = YES;
        // Call delegate method
        if ([self.delegate respondsToSelector:@selector(swipeCellDidStartSwiping:)]) [self.delegate swipeCellDidStartSwiping:self];
    }
    
    // when pan ends (set final x to be either back to origin or showing buttons)
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint panVelocity = [panGestureRecognizer velocityInView:self];
        CGFloat finalX = 0;
        
        if (viewLocationPoint.x < centerX && panVelocity.x < 0 && [self rightAreaEnabled]) {
            finalX -= _rightArea.frame.size.width;
        }
        else if (viewLocationPoint.x > centerX && panVelocity.x > 0 && [self leftAreaEnabled]) {
            finalX += _leftArea.frame.size.width;
        }
        
        // Call delegate method
        if ([self.delegate respondsToSelector:@selector(swipeCellDidEndSwiping:)]) [self.delegate swipeCellWillEndSwiping:self];
        
        // animate slideView
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            panGestureRecognizer.view.frame = CGRectOffset(panGestureRecognizer.view.bounds, finalX, 0);
        } completion:^(BOOL finished) {
            panInProgress = NO;
            // Call delegate method
            if ([self.delegate respondsToSelector:@selector(swipeCellDidEndSwiping:)]) [self.delegate swipeCellDidEndSwiping:self];
        }];
    }
}

- (void)setLeftAreaEnabled:(BOOL)leftAreaEnabled {
    if ([self leftAreaEnabled] != leftAreaEnabled) {
        _leftArea = [[UIView alloc] init];
        _leftArea.backgroundColor = DEFAULT_BUTTON_COLOR;
        [self setLeftAreaWidth:0];
        [self addSubview:_leftArea];
        [self sendSubviewToBack:_leftArea];
    }
}

- (BOOL)leftAreaEnabled {
    return _leftArea != nil;
}

- (void)setRightAreaEnabled:(BOOL)rightAreaEnabled {
    if ([self rightAreaEnabled] != rightAreaEnabled) {
        _rightArea = [[UIView alloc] init];
        _rightArea.backgroundColor = DEFAULT_BUTTON_COLOR;
        [self setRightAreaWidth:0];
        [self addSubview:_rightArea];
        [self sendSubviewToBack:_rightArea];
    }
}

- (BOOL)rightAreaEnabled {
    return _rightArea != nil;
}

- (BOOL)isShowingLeftArea {
    return self.contentView.frame.origin.x > 0;
}

- (BOOL)isShowingRightArea {
    return self.contentView.frame.origin.x < 0;
}

- (void)setLeftAreaWidth:(float)leftAreaWidth {
    _leftAreaWidth = leftAreaWidth;
    _leftArea.frame = CGRectMake(0, 0, leftAreaWidth?leftAreaWidth:DEFAULT_BUTTON_SIZE, self.bounds.size.height);
    _leftArea.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (float)leftAreaWidth {
    return _leftAreaWidth;
}

- (void)setRightAreaWidth:(float)rightAreaWidth {
    _rightAreaWidth = rightAreaWidth;
    _rightArea.frame = CGRectMake(self.bounds.size.width-(rightAreaWidth?rightAreaWidth:DEFAULT_BUTTON_SIZE), 0, rightAreaWidth?rightAreaWidth:DEFAULT_BUTTON_SIZE, self.bounds.size.height);
    _rightArea.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
}

- (float)rightAreaWidth {
    return _rightAreaWidth;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return !panInProgress;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (![self isShowingLeftArea] && ![self isShowingRightArea]) {
        [super setSelected:selected animated:animated];
        self.leftArea.hidden = selected;
        self.rightArea.hidden = selected;
        [self panGestureRecognizer].enabled = !selected;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (![self isShowingLeftArea] && ![self isShowingRightArea] && highlighted) {
        [super setHighlighted:highlighted animated:animated];
        self.leftArea.hidden = highlighted;
        self.rightArea.hidden = highlighted;
    }
    else if (!highlighted) {
        [super setHighlighted:highlighted animated:animated];
        self.leftArea.hidden = highlighted;
        self.rightArea.hidden = highlighted;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetAnimated:NO];
    self.swipingEnabled = YES;
    self.hidden = NO;
}

- (void)resetAnimated:(BOOL)animated {
    if ([self isShowingLeftArea] || [self isShowingRightArea]) {
        if (animated) {
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.contentView.center = CGPointMake(self.bounds.size.width/2, swipeViewOrigin.y);
            } completion:nil];
        }
        else self.contentView.center = CGPointMake(self.bounds.size.width/2, swipeViewOrigin.y);
    }
}

@end
