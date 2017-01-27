//
//  ViewController.m
//  flicks
//
//  Created by  Pratibha Dhok on 1/24/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "MovieViewController.h"
#import "MovieItemTableViewCell.h"
#import "MovieModel.h"
#import "MovieDetailsViewController.h"
#import "MovieCollectionViewCell.h"


@interface MovieViewController () <UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *movieCollectionView;
@property (strong, nonatomic) UISegmentedControl * segmentedControl;
@property (nonatomic, strong) UIRefreshControl *tableViewRefreshControl;
@property (nonatomic, strong) UIRefreshControl *collectionViewRefreshControl;

@property (strong, nonatomic) NSArray<MovieModel *> *movies;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.movieTableView.dataSource = self;

    // ---------  Create collectionView ------------------------
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat itemHeight = 150;
    CGFloat itemWidth = screenWidth/3;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(self.view.bounds, 0, 64) collectionViewLayout:layout];
    
    // Register cell for collection view
    [collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.hidden = YES;
    
    [self.view addSubview:collectionView];
    self.movieCollectionView = collectionView;
    // ---------  end Of collectionView --------------------------

    // Create segmented control
    NSArray *itemArray = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"list.png"],
                                [UIImage imageNamed:@"grid.png"],
                                nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(35, 200, 100, 30);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentSelectionChanged:) forControlEvents: UIControlEventValueChanged];
    self.segmentedControl = segmentedControl;
    
    //add segmented control bar button item to navigation bar
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
    
    // Refresh Control for table view - tableViewRefreshControl
    self.tableViewRefreshControl = [[UIRefreshControl alloc] init];
    [self.movieTableView setContentOffset:CGPointMake(0, self.tableViewRefreshControl.frame.size.height) animated:YES];
    [self.tableViewRefreshControl addTarget:self action:@selector(refreshMovieTableView) forControlEvents:UIControlEventValueChanged];
    [self.movieTableView insertSubview:self.tableViewRefreshControl atIndex:0];
    
    
    // Refresh Control for collection view - collectionViewRefreshControl
    self.collectionViewRefreshControl = [[UIRefreshControl alloc] init];
    [self.movieCollectionView setContentOffset:CGPointMake(0, self.collectionViewRefreshControl.frame.size.height) animated:YES];
    [self.collectionViewRefreshControl addTarget:self action:@selector(refreshMovieCollectionView) forControlEvents:UIControlEventValueChanged];
    [self.movieCollectionView insertSubview:self.collectionViewRefreshControl atIndex:0];

    [self fetchMovies];
}

- (void) refreshMovieTableView {
    [self refreshAllViews: self.tableViewRefreshControl];
}

- (void) refreshMovieCollectionView {
    [self refreshAllViews: self.collectionViewRefreshControl];
}

- (void) refreshAllViews: (UIRefreshControl*) refreshControl {
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/movie/%@?api_key=%@", self.viewType,apiKey];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data,
                                                                                  NSURLResponse *response,
                                                                                  NSError *connectionError) {
        [self processMovieData: data connectionError: connectionError];
        
        // - Set last updated timestamp
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor purpleColor] 
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        [refreshControl endRefreshing];
    }
    
    ] resume];
}

- (void) processMovieData:(NSData *)data  connectionError: (NSError *)connectionError {
    if (!connectionError) {
        NSError *jsonError = nil;
        NSDictionary *responseDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&jsonError];
        
        NSArray *results = responseDictionary[@"results"];
        
        NSMutableArray *movieData = [NSMutableArray array];
        for (NSDictionary *result in results) {
            MovieModel *movieModel = [[MovieModel alloc]initWithDictionary:result];
            [movieData addObject:movieModel];
        }
        NSLog(@"Refreshed movie contents : %lu", movieData.count);
        self.movies = movieData;
        [self.movieTableView reloadData];
        [self.movieCollectionView reloadData];
        
    } else {
        NSLog(@"An error occurred: %@", connectionError.description);
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"movieDetailsSegue"]){
        NSIndexPath *indexPath;
        if (1 == self.segmentedControl.selectedSegmentIndex ) {
           indexPath = [self.movieCollectionView indexPathForCell:sender];
        } else {
            indexPath = [self.movieTableView indexPathForCell:sender];
        }

        MovieModel *currentMovie = [self.movies objectAtIndex:indexPath.row];
        MovieDetailsViewController *detailViewController = (MovieDetailsViewController *)segue.destinationViewController;
        detailViewController.selectedMovie = currentMovie;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [self.movieCollectionView dequeueReusableCellWithReuseIdentifier: @"MovieCollectionViewCell" forIndexPath:indexPath];
    MovieModel *currentMovie = [self.movies objectAtIndex:indexPath.row];
    cell.model = currentMovie;
    [cell reloadData];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"movieDetailsSegue" sender: [self.movieCollectionView cellForItemAtIndexPath:indexPath]];
}

- (void) segmentSelectionChanged:(UISegmentedControl *) sender {
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    switch (selectedIndex) {
    case 1:
        self.movieCollectionView.hidden = NO;
        self.movieTableView.hidden = YES;
        break;
    case 0:
    default:
        self.movieCollectionView.hidden = YES;
        self.movieTableView.hidden = NO;

    }
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
                                                [self processMovieData: data connectionError: error];
                                }];
    [task resume];
}


@end
