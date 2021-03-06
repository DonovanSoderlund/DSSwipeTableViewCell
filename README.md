# DSSwipeTableViewCell

##### A drop-in replacement for `UITableViewCell` with horizontal scrolling to reveal a custom view, similar to Apple's swipe to delete button.

## Installation

#### CocoaPods
add `pod 'DSSwipeTableViewCell'` to your podfile.

#### Manual
Copy files in DSSwipeTableViewCell/ into your project and import DSSwipeTableViewCell.h in your `UITableViewController`.

## Usage

Use as a drop-in replacement for `UITableViewCell`. Enable and disable the swipe areas and add content to them.

It's recommended to subclass `DSSwipeTableViewCell` and setup the areas with buttons etc.
``` objective-c
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
```

## Demo

![Screenshot](demo.gif "Demonstration")

## Requirements

`DSSwipeTableViewCell` is compatible with iOS 7.0+

## Contact

Donovan Söderlund

- http://github.com/DonovanSoderlund
- http://twitter.com/DonovanSoder

## License

DSSwipeTableViewCell is available under the MIT License (MIT)
