//
//  TableViewController.m
//  Example
//
//  Created by Donovan Söderlund on 19/02/14.
//  Copyright (c) 2014 Donovan Söderlund. All rights reserved.
//

#import "TableViewController.h"

#import "SwipeCell.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Here we register the new cell class
        [self.tableView registerClass:[SwipeCell class] forCellReuseIdentifier:@"Cell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60+(rand()%5)*5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SwipeCell *cell = (SwipeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Setting cells delegate
    cell.delegate = self;
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Cell nr %i", indexPath.row];
    
    return cell;
}

#pragma mark - DSSwipeTableViewCell delegate methods

- (void)swipeCellDidStartSwiping:(DSSwipeTableViewCell *)cell {
    // Reset all cells showing areas
    for (SwipeCell *currentCell in self.tableView.visibleCells) {
        if (currentCell.isShowingLeftArea || currentCell.isShowingRightArea) {
            [currentCell resetAnimated:YES];
        }
    }
}


@end
