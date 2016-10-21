//
//  ViewController.m
//  HCButton
//
//  Created by Neil Burchfield on 10/20/16.
//  Copyright © 2016 Neil Burchfield. All rights reserved.
//

#import "ViewController.h"

// Button
#import "HCButton.h"

// Reactive
#import <ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HCButton *standardButton;
@property (weak, nonatomic) IBOutlet HCSocialButton *facebookButton;
@property (weak, nonatomic) IBOutlet HCSocialButton *twitterButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.standardButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[[RACSignal empty] delay:2.f] setNameWithFormat:@"standardButton"] logCompleted];
    }];

    self.facebookButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[[RACSignal empty] delay:2.f] setNameWithFormat:@"facebookButton"] logCompleted];
    }];

    self.twitterButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[[RACSignal empty] delay:2.f] setNameWithFormat:@"twitterButton"] logCompleted];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
