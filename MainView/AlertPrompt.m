//
//  AlertPrompt.m
//  CustomAlert
//
//  Created by Tedi Fibri on 3/6/13.
//  Copyright (c) 2013 tediscript. All rights reserved.
//

#import "AlertPrompt.h"

@implementation AlertPrompt

@synthesize textField1,textField2;
@synthesize enteredText1,enteredText2;


- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextField *theTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        [theTextField1 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:theTextField1];
        self.textField1 = theTextField1;
       // AlertPrompt.textField1 = @"\n";
        
        UITextField *theTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 75.0, 260.0, 25.0)];
        [theTextField2 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:theTextField2];
        self.textField2 = theTextField2;
        //[theTextField release];
//        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0);
//        [self setTransform:translate];
    }
    return self;
}
- (void)show
{
    [textField1 becomeFirstResponder];
    [super show];
}
- (NSString *)enteredText1
{
    return textField1.text;
}
- (NSString *)enteredText2
{
    return textField2.text;
}
- (id)initWithFrame:(CGRect)frame
{   
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
