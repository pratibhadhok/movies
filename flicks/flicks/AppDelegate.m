//
//  AppDelegate.m
//  flicks
//
//  Created by  Pratibha Dhok on 1/24/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle bundleWithIdentifier: @"MovieController"]];
    
    // Set up the Now Playing Movie View Controller
    MovieViewController *nowPlayingMovieController = [storyBoard instantiateViewControllerWithIdentifier: @"MovieController"];
    nowPlayingMovieController.viewType = @"now_playing";
    nowPlayingMovieController.tabBarItem.title = @"Now Playing";
    nowPlayingMovieController.tabBarItem.image = [UIImage imageNamed:@"now_playing.png"];
    
    // Set up the Now Playing Movie View Controller
    MovieViewController *topRatedMovieController = [storyBoard instantiateViewControllerWithIdentifier: @"MovieController"];
    topRatedMovieController.viewType = @"top_rated";
    topRatedMovieController.tabBarItem.title = @"Top Rated";
    topRatedMovieController.tabBarItem.image = [UIImage imageNamed:@"top_rated.png"];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[nowPlayingMovieController, topRatedMovieController]];
    
    // Make the Tab Bar Controller the root view controller
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
