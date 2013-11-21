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
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:Nil waitUntilDone:NO];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Serie* serie = _series[indexPath.row];
    cell.textLabel.text = serie.name;
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchString{
        if(searchString.length > 0) {
            searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [_manager searchSeriesForName:searchString];
        }
        else {
            _series = nil;
            [self.tableView reloadData];
        }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier: @"showSerieDetail" sender: self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ajout dans la base de donnée");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSerieDetail"]) {
        SerieDetailViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        destViewController.serie = _series[indexPath.row];
    }
}

@end
