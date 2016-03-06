//
//  SurveyViewController.m
//  HackeoUrbano
//
//  Created by Marlon Vargas Contreras on 5/3/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "SurveyViewController.h"

@interface SurveyViewController (){
    UIScrollView *scrollView;
    UIView *containerView;
}


@end

@implementation SurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self firstSet];
    [self secondSet];
    [self thirdSet];
    
}

#pragma mark - Options & IBAction

- (void)firstSet{
    UILabel *lblQuestion1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 50, 262, 34)]; //x,y,width,length
    lblQuestion1.text = @"Tipo de transporte";
    lblQuestion1.textAlignment = NSTextAlignmentLeft;
    lblQuestion1.numberOfLines = 0;
    lblQuestion1.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    [self.view addSubview:lblQuestion1];
    
    DLRadioButton *firstRadioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 100, 262, 17)]; //original vas width / 2 - 131, 350, 262, 17
    firstRadioButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [firstRadioButton setTitle:@"Microbus" forState:UIControlStateNormal];
    [firstRadioButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    firstRadioButton.iconColor = [UIColor blueColor];
    firstRadioButton.indicatorColor = [UIColor blueColor];
    firstRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstRadioButton addTarget:self action:@selector(logSelectedBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstRadioButton];
    
    // other buttons
    NSArray *colorNames = @[@"Vagoneta", @"Autobus"];
    NSArray *buttonColors = @[[UIColor blueColor], [UIColor blueColor]];
    NSInteger i = 0;
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (UIColor *buttonColor in buttonColors) {
        // customize button
        DLRadioButton *radioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 130 + 30 * i, 262, 17)];
        radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [radioButton setTitle:colorNames[i] forState:UIControlStateNormal];
        [radioButton setTitleColor:buttonColor forState:UIControlStateNormal];
        radioButton.iconColor = buttonColor;
        radioButton.indicatorColor = buttonColor;
        
        /*NEW*/
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [otherButtons addObject:radioButton];
        [radioButton addTarget:self action:@selector(logSelectedBtn1:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:radioButton];
        i++;
    }
    
    firstRadioButton.otherButtons = otherButtons;
}

- (void)secondSet{
    UILabel *lblQuestion2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 190, 262, 34)]; //x,y,width,length
    lblQuestion2.text = @"Seguridad";
    lblQuestion2.textAlignment = NSTextAlignmentLeft;
    lblQuestion2.numberOfLines = 0;
    lblQuestion2.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    [self.view addSubview:lblQuestion2];
    
    DLRadioButton *secondRadioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 240, 262, 17)];
    secondRadioButton.multipleSelectionEnabled = YES;
    secondRadioButton.iconSquare = YES;
    secondRadioButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [secondRadioButton setTitle:@"Acoso sexual" forState:UIControlStateNormal];
    [secondRadioButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    secondRadioButton.iconColor = [UIColor blueColor];
    secondRadioButton.indicatorColor = [UIColor blueColor];
    secondRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [secondRadioButton addTarget:self action:@selector(logSelectedBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondRadioButton];
    
    // other buttons
    NSArray *colorNames = @[@"Robo con violencia", @"Robo sin violencia", @"Amenazas"];
    NSArray *buttonColors = @[[UIColor blueColor], [UIColor blueColor], [UIColor blueColor]];
    NSInteger i = 0;
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (UIColor *buttonColor in buttonColors) {
        // customize button
        DLRadioButton *radioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 270 + 30 * i, 262, 17)];
        radioButton.iconSquare = YES;
        radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [radioButton setTitle:colorNames[i] forState:UIControlStateNormal];
        [radioButton setTitleColor:buttonColor forState:UIControlStateNormal];
        radioButton.iconColor = buttonColor;
        radioButton.indicatorColor = buttonColor;
        radioButton.multipleSelectionEnabled = YES;
        
        /*NEW*/
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [otherButtons addObject:radioButton];
        [radioButton addTarget:self action:@selector(logSelectedBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:radioButton];
        i++;
    }
    
    secondRadioButton.otherButtons = otherButtons;
}
- (void) thirdSet{
    UILabel *lblQuestion3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 390, 262, 34)]; //x,y,width,length
    lblQuestion3.text = @"Aglomeración";
    lblQuestion3.textAlignment = NSTextAlignmentLeft;
    lblQuestion3.numberOfLines = 0;
    lblQuestion3.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    [self.view addSubview:lblQuestion3];
    
    DLRadioButton *thirdRadioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 440, 262, 17)];
    thirdRadioButton.multipleSelectionEnabled = YES;
    thirdRadioButton.iconSquare = YES;
    thirdRadioButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [thirdRadioButton setTitle:@"Habia espacio para sentarse" forState:UIControlStateNormal];
    [thirdRadioButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    thirdRadioButton.iconColor = [UIColor blueColor];
    thirdRadioButton.indicatorColor = [UIColor blueColor];
    thirdRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [thirdRadioButton addTarget:self action:@selector(logSelectedBtn3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdRadioButton];
    
    // other buttons
    NSArray *colorNames = @[@"Habia espacio de pie", @"Estaba lleno", @"Estaba saturado"];
    NSArray *buttonColors = @[[UIColor blueColor], [UIColor blueColor], [UIColor blueColor]];
    NSInteger i = 0;
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (UIColor *buttonColor in buttonColors) {
        // customize button
        DLRadioButton *radioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 131, 470 + 30 * i, 262, 17)];
        radioButton.iconSquare = YES;
        radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [radioButton setTitle:colorNames[i] forState:UIControlStateNormal];
        [radioButton setTitleColor:buttonColor forState:UIControlStateNormal];
        radioButton.iconColor = buttonColor;
        radioButton.indicatorColor = buttonColor;
        radioButton.multipleSelectionEnabled = YES;
        
        /*NEW*/
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [otherButtons addObject:radioButton];
        [radioButton addTarget:self action:@selector(logSelectedBtn3:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:radioButton];
        i++;
    }
    
    thirdRadioButton.otherButtons = otherButtons;
}

- (IBAction)logSelectedBtn1:(DLRadioButton *)radiobutton {
    if (radiobutton.isMultipleSelectionEnabled) {
        for (DLRadioButton *button in radiobutton.selectedButtons) {
            NSLog(@"%@ IS selected.\n", button.titleLabel.text);
        }
    } else {
        NSLog(@"%@ IS selected.\n", radiobutton.selectedButton.titleLabel.text);
    }
}

- (IBAction)logSelectedBtn2:(DLRadioButton *)radiobutton {
    if (radiobutton.isMultipleSelectionEnabled) {
        for (DLRadioButton *button in radiobutton.selectedButtons) {
            NSLog(@"%@ IS selected.\n", button.titleLabel.text);
        }
    } else {
        NSLog(@"%@ IS selected.\n", radiobutton.selectedButton.titleLabel.text);
    }
}

- (IBAction)logSelectedBtn3:(DLRadioButton *)radiobutton {
    if (radiobutton.isMultipleSelectionEnabled) {
        for (DLRadioButton *button in radiobutton.selectedButtons) {
            NSLog(@"%@ IS selected.\n", button.titleLabel.text);
        }
    } else {
        NSLog(@"%@ IS selected.\n", radiobutton.selectedButton.titleLabel.text);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
