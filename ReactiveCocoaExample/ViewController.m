//
//  ViewController.m
//  ReactiveCocoaExample
//
//  Created by Arash on 3/28/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "ViewController.h"
#import "Network.h"

@interface ViewController (){
    UIImageView *animationImageView;
}
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic)Network *network;
@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.network = [Network new];
    [self setupSignals];
}
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
    
#pragma mark - custom methods
- (void)setupSignals{
    [[self.refreshButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self updateUI];
         });
         [[self.network fetchDate] subscribeNext:^(NSString *x) {
             NSLog(@"%@", x);
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.dateLabel.text = x;
             });
         }error:^(NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self stopAnimating];
                 self.dateLabel.text = error.localizedDescription;
             });
             NSLog(@"%@", error.localizedDescription);
         }completed:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self stopAnimating];
             });
             NSLog(@"completed");
         }];
     }];
}
- (void)animating
    {
    [_refreshButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        // Load images
    NSArray *imageNames = @[@"refresh.png", @"refresh2.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
        // Normal Animation
    animationImageView = [[UIImageView alloc] initWithFrame:self.refreshButton.frame];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 0.45;
    
    [self.view addSubview:animationImageView];
    [animationImageView startAnimating];
    }
    
- (void)stopAnimating{
    [_refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [animationImageView stopAnimating];
}
    
- (void)updateUI{
    [self animating];
    self.dateLabel.text = @"fetching ...";
}
    @end
