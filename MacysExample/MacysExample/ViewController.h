//
//  ViewController.h
//  MacysExample
//
//  Created by CMGabriel on 2/26/15.
//  Copyright (c) 2015 AkhileshSharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UITextField *dataTextField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (strong, nonatomic) NSMutableArray *dataArrayObject;

- (IBAction)goButtonTapped:(id)sender;

@end

