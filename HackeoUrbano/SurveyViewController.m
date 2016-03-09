//
//  SurveyViewController.m
//  HackeoUrbano
//
//  Created by Marlon Vargas Contreras on 5/3/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "SurveyViewController.h"

@interface SurveyViewController (){
    NSMutableArray *arrangedSubviews;
}

@end

@implementation SurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HUColor backgroundColor];
    [self addNavigationItems];
    [self addViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - navigation bar
- (void)addNavigationItems {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStylePlain target:self action:@selector(submitSurvey)];
}

- (void)submitSurvey {
    
}

#pragma mark - views
- (void)addViews {
    arrangedSubviews = [NSMutableArray new];
    [self addQuestions];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    UIStackView *stackView = [[UIStackView alloc]initWithArrangedSubviews:arrangedSubviews];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10.0;
    [scrollView addSubview:stackView];
    
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView).insets(insets);
        make.width.equalTo(self.view.mas_width).offset(-40);
    }];
}

- (void)addQuestions {
    [self questionWithTitle:@"Tipo de transporte" options:@[@"Microbús",@"Vagoneta", @"Autobús"]];
    [self multipleChoiceQuestionWithTitle:@"Seguridad" options: @[@"Acoso sexual", @"Robo con violencia", @"Robo sin violencia", @"Amenazas"]];
    [self multipleChoiceQuestionWithTitle:@"Aglomeración" options: @[@"Había espacio para sentarse", @"Habia espacio de pie", @"Estaba lleno", @"Estaba saturado"]];
}

- (void)questionWithTitle:(NSString*)title options:(NSArray*)options {
    UILabel *questionLabel = [UILabel new];
    questionLabel.text = title;
    questionLabel.numberOfLines = 0;
    questionLabel.font = [UIFont systemFontOfSize:14.0];
    [arrangedSubviews addObject:questionLabel];
    
    NSMutableArray *buttons = [NSMutableArray new];
    
    for (NSString *option in options) {
        DLRadioButton *radioButton = [DLRadioButton new];
        [radioButton setTitle:option forState:UIControlStateNormal];
        [radioButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
        radioButton.iconColor = [UIColor blueColor];
        radioButton.indicatorColor = [UIColor blueColor];
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [arrangedSubviews addObject:radioButton];
        [buttons addObject:radioButton];
    }
    
    [self addOtherRadioButtons:buttons];
}

- (void)multipleChoiceQuestionWithTitle:(NSString*)title options:(NSArray*)options {
    UILabel *questionLabel = [UILabel new];
    questionLabel.text = title;
    questionLabel.numberOfLines = 0;
    questionLabel.font = [UIFont systemFontOfSize:14.0];
    [arrangedSubviews addObject:questionLabel];
    
    NSMutableArray *buttons = [NSMutableArray new];
    
    for (NSString *option in options) {
        DLRadioButton *radioButton = [DLRadioButton new];
        radioButton.multipleSelectionEnabled = YES;
        radioButton.iconSquare = YES;
        [radioButton setTitle:option forState:UIControlStateNormal];
        [radioButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
        radioButton.iconColor = [UIColor blueColor];
        radioButton.indicatorColor = [UIColor blueColor];
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [arrangedSubviews addObject:radioButton];
        [buttons addObject:radioButton];
    }
    
    [self addOtherRadioButtons:buttons];
}

- (void)addOtherRadioButtons:(NSArray*)buttons {
    if (buttons.count>1) {
        DLRadioButton *firstButton = buttons[0];
        firstButton.otherButtons = [buttons subarrayWithRange:NSMakeRange(1, buttons.count-1)];
    }
}

@end
