//
//  M4MFriendCell.m
//  meal4me
//
//  Created by Lancy on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "M4MFriendCell.h"

@interface M4MFriendCell()
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIImageView *iconView;

@end

@implementation M4MFriendCell
@synthesize iconView = _iconView;
@synthesize nameLabel = _nameLabel;
@synthesize iconImage = _iconImage;
@synthesize name = _name;

- (id) initWithFrame: (CGRect) frame reuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: reuseIdentifier];
    if ( self == nil )
        return ( nil );

    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 72, 20)];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    [nameLabel setText:@"no name"];
    self.nameLabel = nameLabel;
    
//    self.iconView = [[UIImageView alloc] ;
    
    
    [self.contentView addSubview:nameLabel];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.contentView.opaque = NO;
    self.opaque = NO;
    
    return ( self );
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.nameLabel setText:self.name];
}

@end
