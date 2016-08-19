//
//  DQTagsView.m
//  TagsViewForHistoryTagsAndPopularTags
//
//  Created by 丘鼎 on 7/28/16.
//  Copyright © 2016 丘鼎. All rights reserved.
//

#define DEF_TAGS_POPULARTITLE @"Popular tags"
#define DEF_TAGS_HISTORYTITLE @"History"
#define DEF_POPULARTITLE_X 17.5
#define DEF_POPULARTITLE_Y 20
#define DEF_POPULARTITLE_HEIGHT 22.5
#define DEF_POPULARTITLE_FONT [UIFont boldSystemFontOfSize:18]
#define DEF_TAGS_REGULARSIZE [UIFont systemFontOfSize:15]
#define Def_Tags_BackgroundColor UIColorRGB(0xDCDCDC)
#define Def_Tags_TitleColor UIColorRGB(0x4A4A4A)
#define DEF_TAGS_HEIGHT 22.5

#define DEF_TAGS_TAG 1401
#define DEF_TAGS_WIDTHTOEDGE 17.5
#define DEF_TAGS_WIDTHFORGAP 7
#define DEF_TAGS_HORIZONTAL_INTERVAL 10
#define DEF_TAGS_VERTICAL_INTERVAL 12.5
#define DEF_TAGS_DISTANCETOTITLE 10
//delete button
#define DEF_DELETEBTN_WIDTH 15
#define DEF_DELETEBTN_HEIGHT 17.5
//delete button image
#define DEF_DELETEBTN_IMAGE @"trash"

#import "DQTagsView.h"

@implementation DQTagsView

//height will be computed automatically
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andData:(NSArray *)array andCanDelete:(BOOL)hasDelete{
    if (self = [super initWithFrame:frame]) {
        if (array.count || title.length) {
            //add title on tags view
            CGSize titleSize = [self boundingRectWithSize:CGSizeMake(1000, DEF_POPULARTITLE_HEIGHT) andString:title andFont:DEF_POPULARTITLE_FONT];
            UILabel *popularTitle = [[UILabel alloc] initWithFrame:CGRectMake(DEF_POPULARTITLE_X, DEF_POPULARTITLE_Y, titleSize.width, DEF_POPULARTITLE_HEIGHT)];
            popularTitle.text = title;
            popularTitle.font = DEF_POPULARTITLE_FONT;
            popularTitle.textColor = UIColorRGB(0x9B9B9B);
            [self addSubview:popularTitle];
            
            //add delete button if needed
            [self addDeleteBtnToViewWithConfirmation:hasDelete];
            
            //compute the total width of tags, if bigger than width of screen, then add to the next line
            CGFloat totalWidth = 2 * DEF_TAGS_WIDTHTOEDGE;
            CGFloat tagY = popularTitle.frame.origin.y + popularTitle.frame.size.height + DEF_TAGS_HORIZONTAL_INTERVAL;
            for (int i = 0; i < array.count; i ++) {
                CGFloat tagWidth = 0;
                CGSize tagNameSize = [self boundingRectWithSize:CGSizeMake(1000, DEF_TAGS_HEIGHT) andString:array[i] andFont:DEF_TAGS_REGULARSIZE];
                if (tagNameSize.width > UI_IOS_WINDOW_WIDTH - 2 * DEF_TAGS_WIDTHTOEDGE) {
                    tagWidth = UI_IOS_WINDOW_WIDTH - 2* DEF_TAGS_WIDTHTOEDGE;
                }
                else{
                    tagWidth = tagNameSize.width + 2 * DEF_TAGS_WIDTHFORGAP;
                }
                if (totalWidth + tagWidth > UI_IOS_WINDOW_WIDTH) {
                    totalWidth = 2 * DEF_TAGS_WIDTHTOEDGE;
                    tagY += DEF_TAGS_HEIGHT + DEF_TAGS_VERTICAL_INTERVAL;
                }
                UIButton *tag = [[UIButton alloc] initWithFrame:CGRectMake(totalWidth - DEF_TAGS_WIDTHTOEDGE, tagY, tagWidth, DEF_TAGS_HEIGHT)];
                tag.tag = DEF_TAGS_TAG + i;
                tag.clipsToBounds = YES;
                tag.layer.cornerRadius = 5;
                [tag setTitle:array[i] forState:UIControlStateNormal];
                [tag setBackgroundColor:Def_Tags_BackgroundColor];
                [tag.titleLabel setFont:DEF_TAGS_REGULARSIZE];
                [tag setTitleColor:Def_Tags_TitleColor forState:UIControlStateNormal];
                [tag addTarget:self action:@selector(tagSelected:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:tag];
                totalWidth += tagWidth + DEF_TAGS_HORIZONTAL_INTERVAL;
            }
            UIButton *btn = (UIButton *)[self viewWithTag:(array.count - 1 + DEF_TAGS_TAG)];
            CGRect viewRect = self.frame;
            self.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y, viewRect.size.width, btn.frame.origin.y + btn.frame.size.height + 5);
        }
    }
    return self;
}

-(void)addDeleteBtnToViewWithConfirmation:(BOOL)ifNeeded{
    if (ifNeeded) {
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH - 16 - DEF_DELETEBTN_WIDTH, DEF_POPULARTITLE_Y, DEF_DELETEBTN_WIDTH, DEF_DELETEBTN_HEIGHT)];
        UIImage *trashImg = [UIImage imageNamed:DEF_DELETEBTN_IMAGE];
        [deleteBtn setImage:trashImg forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteWholeTagsView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
}

-(void)deleteWholeTagsView:(UIButton *)deleteBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteView:)]) {
        [self.delegate deleteView:deleteBtn];
    }
}

-(void)tagSelected:(UIButton *)tag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTag:)]) {
        [self.delegate selectTag:tag];
    }
}

- (CGSize)boundingRectWithSize:(CGSize)size andString:(NSString *)content andFont:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [content boundingRectWithSize:size
                                           options:
                      NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attribute
                                           context:nil].size;
    
    return retSize;
}

@end
