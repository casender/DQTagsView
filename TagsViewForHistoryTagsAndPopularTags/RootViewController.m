//
//  RootViewController.m
//  TagsViewForHistoryTagsAndPopularTags
//
//  Created by 丘鼎 on 7/28/16.
//  Copyright © 2016 丘鼎. All rights reserved.
//

#import "RootViewController.h"
#import "SearchViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)goToSearchView:(id)sender {
    SearchViewController *searchPage = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchPage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
