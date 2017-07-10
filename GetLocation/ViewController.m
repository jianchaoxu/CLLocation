//
//  ViewController.m
//  GetLocation
//
//  Created by apple on 2017/7/7.
//  Copyright © 2017年 xjc. All rights reserved.
//

#import "ViewController.h"
#import "JCLocation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)starlocation:(id)sender {
    NSLog(@"tag");
    [JCLocation getUserLocationMsg:^(NSString *lonAndLatStr, NSString *address, NSString *distance) {
        NSLog(@"longtitude latitude = %@, address = %@, distance = %@",lonAndLatStr,address,distance);
    }];    
}

- (IBAction)stoplocation:(id)sender {
    [JCLocation stopGetUserLoc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
