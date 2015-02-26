//
//  ViewController.m
//  MacysExample
//
//  Created by CMGabriel on 2/26/15.
//  Copyright (c) 2015 AkhileshSharma. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController ()
-(void) loadDataFromURL:(NSString *) data;
-(NSString *) getTextToDisplay:(NSDictionary *) dataDictionary;
@end

@implementation ViewController

@synthesize dataArrayObject;
@synthesize dataTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - TableView Delegate And Datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArrayObject count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_identifier = @"resultstableviewidentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    
    UILabel *labelView = (UILabel*)[cell viewWithTag:1];
    
    
    NSDictionary *resultObject = [dataArrayObject objectAtIndex:indexPath.row];
    labelView.text = [self getTextToDisplay:resultObject];
    [labelView setNeedsDisplay];
    
    NSLog(@"Object %@",resultObject);
    
    return cell;
}

- (IBAction)goButtonTapped:(id)sender {
    NSLog(@"Go button pressed");
    NSString *textData = self.dataTextField.text;
    
    if([textData isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The field cannot be left blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        NSLog(@"%@",textData);
        //Enable the AFNetworking request and load the data in the tableview.
        [self loadDataFromURL:textData];
    }
}

#pragma mark -
#pragma mark - Custom Methods

-(void) loadDataFromURL:(NSString *) data
{
    //Load the data using the AFNetworking operation.
    NSString *urlString = [NSString stringWithFormat:@"%@?sf=%@",DATA_URL,data];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //Operation
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    requestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Convert the data to JSON Format to be consumed by the data services.
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if([responseObject isKindOfClass:[NSData class]])
            {
                //Convert the data to dataobject.
                NSArray *responseArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                self.dataArrayObject = [[responseArray objectAtIndex:0] objectForKey:@"lfs"];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.resultsTableView reloadData];
                });
            }
            
        });
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation Unsuccessful %@",[error description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Cannot fetch data from feed. Please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    [requestOperation start];
}

-(NSString *) getTextToDisplay:(NSDictionary *) dataDictionary
{
    NSString *displayText = [dataDictionary objectForKey:@"lf"];
    
    return  displayText;
}
@end
