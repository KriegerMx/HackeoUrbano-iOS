//
//  SurveyViewController.h
//  HackeoUrbano
//
//  Created by Marlon Vargas Contreras on 5/3/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton/DLRadioButton.h"
#import "HUColor.h"
#import "Masonry.h"
#import "HCSStarRatingView.h"
#import "GTLDashboardAPIQuestionnaireWrapper.h"
#import "GTLDateTime.h"
#import "GTLQueryDashboardAPI.h"
#import "GTLServiceDashboardAPI.h"
#import "ProgressHUD.h"

@interface SurveyViewController : UIViewController <UITextFieldDelegate>

@property (copy) NSNumber *trailId;

@end
