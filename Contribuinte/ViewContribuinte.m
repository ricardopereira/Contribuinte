//
//  ViewContribuinte.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 08/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "ViewContribuinte.h"
#import "AddContribuinteController.h"
#import "ContribuinteModel.h"

#import <ctype.h>
#import <ZXingObjC/ZXingObjC.h>

@interface ViewContribuinte()

@property (nonatomic) id <OwnerProtocol> owner;

@end

@implementation ViewContribuinte

- (void)assignOwner:(id <OwnerProtocol>)owner
{
    self.owner = owner;
}

- (void)setupLayout:(Contribuinte*)contribuinte withRoot:(UIView*)view
{
    self.labelDescription.text = contribuinte.description;

    self.labelContribuinte.text = [self formatContribuinte:contribuinte.number];
    [self.labelContribuinte sizeToFit];
    self.labelContribuinte.textAlignment = NSTextAlignmentCenter;
    self.labelContribuinte.center = view.center;

    self.buttonAdd.center = CGPointMake(view.center.x, view.frame.size.height-25);

    self.buttonBarCode.center = CGPointMake(view.center.x, view.frame.size.height-self.buttonBarCode.frame.size.height-10);
}

- (IBAction)didTouchButtonCode:(id)sender
{
    if (self.imageCode.hidden) {
        self.imageCode.hidden = false;
        self.labelContribuinte.hidden = true;
        [self.buttonBarCode setTitle:@"Número" forState:UIControlStateNormal];
    }
    else {
        self.imageCode.hidden = true;
        self.labelContribuinte.hidden = false;
        [self.buttonBarCode setTitle:@"Código de Barras" forState:UIControlStateNormal];
    }
}

- (UIImage*)generateCodeBarEAN13:(NSInteger)number
{
    NSString *number12 = [NSString stringWithFormat:@"%ld",(long)number];

    if (number12.length > 12)
        return nil;

    // Trim!
    number12 = [number12 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([number12 isEqualToString:@""])
        return nil;

    NSInteger remaining = 12 - number12.length;

    if (remaining > 0) {
        for (int i=0; i<remaining; i++)
            number12 = [NSString stringWithFormat:@"%@%@",@"0",number12];
    }

    NSInteger checksumDigit = [self generateEAN13ChecksumDigit:number12];
    // Error?
    if (checksumDigit == -1)
        return nil;

    // Concatenate number with checksum to form EAN13
    NSString *ean13 = [NSString stringWithFormat:@"%@%ld",number12,(long)checksumDigit];

    NSError *error = nil;
    // BarCode
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:ean13
                                  format:kBarcodeFormatEan13
                                   width:100
                                  height:100
                                   error:&error];
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        return [UIImage imageWithCGImage:image.cgimage];
    }
    else
        return nil;
}

- (NSInteger)generateEAN13ChecksumDigit:(NSString*)first12digits
{
    const int error = -1; //Error

    if (first12digits.length != 12)
        return error;

    NSInteger total = 0;
    for (int i=0; i<12; i++) {
        int multiplicator = i % 2 == 0 ? 1 : 3;

        // Check if char is number!
        if (!isdigit([first12digits characterAtIndex:i]))
            return error;

        total += [first12digits substringWithRange:NSMakeRange(i, 1)].intValue * multiplicator;
    }

    // Checksum digit
    return 10 - (total % 10);
}

- (NSString*)formatContribuinte:(NSInteger)number
{
    NSString* contribuinte = [NSString stringWithFormat:@"%ld",(long)number];
    NSString* formatted = @"";

    // Format number with spaces on each 3 chars
    for (int i=(long)contribuinte.length-1; i>=0; i--) {
        // Check limit
        if (i < 3) {
            formatted = [NSString stringWithFormat:@"%@%@",[contribuinte substringWithRange:NSMakeRange(0,i+1)],formatted];
            break;
        }
        else {
            formatted = [NSString stringWithFormat:@"%@%@%@",@" ",[contribuinte substringWithRange:NSMakeRange(i-2,3)],formatted];
            i -= 2;
        }
    }
    return formatted;
}


#pragma mark - IBActions

- (IBAction)didTouchButtonAdd:(id)sender
{
    if (self.owner == nil)
        return;
    // Dialog
    AddContribuinteController *addContribuinteController = [AddContribuinteController alertControllerWithTitle:@"Contribuinte" message:@"Indique o número de identificação fiscal" withAcceptHandler:^(AddContribuinteController *sender) {
        // Accepted
        if (sender == nil)
            return;

        UITextField *fieldDescription = [[sender textFields] firstObject];
        UITextField *fieldNumber = [[sender textFields] lastObject];

        ContribuinteModel *model = [[ContribuinteModel alloc] init];
        [model addContribuinte:fieldDescription.text withNumber:fieldNumber.text.integerValue];
    }];

    // Show
    [self.owner presentViewController:addContribuinteController animated:true completion:nil];
}

- (IBAction)didTouchButtonRemove:(id)sender
{

}

@end
