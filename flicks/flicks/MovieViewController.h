//
//  ViewController.h
//  flicks
//
//  Created by  Pratibha Dhok on 1/24/17.
//  Copyright © 2017 Pratibha Dhok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property  (weak, nonatomic) NSString *viewType;

@end

