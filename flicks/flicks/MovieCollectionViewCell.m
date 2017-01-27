//
//  MovieCollectionViewCell.m
//  flicks
//
//  Created by  Pratibha Dhok on 1/26/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import "MovieCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


// Private interface
@interface MovieCollectionViewCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MovieCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void) reloadData {
    // map the model to image view - Assumpution model is already set
    [self.imageView setImageWithURL:self.model.posterURL];
    
    [self setNeedsLayout]; // explictly layout the subviews are called
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
