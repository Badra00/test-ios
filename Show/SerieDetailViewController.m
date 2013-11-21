    //
//  SerieDetailViewController.m
//  Show
//
//  Created by Badradine Boulahia on 20/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import "SerieDetailViewController.h"
#import "Serie.h"
#import "SerieManager.h"
#import "SerieCommunicator.h"
#import "SerieDetailViewController.h"
#import "ImageUtil.h"

@interface SerieDetailViewController () <SerieManagerDelegate> {
    SerieManager *_manager;
}
@end

@implementation SerieDetailViewController

@synthesize serie;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _manager = [[SerieManager alloc] init];
    _manager.communicator = [[SerieCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    [super viewDidLoad];
	
    self.title = serie.name;
    
    NSString *urlAsString = [@"http://thetvdb.com/api/GetSeries.php?seriesname=" stringByAppendingString:[serie.name stringByReplacingOccurrencesOfString:@" " withString:@"%20" ]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [_manager.communicator searchSeriesForName:urlAsString];
}

- (IBAction)add:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    // Create a new serie
    NSManagedObject *newSerie = [NSEntityDescription insertNewObjectForEntityForName:@"Serie" inManagedObjectContext:context];
    [newSerie setValue:serie.name forKey:@"name"];
    [newSerie setValue:serie.idTvRage forKey:@"idTvRage"];
    [newSerie setValue:serie.idTvDb forKey:@"idTvDb"];
    [newSerie setValue:serie.pathBanner forKey:@"pathBanner"];
    [newSerie setValue:serie.startYear forKey:@"startYear"];
    [newSerie setValue:serie.status forKey:@"status"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier: @"showSerieDetail" sender: indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"ajout dans la base de donnée");
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"showSerieDetail"]) {
//        SerieDetailViewController *destViewController = segue.destinationViewController;
//        
//        NSIndexPath *indexPath = [sender isKindOfClass:[NSIndexPath class]] ? (NSIndexPath*)sender : [self.tableView indexPathForSelectedRow];
//        destViewController.serie = _series[indexPath.row];
//    }
//}

#pragma mark - SerieManagerDelegate
- (void)didReceiveSerie:(NSArray *)series
{
    for(Serie *s in series) {
        if ([serie.name isEqualToString:s.name]) {
            ImageUtil *imageUtil = [[ImageUtil alloc] init];
            
            serie.idTvDb = s.idTvDb;
            serie.synopsys = s.synopsys;
            
            UIImage *image = [imageUtil getImageFromURL:[@"http://thetvdb.com/banners/" stringByAppendingString:s.bannerName]];
            [imageUtil saveImage:image withFileName:s.bannerName ofType:@"jpg" inDirectory:@"Document/banners/"];
            
            serie.pathBanner = [@"Document/banners/" stringByAppendingString:s.bannerName];
            
            self.synopsis.text = serie.synopsys;
            self.banner.image = image;
            
            [self.view setNeedsDisplay];
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
