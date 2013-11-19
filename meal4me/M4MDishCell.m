//
//  M4MDishCell.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MDishCell.h"

@implementation M4MDishCell
@synthesize nameLabel = _nameLabel;
@synthesize photoView = _photoView;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize priceLabel = _priceLabel;
@synthesize healthSignalView = _healthSignalView;

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
