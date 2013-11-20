//
//  SerieViewController.m
//  Show
//
//  Created by Badradine Boulahia on 19/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import "SerieViewController.h"
#import "Serie.h"
#import "SerieManager.h"
#import "SerieCommunicator.h"
#import "SerieDetailViewController.h"

@interface SerieViewController () <SerieManagerDelegate> {
    NSArray *_series;
    SerieManager *_manager;
}
@end

@implementation SerieViewController

@synthesize tableView;

- (void)viewDidLoad
{
    _manager = [[SerieManager alloc] init];
    _manager.communicator = [[SerieCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    [super viewDidLoad];
    
    self.title = @"Serie";
}

#pragma mark - SerieManagerDelegate
- (void)didReceiveSerie:(NSArray *)series
{
    _series = series;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _series.count;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    if (cell == nil) {
       UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }

    Serie* serie = _series[indexPath.row];
    cell.textLabel.text = serie.name;
    
    return cell;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    if(![searchString  isEqual: @""]) {
        searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [_manager searchSeriesForName:searchString];
    }
    
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"showSerieDetail" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSerieDetail"]) {
        SerieDetailViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        destViewController.serie = _series[indexPath.row];
    }
}

@end
