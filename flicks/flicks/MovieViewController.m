//
//  ViewController.m
//  flicks
//
//  Created by  Pratibha Dhok on 1/24/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieItemTableViewCell.h"
#import "MovieModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (strong, nonatomic) NSArray<MovieModel *> *searchedMovies;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.movieTableView.dataSource = self;
    [self fetchMovies];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieModel *model = self.movies[indexPath.row];
    MovieItemTableViewCell *cell = [_movieTableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    cell.movieTitle.text = model.title;
    cell.movieDescription.text = model.movieDescription;
    [cell.moviePosterImage setImageWithURL:model.posterURL];
    
    return cell;
}

- (void) fetchMovies {
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/movie/%@?api_key=%@", self.viewType,apiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    
                                                    NSArray *results = responseDictionary[@"results"];
                                                    
                                                    NSMutableArray *movieData = [NSMutableArray array];
                                                    for (NSDictionary *result in results) {
                                                        MovieModel *movieModel = [[MovieModel alloc]initWithDictionary:result];
                                                        //NSLog(@"Actual Movie Object: %@", movieModel);
                                                        [movieData addObject:movieModel];
                                                    }
                                                    self.movies = movieData;
                                                    [self.movieTableView reloadData];
                                                    
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
}


@end
