//
//  ViewController.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 08/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "ViewController.h"
#import "ViewContribuinte.h"
#import "SSStackedPageView.h"

#import <ctype.h>
#import <ZXingObjC/ZXingObjC.h>

@interface ViewController () <SSStackedViewDelegate>

@property (nonatomic) IBOutlet SSStackedPageView *stackView;
@property (nonatomic) NSMutableArray *views;

@property (nonatomic) CGFloat lastBrightness;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Config
    self.stackView.delegate = self;
    self.stackView.pagesHaveShadows = YES;
    self.views = [[NSMutableArray alloc] init];
    self.lastBrightness = -1;

    NSArray *contribuintes = @[@244413690, @13379548, @123456789];

    [self loadViewContribuintes:contribuintes];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)stackView:(SSStackedPageView *)stackView pageForIndex:(NSInteger)index
{
    UIView *thisView = [stackView dequeueReusablePage];
    if (!thisView) {
        thisView = [self.views objectAtIndex:index];

        // Color
        //thisView.backgroundColor = [UIColor lightGrayColor];

        thisView.layer.cornerRadius = 5;
        thisView.layer.masksToBounds = YES;
    }
    return thisView;
}

- (NSInteger)numberOfPagesForStackView:(SSStackedPageView *)stackView
{
    return [self.views count];
}

- (void)stackView:(SSStackedPageView *)stackView selectedPageAtIndex:(NSInteger) index
{
    // Brightness
    if (self.lastBrightness == -1) {
        self.lastBrightness = [UIScreen mainScreen].brightness;
        [[UIScreen mainScreen] setBrightness:1.0];
    }
    else {
        [[UIScreen mainScreen] setBrightness:self.lastBrightness];
        self.lastBrightness = -1;
    }
}

- (UIImage*)generateCodeBarEAN13:(NSInteger)number
{
    NSString *number12 = [NSString stringWithFormat:@"%d",number];

    if (number12.length > 12)
        return nil;

    // Trim!
    number12 = [number12 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([number12 isEqualToString:@""])
        return nil;

    int remaining = 12 - number12.length;

    if (remaining > 0) {
        for (int i=0; i<remaining; i++)
            number12 = [NSString stringWithFormat:@"%@%@",@"0",number12];
    }

    int checksumDigit = [self generateEAN13ChecksumDigit:number12];
    // Error?
    if (checksumDigit == -1)
        return nil;

    // Concatenate number with checksum to form EAN13
    NSString *ean13 = [NSString stringWithFormat:@"%@%d",number12,checksumDigit];

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
    NSString* contribuinte = [NSString stringWithFormat:@"%d",number];
    NSString* formatted = @"";

    for (int i=contribuinte.length-1; i>=0; i--) {
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

- (void)loadViewContribuintes:(NSArray*)list
{
    for (NSNumber *item in list) {
        // Create view
        ViewContribuinte *thisView = [[[NSBundle mainBundle] loadNibNamed:@"ViewContribuinte" owner:self options:nil] objectAtIndex:0];

        //thisView.imageCode.transform = CGAffineTransformMakeRotation(M_PI / 2);
        thisView.imageCode.image = [self generateCodeBarEAN13:item.integerValue];

        //thisView.labelContribuinte.transform = CGAffineTransformMakeRotation(M_PI / 2);
        thisView.labelContribuinte.text = [self formatContribuinte:item.integerValue];

        [self.views addObject:thisView];

        [thisView setNeedsLayout];
    }
}

@end
