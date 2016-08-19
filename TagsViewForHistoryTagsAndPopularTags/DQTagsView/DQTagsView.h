//
//  DQTagsView.h
//  TagsViewForHistoryTagsAndPopularTags
//
//  Created by 丘鼎 on 7/28/16.
//  Copyright © 2016 丘鼎. All rights reserved.
//

//color
#define UIColorRGB(color) UIColorMakeRGB(color>>16, (color&0x00ff00)>>8,color&0x0000ff)
#define UIColorMakeRGB(nRed, nGreen, nBlue) UIColorMakeRGBA(nRed, nGreen, nBlue, 1.0f)
#define UIColorMakeRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
//compute the width of screen
#define UI_IOS_WINDOW_WIDTH (isPad?1024:([[UIScreen mainScreen] bounds].size.width))
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//key for history
#define DEF_KEYFORHISTORYTAGS @"historyTags"

#import <UIKit/UIKit.h>

@protocol DQTagsViewDelegate <NSObject>

-(void)selectTag:(UIButton *)tagBtn;

-(void)deleteView:(UIButton *)deleteBtn;

@end

@interface DQTagsView : UIView
@property(nonatomic, weak) id <DQTagsViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andData:(NSArray *)array andCanDelete:(BOOL)hasDelete;

@end
