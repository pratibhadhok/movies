//
//  MovieDetailsViewController.m
//  flicks
//
//  Created by  Pratibha Dhok on 1/25/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTextView.text = self.selectedMovie.movieDescription;
    [self.MovieImage setImageWithURL:self.selectedMovie.posterURL];
    [self.movieTextView sizeToFit];

    CGFloat xMargin = 40;
    CGFloat bottomPadding = 50;
    CGFloat cardHeight = self.movieTextView.bounds.size.height;
    CGFloat cardOffset = cardHeight * 0.6;
    self.movieScrollView.frame = CGRectMake(xMargin, // x
                                       CGRectGetHeight(self.view.bounds) - cardHeight - bottomPadding, // y
                                       CGRectGetWidth(self.view.bounds) - 2 * xMargin, // width
                                       cardHeight); // height
    
    self.movieTextView.frame = CGRectMake(0, cardOffset, CGRectGetWidth(self.movieScrollView.bounds), cardHeight);
    
    // content height is the height of the card plus the offset we want
    CGFloat contentHeight =  cardHeight + cardOffset;
    self.movieScrollView.contentSize = CGSizeMake(self.movieScrollView.bounds.size.width, contentHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
