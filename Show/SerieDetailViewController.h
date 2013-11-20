//
//  SerieDetailViewController.h
//  Show
//
//  Created by Badradine Boulahia on 20/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Serie.h"

@interface SerieDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UITextView *synopsis;

@property (nonatomic, strong) Serie *serie;

@end
