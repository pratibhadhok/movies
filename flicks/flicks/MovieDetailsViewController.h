//
//  MovieDetailsViewController.h
//  flicks
//
//  Created by  Pratibha Dhok on 1/25/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MovieModel.h"

@interface MovieDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *movieTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *movieScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *MovieImage;
@property (weak, nonatomic) MovieModel *selectedMovie;

@end
