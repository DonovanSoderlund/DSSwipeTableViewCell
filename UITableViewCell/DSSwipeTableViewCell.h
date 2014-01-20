// DSSwipeTableViewCell.h
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

#import <UIKit/UIKit.h>

@interface DSSwipeTableViewCell : UITableViewCell

/*
 Views that should be populated with content of choice.
 */
@property (nonatomic, strong) UIView *leftArea;
@property (nonatomic, strong) UIView *rightArea;

/*
 Sets the areas available.
 */
@property BOOL leftAreaEnabled;
@property BOOL rightAreaEnabled;

/*
 Sets the width for each area. Default value is 100.
 */
@property (nonatomic) float leftAreaWidth;
@property (nonatomic) float rightAreaWidth;

/*
 Tells you if an area is showing.
 */
@property (readonly) BOOL isShowingLeftArea;
@property (readonly) BOOL isShowingRightArea;

/*
 Enables or disables swiping. Default value is YES;
 */
@property (nonatomic) BOOL swipingEnabled;

@end
