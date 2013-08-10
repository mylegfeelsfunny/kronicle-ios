//
//  ViewController.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "ViewController.h"
#import "KRViewController.h"
#import "KRCreateViewController.h"
#import "KRAPIStore.h"
#import "KRCategoriesViewController.h"
#import "KRGlobals.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*
    void(^completionBlock)(KRKronicle *kronicle, NSError *err) = ^(KRKronicle *kronicle, NSError *err) {
        KRViewController *kronicleViewController = [[KRViewController alloc] initWithNibName:@"KRViewController" andKronicle:kronicle];
        [self.navigationController pushViewController:kronicleViewController animated:YES];
    };
    
    [[KRAPIStore sharedStore] fetchKronicle:@"51aab816631eb50000000008" withCompletion:completionBlock];
     */
    
    
#if kDEBUG
    KRCategoriesViewController *categoryViewController = [[KRCategoriesViewController alloc] initWithNibName:@"KRCategoriesViewController" bundle:nil];
    [self.navigationController pushViewController:categoryViewController animated:YES];
#endif

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    KRCategoriesViewController *categoryViewController = [[KRCategoriesViewController alloc] initWithNibName:@"KRCategoriesViewController" bundle:nil];
    [self.navigationController pushViewController:categoryViewController animated:YES];
}

- (IBAction)create:(id)sender {
    KRCreateViewController *createViewController = [[KRCreateViewController alloc] initWithNibName:@"KRCreateViewController" bundle:nil];
    [self.navigationController pushViewController:createViewController animated:YES];
}

@end
