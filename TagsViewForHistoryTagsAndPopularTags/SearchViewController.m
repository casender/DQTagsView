//
//  SearchViewController.m
//  TagsViewForHistoryTagsAndPopularTags
//
//  Created by 丘鼎 on 7/28/16.
//  Copyright © 2016 丘鼎. All rights reserved.
//

#define DEF_NAV_HEIGHT 64
#define DEF_TAGS_POPULARTITLE @"Popular tags"
#define DEF_SEARCHTEXTFIELD_NOTICE @"Search for activities..."
#define DEF_SEARCHTEXTFIELD_X 10
#define DEF_SEARCHTEXTFIELD_FONT [UIFont systemFontOfSize:15]
#define DEF_CANCELBTN_WIDTH 55.5
#define DEF_CANCELBTN_Y 34.5
#define DEF_CANCELBTN_HEIGHT 19.5
#define DEF_BACKBTN_WIDTH 10
#define DEF_BACKBTN_HEIGHT 20

#import "SearchViewController.h"
#import "DQTagsView.h"

@interface SearchViewController ()<UITextFieldDelegate, DQTagsViewDelegate>{
    UITextField *_searchField;
    UIBarButtonItem *_rightBtn;
    UIBarButtonItem *_leftBtn;
    UIScrollView *_contentView;
    DQTagsView *_historyView;
    UIAlertController *_alert;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self initContentView];
    // Do any additional setup after loading the view.
}

-(void)initNavigationBar{
    //add search text field
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(DEF_SEARCHTEXTFIELD_X, 25, UI_IOS_WINDOW_WIDTH - DEF_SEARCHTEXTFIELD_X - 65, 30)];
    _searchField.delegate = self;
    _searchField.backgroundColor = UIColorRGB(0x0069C8);
    _searchField.borderStyle = UITextBorderStyleRoundedRect;
    _searchField.textColor = [UIColor whiteColor];
    _searchField.font = DEF_SEARCHTEXTFIELD_FONT;
    NSAttributedString *notice = [[NSAttributedString alloc] initWithString:DEF_SEARCHTEXTFIELD_NOTICE attributes:@{NSFontAttributeName:DEF_SEARCHTEXTFIELD_FONT, NSForegroundColorAttributeName:UIColorRGB(0x7DC2FF)}];
    _searchField.attributedPlaceholder = notice;
    self.navigationItem.titleView = _searchField;
    //add cancel button for going back to previous page
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEF_CANCELBTN_WIDTH, DEF_CANCELBTN_HEIGHT)];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [cancelBtn setTitleColor:UIColorRGB(0x7DC2FF) forState:UIControlStateHighlighted];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15.5]];
    [cancelBtn addTarget:self action:@selector(cancelAndGoBack) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = _rightBtn;
    //add tap gesture to resign the search field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignSearchField)];
    [self.view addGestureRecognizer:tap];
    //add prepare the go back button for search result
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEF_BACKBTN_WIDTH, DEF_CANCELBTN_HEIGHT)];
    UIImage *backImg = [[UIImage imageNamed:@"Search_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [backBtn setImage:backImg forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    [backBtn addTarget:self action:@selector(cancelAndGoBack) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

-(void)initContentView{
    //prepare dummy data for popular tags
    NSArray *popularTags = @[@"Hiking", @"Test", @"Business", @"Apple"];
    
    //how DQTagsView use
    _historyView = [[DQTagsView alloc] initWithFrame:CGRectMake(0, DEF_NAV_HEIGHT, UI_IOS_WINDOW_WIDTH, 60) andTitle:DEF_TAGS_POPULARTITLE andData:popularTags andCanDelete:YES];
    _historyView.delegate = self;
    [self.view addSubview:_historyView];
}

-(void)cancelAndGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)resignSearchField{
    if ([_searchField isFirstResponder]) {
        [_searchField resignFirstResponder];
    }
}

-(void)hideTagsViewAndShowSearchResultWith:(NSString *)result{
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = _leftBtn;
    }];
    
    //save the search result to local data if the result is not the same with any others in local data
    [self compareAndSaveSearchResultWith:result];
    
}

-(void)compareAndSaveSearchResultWith:(NSString *)result{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyArr = [NSMutableArray arrayWithArray: [userDefault objectForKey:DEF_KEYFORHISTORYTAGS]];
    if (!historyArr) {
        historyArr = [NSMutableArray arrayWithObject:result];
    }
    else{
        BOOL hasSameName = NO;
        for (NSString *tagName in historyArr) {
            if ([tagName isEqualToString:result]) {
                hasSameName = YES;
            }
        }
        if (!hasSameName) {
            [historyArr addObject:result];
        }
    }
    [userDefault setObject:historyArr forKey:DEF_KEYFORHISTORYTAGS];
    
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (!textField.text.length) {
        _alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Text field is empty..." preferredStyle:UIAlertControllerStyleActionSheet];
        [self.navigationController presentViewController:_alert animated:YES completion:^{
            [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:2];
        }];
        return NO;
    }
    else{
        NSString *searchStr = [[textField.text copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self hideTagsViewAndShowSearchResultWith:searchStr];
        _alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Search result is saved..." preferredStyle:UIAlertControllerStyleActionSheet];
        [self.navigationController presentViewController:_alert animated:YES completion:^{
            [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:2];
        }];
        return YES;
    }
}

-(void)dismissAlertView{
    [_alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SearchViewDelegate
-(void)selectTag:(UIButton *)tagBtn{
    _searchField.text = tagBtn.titleLabel.text;
    NSString *searchStr = [[tagBtn.titleLabel.text copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self hideTagsViewAndShowSearchResultWith:searchStr];
}

-(void)deleteView:(UIButton *)deleteBtn{
    [_historyView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
