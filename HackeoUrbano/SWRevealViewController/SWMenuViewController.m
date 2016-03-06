//
//  SWMenuViewController.m
//  SideMenu
//
//  Created by M on 1/8/16.
//  Copyright © 2016 M. All rights reserved.
//

#import "SWMenuViewController.h"

@interface SWMenuViewController ()

@end

@implementation SWMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sections.count;
}

- (UIColor *)textColorAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _previouslySelectedRow) {
        return _selectedSectionTextColor;
    } else {
        return _unselectedSectionTextColor;
    }
}

- (UIColor *)backgroundColorAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _previouslySelectedRow) {
        return _selectedSectionColor;
    } else {
        return _unselectedSectionColor;
    }
}

- (id)imageAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _previouslySelectedRow) {
        return [UIImage imageNamed:_selectedImages[(NSUInteger) indexPath.row]];
    } else {
        return [UIImage imageNamed:_unselectedImages[(NSUInteger) indexPath.row]];
    }
}

- (id)sectionAtIndexPath:(NSIndexPath *)indexPath {
    return _sections[(NSUInteger) indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.textColor = [self textColorAtIndexPath:indexPath];
    cell.backgroundColor = [self backgroundColorAtIndexPath:indexPath];
    cell.imageView.image = [self imageAtIndexPath:indexPath];
    cell.textLabel.text = [self sectionAtIndexPath:indexPath];
    return cell;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWRevealViewController *revealController = self.revealViewController;
    NSInteger row = indexPath.row;
    if (row == _previouslySelectedRow){
        [revealController revealToggleAnimated:YES];
        return;
    }
    
    UIViewController *frontController = [self.storyboard instantiateViewControllerWithIdentifier:_sectionIds[row]];
    [revealController pushFrontViewController:frontController animated:YES];
    
    _previouslySelectedRow = row;
    [self.tableView reloadData];
}

@end
