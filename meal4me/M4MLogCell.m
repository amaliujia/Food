//
//  M4MLogCell.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MLogCell.h"

@implementation M4MLogCell
@synthesize timeLabel = _timeLabel;
@synthesize restNameLabel = _restNameLabel;
@synthesize priceLabel = _priceLabel;
@synthesize orderListLabel = _orderListLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
