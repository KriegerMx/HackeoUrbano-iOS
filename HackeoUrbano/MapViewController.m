//
//  MapViewController.m
//  HackeoUrbano
//
//  Created by Marlon Vargas Contreras on 5/3/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () {
    MKMapView *map;
    
    UITableView *routesTableView;
    UIView *bottomView;
    UIImageView *accessoryImageView;
    BOOL showTableView;
    
    NSMutableArray *routes;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - table views
- (void)addViews {
    [self addMap];
    [self addBottomView];
}

- (void)addMap {
    map = [MKMapView new];
    [self.view addSubview:map];
    
    [map mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)addBottomView {
    bottomView = [UIView new];
    bottomView.backgroundColor = [HUColor backgroundColor];
    bottomView.alpha = 0.8;
    [self.view addSubview:bottomView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Lista de recorridos";
    titleLabel.numberOfLines = 0;
    [bottomView addSubview:titleLabel];
    
    UIImage *accessoryImage = [UIImage imageNamed:@"ic_arrow"];
    accessoryImageView = [[UIImageView alloc] initWithImage:accessoryImage];
    [bottomView addSubview:accessoryImageView];
    
    [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(20);
        make.right.equalTo(accessoryImageView.mas_left);
        make.height.equalTo(@30);
    }];
    
    [accessoryImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(titleLabel.mas_right);
        make.right.equalTo(bottomView.mas_right).offset(-20);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bottomView addGestureRecognizer:tapRecognizer];
}

- (void)tap {
    showTableView = !showTableView;
    if (showTableView) {
        accessoryImageView.transform = CGAffineTransformMakeRotation(M_PI);
        [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@44);
        }];
    } else {
        accessoryImageView.transform = CGAffineTransformMakeRotation(0);
        [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-44);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@44);
        }];
    }
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - tableView
- (void)setTableView {
    routesTableView = [UITableView new];
    routesTableView.delegate = self;
    routesTableView.dataSource = self;
    [self.view addSubview:routesTableView];
    
    [routesTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return routes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = routes[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
