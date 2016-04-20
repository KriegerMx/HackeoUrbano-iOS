//
//  AboutViewController.m
//  HackeoUrbano
//
//  Created by M on 3/6/16.
//  Copyright © 2016 Krieger. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController () {
    UITextView *textView;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[HUColor navBarTintColor]];
    self.view.backgroundColor = [HUColor backgroundColor];
    [self loadViews];
    [self setText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadViews {
    textView = [UITextView new];
    textView.editable = NO;
    [self.view addSubview:textView];

    
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setText {
    NSString *appName = @"Ruta de 10";
    NSString *version = [NSString stringWithFormat:@"Versión %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString *description = @" obtiene las rutas de transporte concesionado más cercanas a la ubicación del usuario y permite ver información detallada sobre ellas, así como calificarlas y proporcionar retroalimentación. Esta aplicación fue creada dentro de #HackeoUrbano y es alimentada mediante la API de la base de datos del transporte público concesionado de la Ciudad de México generada en Mapatón CDMX.";
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:[self titleWithText:appName]];
    [attributedText appendAttributedString:[self line]];
    [attributedText appendAttributedString:[self attributedText:version]];
    [attributedText appendAttributedString:[self line]];
    [attributedText appendAttributedString:[self attributedText:[NSString stringWithFormat:@"%@%@", appName, description]]];
    [attributedText appendAttributedString:[self line]];
    [attributedText appendAttributedString:[self titleWithText:@"Enlaces"]];
    [attributedText appendAttributedString:[self line]];
    [attributedText appendAttributedString:[self linkWithText:@"Mapatón" link:@"http://mapatoncd.mx/"]];
    [attributedText appendAttributedString:[self line]];
    [attributedText appendAttributedString:[self linkWithText:@"#HackeoUrbano" link:@"http://www.pidesinnovacion.org/hack/"]];
    [attributedText appendAttributedString:[self line]];
    [attributedText appendAttributedString:[self linkWithText:@"PIDES Innovación Social" link:@"http://www.pidesinnovacion.org/"]];
    [attributedText appendAttributedString:[self line]];
    [attributedText appendAttributedString:[self linkWithText:@"Krieger" link:@"http://krieger.mx"]];
    
    textView.attributedText = attributedText;
    textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    textView.textContainer.lineFragmentPadding = 0;
    textView.linkTextAttributes = @{NSForegroundColorAttributeName:[HUColor secondaryColor]};
}

- (NSAttributedString*)titleWithText:(NSString*)text {
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName:[HUColor titleColor]}];
    return title;
}

- (NSAttributedString*)attributedText:(NSString*)text {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:[HUColor textColor]}];
    return attributedText;
}

- (NSAttributedString*)line {
    NSAttributedString *line = [[NSAttributedString alloc] initWithString:@"\n\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[HUColor textColor]}];
    return line;
}

- (NSAttributedString*)linkWithText:(NSString*)text link:(NSString*)link {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:@{NSLinkAttributeName:link, NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:[HUColor textColor]}];
    return attributedString;
}

@end
