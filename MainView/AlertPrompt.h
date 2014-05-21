//
//  AlertPrompt.h
//  CustomAlert
//
//  Created by Tedi Fibri on 3/6/13.
//  Copyright (c) 2013 tediscript. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertPrompt : UIAlertView {
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField1;
@property (nonatomic, retain) UITextField *textField2;
@property (readonly) NSString *enteredText1;
@property (readonly) NSString *enteredText2;


- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end
