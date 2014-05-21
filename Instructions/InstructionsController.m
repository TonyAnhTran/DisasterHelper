//
//  InstructionsController.m
//  DisasterHelper
//
//  Created by ENCLAVEIT on 3/19/14.
//  Copyright (c) 2014 Tan (Tharin) T.NGUYEN. All rights reserved.
//

#import "InstructionsController.h"

@interface InstructionsController ()

@end

@implementation InstructionsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    //Custom navigator back button
    
    UIImage *buttonImage = [UIImage imageNamed:@"back111.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *content=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"adf" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
   // NSLog(@"%@",content);
    [webInstruction loadHTMLString:content baseURL:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
