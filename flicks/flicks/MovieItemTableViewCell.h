//
//  MovieItemTableViewCell.h
//  flicks
//
//  Created by  Pratibha Dhok on 1/24/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImage;

@end
