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
    UITextField *scheduleTextField;
    UIButton *acceptButton;
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
    stackView.spacing = 20.0;
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
    [self questionWithTitle:@"Tipo de transporte" options:@[@"Microbús",@"Vagoneta", @"Autobús"] multipleChoice:NO];
    [self addScheduleQuestion];
    [self questionWithTitle:@"Aglomeración" options:@[@"Había espacio para sentarse", @"Habia espacio de pie", @"Estaba lleno", @"Estaba saturado"] multipleChoice:NO];
    [self questionWithTitle:@"Seguridad" options: @[@"Acoso sexual", @"Robo con violencia", @"Robo sin violencia", @"Amenazas"] multipleChoice:YES];
    [self questionWithTitle:@"Estado del vehículo" options:@[@"El vehículo tenía choques (hojalatería)", @"El vehículo tenía cromática no oficial", @"Mal estado de los asientos", @"Iluminación nocturna insuficiente", @"Volunen alto de la música"] multipleChoice: YES];
    [self questionWithTitle:@"Faltas al reglamento de tránsito" options:@[@"Exceso de velocidad", @"No respetó la señalética", @"No respetó la cebra peatonal", @"El chofer estaba hablando por teléfono", @"Consumo de estupefacientes (alcohol, tabaco u otros", @"El chofer estaba texteando", @"Bloqueo de la vía pública", @"Conducir con la puerta abierta"] multipleChoice:YES];
}

- (void)addScheduleQuestion {
    NSDate *date = [NSDate new];
    
    UIDatePicker *picker = [UIDatePicker new];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker setDatePickerMode:UIDatePickerModeTime];
        [picker setDate:date animated:YES];
        [picker addTarget:self action:@selector(updateTextField) forControlEvents:UIControlEventValueChanged];
    });
    
    UILabel *scheduleLabel = [UILabel new];
    scheduleLabel.textColor = [HUColor textColor];
    scheduleLabel.text = @"¿En qué horario te subiste?";
    scheduleLabel.numberOfLines = 0;
    [arrangedSubviews addObject:scheduleLabel];
    
    UIView *tfView = [UIView new];
    
    scheduleTextField = [UITextField new];
    scheduleTextField.borderStyle = UITextBorderStyleRoundedRect;
    scheduleTextField.placeholder = @"Horario";
    scheduleTextField.delegate = self;
    [scheduleTextField setInputView:picker];
    [tfView addSubview:scheduleTextField];
    
    acceptButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [acceptButton setTitle:@"Aceptar" forState:UIControlStateNormal];
    [acceptButton setTitleColor:[HUColor secondaryColor] forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
    [tfView addSubview:acceptButton];
    
    [scheduleTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tfView.mas_top);
        make.left.equalTo(tfView.mas_left);
        make.right.equalTo(acceptButton.mas_left).offset(-10);
        make.bottom.equalTo(tfView.mas_bottom);
    }];
    
    [acceptButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scheduleTextField.mas_right).offset(10);
        make.right.equalTo(tfView.mas_right);
        make.centerY.equalTo(tfView.mas_centerY);
        make.width.equalTo(@0);
    }];
    
    [arrangedSubviews addObject:tfView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self updateTextField];
    [acceptButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@55);
    }];
}

- (void)updateTextField {
    UIDatePicker *picker = (UIDatePicker*)scheduleTextField.inputView;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm aaa"];
    scheduleTextField.text = [dateFormatter stringFromDate:picker.date];
}

- (void)dismissPicker {
    [scheduleTextField resignFirstResponder];
    [acceptButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
    }];
}

- (void)questionWithTitle:(NSString*)title options:(NSArray*)options multipleChoice:(BOOL)multipleChoice {
    UILabel *questionLabel = [UILabel new];
    questionLabel.textColor = [HUColor textColor];
    questionLabel.text = title;
    questionLabel.numberOfLines = 0;
    [arrangedSubviews addObject:questionLabel];
    
    NSMutableArray *buttons = [NSMutableArray new];
    
    for (NSString *option in options) {
        DLRadioButton *radioButton = [DLRadioButton new];
        
        if (multipleChoice) {
            radioButton.multipleSelectionEnabled = YES;
            radioButton.iconSquare = YES;
        }
        
        [radioButton setTitle:option forState:UIControlStateNormal];
        [radioButton setTitleColor:[HUColor secondaryColor] forState:UIControlStateNormal];
        radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
        radioButton.iconColor = [HUColor secondaryColor];
        radioButton.indicatorColor = [HUColor secondaryColor];
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
