//
//  SWTextTableCell.m
//  StarWorld
//
//  Created by Aaron Baker on 12/12/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import "SWTextTableCell.h"
#import "SWTextTableItem.h"

@implementation SWTextTableCell



///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {

    
	self = [super initWithStyle:style reuseIdentifier:identifier];
    
    UIImageView *gradientView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-bg-blue.png"]];
    [self setBackgroundView:gradientView];
    [gradientView release];
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    return self;
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        
        TTTableTextItem* item = object;
        self.textLabel.text = item.text;
        //self.textLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);

        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = RGBCOLOR(79, 89, 105);
        self.textLabel.backgroundColor = [UIColor clearColor];

        self.textLabel.textAlignment = UITextAlignmentLeft;

    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    // XXXjoe Compute height based on font sizes
    
    
    CGSize givenSize;
    givenSize.height = 250;
    givenSize.width  = 270;
    
    
    CGSize textSize = [((SWTextTableItem *)object).text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:givenSize];
    
    if (textSize.height < 36.0) {
        textSize.height = 36.0;
    }
    
    //NSLog(@"TEXT SIZE HEIGHT IN Cell: %f",textSize.height);
    
    CGFloat textHeight = textSize.height + 24;
    
    return textHeight;
}




@end
