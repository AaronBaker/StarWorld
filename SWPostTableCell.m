//
//  SWPostTableCell.m
//  StarWorld
//
//  Created by Aaron Baker on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPostTableCell.h"
#import "SWPostTableItem.h"
#import "SWUnitConverter.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

static const CGFloat    kMessageTextWidth           = 230.0f;
static const NSInteger  kMessageTextLineCount       = 2;
static const CGFloat    kDefaultMessageImageWidth   = 34.0f;
static const CGFloat    kDefaultMessageImageHeight  = 34.0f;


@implementation SWPostTableCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:style reuseIdentifier:identifier];


    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        
        TTTableMessageItem* item = object;
        if (item.title.length) {
            self.titleLabel.text = item.title;
        }
        if (item.caption.length) {
            self.captionLabel.text = item.caption;
        }
        if (item.text.length) {
            self.detailTextLabel.text = item.text;
        }
        if (item.timestamp) {
            
            
            self.timestampLabel.text = [SWUnitConverter timeIntervalWithStartDate:item.timestamp withEndDate:[NSDate date]];
        }
        if (item.imageURL) {
            self.imageView2.urlPath = item.imageURL;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.font = TTSTYLEVAR(font);
        _titleLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    // XXXjoe Compute height based on font sizes
    
    CGFloat textWidth = 230.0f;
    
    CGSize givenSize;
    givenSize.height = 250;
    givenSize.width  = kMessageTextWidth;
    
    
    CGSize textSize = [((SWPostTableItem *)object).text sizeWithFont:TTSTYLEVAR(font) constrainedToSize:givenSize];
    
    NSLog(@"TEXT SIZE HEIGHT IN Cell: %f",textSize.height);
   
    CGFloat textHeight = textSize.height + 50;
    
    return textHeight;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat left = 0.0f;
    if (_imageView2) {
        _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
        left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
        
    } else {
        left = kTableCellMargin;
    }
    
    CGFloat width = self.contentView.width - left;
    CGFloat top = kTableCellSmallMargin;
    
    if (_timestampLabel.text.length) {
        [_timestampLabel sizeToFit];
        _timestampLabel.left = self.contentView.width - (_timestampLabel.width + kTableCellSmallMargin);
        _timestampLabel.top = top;
        //_titleLabel.width -= _timestampLabel.width + kTableCellSmallMargin*2;
        
    } else {
        _timestampLabel.frame = CGRectZero;
    }
    
    
    top = kTableCellSmallMargin;

    if (self.detailTextLabel.text.length) {
        //CGFloat textHeight = self.detailTextLabel.font.ttLineHeight * kMessageTextLineCount;

        
        CGSize givenSize;
        givenSize.height = 250;
        givenSize.width  = kMessageTextWidth;
        
        CGSize textSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:givenSize];
        
        
        NSLog(@"SOME TEXT: %@",self.detailTextLabel.text);
        
        CGFloat textTop = 6.0f;
        self.detailTextLabel.frame = CGRectMake(left, textTop, textSize.width, textSize.height);
        self.detailTextLabel.numberOfLines = 0;
        
        NSLog(@"TEXT SIZE HEIGHT IN LABEL: %f",textSize.height);
        
        top += self.detailTextLabel.height;
        
    } else {
        self.detailTextLabel.frame = CGRectZero;
    }    
    
    
    
    if (_titleLabel.text.length) {
        _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
        top += _titleLabel.height;
        
    } else {
        _titleLabel.frame = CGRectZero;
    }
    
    if (self.captionLabel.text.length) {
        self.captionLabel.frame = CGRectMake(left, top, width, self.captionLabel.font.ttLineHeight);
        top += self.captionLabel.height;
        
    } else {
        self.captionLabel.frame = CGRectZero;
    }
    

    

}






@end
