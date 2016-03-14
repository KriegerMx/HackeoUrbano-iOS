//
//  RankingViewController.m
//  HackeoUrbano
//
//  Created by M on 3/6/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "RankingViewController.h"
#define loadingCellTag 16
#define elements 10

@interface RankingViewController () {
    UITableView *rankTableView;
    NSMutableArray *trails;
    NSMutableArray *trailIds;
    
    NSString *cursor;
    BOOL hasNextPage;
}

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    trails = [NSMutableArray new];
    trailIds = [NSMutableArray new];
    hasNextPage = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - get trails by ranking
- (void)getStats {
    static GTLServiceDashboardAPI *service = nil;
    if (!service) {
        service = [GTLServiceDashboardAPI new];
        service.retryEnabled = YES;
    }
    
    GTLDashboardAPIRouteStatsParameter *statsParameter = [GTLDashboardAPIRouteStatsParameter new];
    statsParameter.descending = [NSNumber numberWithBool:YES];
    statsParameter.numberOfElements = [NSNumber numberWithInt:elements];
    if (cursor) {
        statsParameter.cursor = cursor;
    }
    
    GTLQueryDashboardAPI *query = [GTLQueryDashboardAPI queryForGetAllStatsWithObject:statsParameter];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            GTLDashboardAPIRouteStatsResponse *response = (GTLDashboardAPIRouteStatsResponse*)object;
            cursor = response.cursor;
            if (response.items.count == 0) {
                NSLog(@"0 recorridos");
                hasNextPage = NO;
            }
            for (GTLDashboardAPIRouteStatsWrapper *wrapper in response.items) {
                NSString *trailName = [NSString stringWithFormat:@"%@ - %@", wrapper.originStation, wrapper.destinyStation];
                NSString *trailId = [wrapper.JSON objectForKey:@"id"];
                [trails addObject:trailName];
                [trailIds addObject:trailId];
            }
            [rankTableView reloadData];
        }
    }];
}

#pragma mark - table view
- (void)setTableView {
    rankTableView = [UITableView new];
    rankTableView.delegate = self;
    rankTableView.dataSource = self;
    rankTableView.estimatedRowHeight = 80.0;
    rankTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:rankTableView];
    
    [rankTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!cursor) {
        return 1;
    }
    if (hasNextPage) {
        return trails.count + 1;
    }
    return trails.count;
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [rankTableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = trails[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [HUColor textColor];
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.bounds.size.width/2,cell.contentView.bounds.size.height/2);
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = loadingCellTag;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < trails.count) {
        return [self cellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == loadingCellTag) {
        [self getStats];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!cursor) {
        return;
    }
    
    if (hasNextPage && indexPath.row == trails.count ) {
        return;
    }
    
    TrailViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"trailVC"];
    tvc.trailId = trailIds[indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
