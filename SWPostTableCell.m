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

static const CGFloat    kMessageTextWidth           = 225.0f;
static const NSInteger  kMessageTextLineCount       = 2;
static const CGFloat    kDefaultMessageImageWidth   = 34.0f;
static const CGFloat    kDefaultMessageImageHeight  = 34.0f;


@implementation SWPostTableCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:style reuseIdentifier:identifier];
    
    
    currentUser = [SWCurrentUser currentUserInstance];
    
    //Initialize the "by" label.
    NSString *byLabelText = @"by ";
    CGSize byLabelSize = [byLabelText sizeWithFont:TTSTYLEVAR(font)];
    
    
    byLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, byLabelSize.width, byLabelSize.height)];
    byLabel.text = byLabelText;
    byLabel.font = TTSTYLEVAR(font);
    byLabel.textColor = RGBCOLOR(79, 89, 105);
    byLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:byLabel];
    
    [byLabel release];
    
    
    //Create a STAR Button
    starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [starButton setBackgroundImage:[UIImage imageNamed:@"star-inactive.png"] forState:UIControlStateNormal];
    [starButton setBackgroundImage:[UIImage imageNamed:@"star-pressed.png"] forState:UIControlStateHighlighted];
    [starButton addTarget:self action:@selector(plainButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    starButton.frame = CGRectMake(254.0, 6.0, 55.0, 55.0);
    [self addSubview:starButton];    
    
    
    
    //SETUP BACKGROUND VIEW
//    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
//    colorView.backgroundColor = [UIColor greenColor];
//    
//    [self setBackgroundView:colorView];
//    [colorView release];
    
    
    UIImageView *gradientView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-bg.png"]];
    [self setBackgroundView:gradientView];
    [gradientView release];
    
    
    //self.contentView.backgroundColor = [UIColor purpleColor];
    
    
    return self;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)plainButtonTapped:(id)sender {
    if ([sender backgroundImageForState:UIControlStateNormal] == [UIImage imageNamed:@"star-active.png"]) {//IF REMOVING STAR
        [sender setBackgroundImage:[UIImage imageNamed:@"star-inactive.png"] forState:UIControlStateNormal];
        NSLog(@"Plain UIButton was tapped; setting 'off' image. TAG: %d",starButton.tag);
        //[currentUser.starredPostIDs removeObjectIdenticalTo:[NSNumber numberWithInt: starButton.tag]];
        [currentUser removeStarForPostID:[NSNumber numberWithInt: starButton.tag]];

    } else {//If STARING a post
        [sender setBackgroundImage:[UIImage imageNamed:@"star-active.png"] forState:UIControlStateNormal];
        NSLog(@"Plain UIButton was tapped; setting 'on' image. TAG: %d",starButton.tag);
        //[currentUser.starredPostIDs addObject:[NSNumber numberWithInt: starButton.tag]];
        //[currentUser.starredPostIDs addObject:@"Beanpole"];
        [currentUser setStarForPostID:[NSNumber numberWithInt: starButton.tag]];
        
    }
    
    [sender setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        
        SWPostTableItem* item = object;
        
        
        NSLog(@"USER ARRAY: %@",currentUser.starredPostIDs);
        if ([currentUser.starredPostIDs containsObject:[NSNumber numberWithInt: item.ID]]) {
            
            [starButton setBackgroundImage:[UIImage imageNamed:@"star-active.png"] forState:UIControlStateNormal];

        } else {
            [starButton setBackgroundImage:[UIImage imageNamed:@"star-inactive.png"] forState:UIControlStateNormal];
        }
        
        
        
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
        
        starButton.tag = item.ID;
        
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
    

    CGSize givenSize;
    givenSize.height = 250;
    givenSize.width  = kMessageTextWidth;
    
    
    CGSize textSize = [((SWPostTableItem *)object).text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:givenSize];
    
    if (textSize.height < 36.0) {
        textSize.height = 36.0;
    }
    
    //NSLog(@"TEXT SIZE HEIGHT IN Cell: %f",textSize.height);
   
    CGFloat textHeight = textSize.height + 52;
    
    return textHeight;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat left = 12.0f;
    CGFloat top = 12.0f;
//    if (_imageView2) {
//        _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
//                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
//        left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
//        
//    } else {
//        left = kTableCellMargin;
//    }
    
    CGFloat width = self.contentView.width - left;
    CGFloat height = self.contentView.height;
    
    
    
    
        
    //Layout Textbox.
    if (self.detailTextLabel.text.length) {
        //CGFloat textHeight = self.detailTextLabel.font.ttLineHeight * kMessageTextLineCount;

        
        CGSize givenSize;
        givenSize.height = 250;
        givenSize.width  = kMessageTextWidth;
        
        CGSize textSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:givenSize];
        
        CGFloat textTop = top;
        
        if (textSize.height < 36.0) {
//            textTop += 18.0;
//            top += 18.0;
        }
        
        
        self.detailTextLabel.frame = CGRectMake(left, textTop, textSize.width, textSize.height);
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = RGBCOLOR(79, 89, 105);
        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
        
        
        top += self.detailTextLabel.height;
        
    } else {
        self.detailTextLabel.frame = CGRectZero;
    }    
    
    
    //Layout Name
    CGFloat nameTop;
    if (_titleLabel.text.length) {
        
        
        //Add a little padding after the text
        top += 8.0;
        
        nameTop = height - (byLabel.size.height + 13.0);
        
        
        byLabel.top = nameTop;
        byLabel.left = left;
        
        left += byLabel.frame.size.width;
        
        CGSize textSize = [_titleLabel.text sizeWithFont:self.detailTextLabel.font];
        
        
        _titleLabel.frame = CGRectMake(left, nameTop, textSize.width, _titleLabel.font.ttLineHeight);
        
        _titleLabel.textColor = RGBCOLOR(0, 149, 255);
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        left += _titleLabel.frame.size.width;
        
    } else {
        _titleLabel.frame = CGRectZero;
    }
    
    //Layout Timestamp...
    if (_timestampLabel.text.length) {
        
        left += 4;
        
        _timestampLabel.font = TTSTYLEVAR(font);
        [_timestampLabel sizeToFit];
        _timestampLabel.left = left;
        _timestampLabel.top = nameTop;
        _timestampLabel.textColor = RGBCOLOR(79, 89, 105);
        _timestampLabel.backgroundColor = [UIColor clearColor];

        
        
    } else {
        _timestampLabel.frame = CGRectZero;
    }
    
    //Layout StarButton
    
    starButton.top = (height / 2) - 38.0;
    
    
    //Layout Distance
    if (self.captionLabel.text.length) {
        
        CGSize distanceSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font];
        
        CGFloat distanceLeft = starButton.left - (distanceSize.width / 2) + 27.0;
        CGFloat distanceTop = starButton.size.height + starButton.top - 3.0;
        
        self.captionLabel.frame = CGRectMake(distanceLeft, distanceTop, distanceSize.width, distanceSize.height + 7);
        self.captionLabel.textColor = RGBCOLOR(98,193,39);
        
        
    } else {
        self.captionLabel.frame = CGRectZero;
    }
    

    

}






@end
