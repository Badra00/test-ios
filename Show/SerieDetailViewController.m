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

@property (nonatomic, strong, readwrite) NSArray *languages;

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
    
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame = CGRectMake(round((self.view.frame.size.width - 25) / 2), round((self.view.frame.size.height - 25) / 2), 25, 25);
    av.tag  = 1;
    [self.view addSubview:av];
    [av startAnimating];
    
//    [_manager.communicator searchSeriesForName:urlAsString];
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.languages = [NSArray arrayWithObjects:@"fr",@"en", nil];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if (![self.languages containsObject:language]) {
        language = @"en";
    }
    
//    NSLog(@"%@",[NSString stringWithFormat:@"http://thetvdb.com/api/GetSeries.php?seriesname=%@&language=%@",[serie.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"],language]);
    //    NSString *urlAsString = [NSString stringWithFormat:@"http://thetvdb.com/api/GetSeries.php?seriesname=%@&language=%@",[serie.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"],language];
    
    ImageUtil *imageUtil = [[ImageUtil alloc] init];
    
    UIImage *image = [imageUtil getImageFromURL:[@"http://thetvdb.com/banners/" stringByAppendingString:serie.bannerName]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:[documentsDirectory stringByAppendingString:@"/banners/"] isDirectory:&isDir];
    if (exists) {
        if (isDir) {
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/banners/"];
        }
    } else {
       documentsDirectory = [self createDirectory:@"banners/" atFilePath:documentsDirectory];
    }
    
    //Enregistrement de l'image
    [imageUtil saveImage:image withFileName:serie.name ofType:@"jpg" inDirectory:documentsDirectory ];
    
    serie.pathBanner = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"%@.%@", [serie.name stringByReplacingOccurrencesOfString:@" " withString:@"_" ], @"jpg"]];
    
    self.synopsis.text = serie.synopsys;
    self.banner.image = image;
    
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [tmpimg removeFromSuperview];
    
    [self.view setNeedsDisplay];
    
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSString *)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    return filePathAndDirectory;
}

#pragma mark - SerieManagerDelegate
- (void)didReceiveSerie:(NSArray *)series
{
    for(Serie *s in series) {
        if ([serie.name isEqualToString:s.name]) {
            ImageUtil *imageUtil = [[ImageUtil alloc] init];
            
            serie.idTvDb = s.idTvDb;
            serie.synopsys = s.synopsys;
            
            UIImage *image = [imageUtil getImageFromURL:[@"http://thetvdb.com/banners/" stringByAppendingString:s.bannerName]];
            [imageUtil saveImage:image withFileName:s.bannerName ofType:@"jpg" inDirectory:@"Documents/banners/"];
            
            serie.pathBanner = [@"Document/banners/" stringByAppendingString:s.bannerName];
            
            self.synopsis.text = serie.synopsys;
            self.banner.image = image;
            
            [self.view setNeedsDisplay];
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
