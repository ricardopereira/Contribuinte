//
//  AddContribuinteController.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 10/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "AddContribuinteController.h"

@interface AddContribuinteController ()

@end

@implementation AddContribuinteController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message withAcceptHandler:(void(^)(AddContribuinteController *sender))acceptHandler
{
    AddContribuinteController* this = [self alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];

    // Add action
    UIAlertAction *actionAdd = [UIAlertAction actionWithTitle:@"Adicionar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // On action
        acceptHandler(this);
    }];
    actionAdd.enabled = false;

    // Cancel action
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];

    [this addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Descrição";

        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            // Check if is empty
            if ([textField.text isEqualToString:@""])
                actionAdd.enabled = false;
        }];
    }];

    [this addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Número";
        textField.keyboardType = UIKeyboardTypeNumberPad;

        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            // Check if is empty
            actionAdd.enabled = ![textField.text isEqualToString:@""];
            actionAdd.enabled = actionAdd.enabled && textField.text.length <= 9;
            actionAdd.enabled = actionAdd.enabled && textField.text.integerValue > 0;
        }];
    }];

    [this addAction:actionAdd];
    [this addAction:actionCancel];

    return this;
}

@end
