//
//  SerieViewController.h
//  Show
//
//  Created by Badradine Boulahia on 19/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"

@interface SerieViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    XMLParser *xmlParser;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
