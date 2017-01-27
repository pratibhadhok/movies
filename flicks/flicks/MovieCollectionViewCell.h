//
//  MovieCollectionViewCell.h
//  flicks
//
//  Created by  Pratibha Dhok on 1/26/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
@interface MovieCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) MovieModel *model;

- (void) reloadData;
@end
