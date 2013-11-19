//
//  M4MRestarantCell.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MRestaurantCell.h"

@implementation M4MRestaurantCell
@synthesize photoView = _photoView;
@synthesize nameLabel = _nameLabel;
@synthesize typeLabel = _typeLabel;
@synthesize rateLabel = _rateLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize addressLabel = _addressLabel;

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
