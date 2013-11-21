//
//  ImageUtil.h
//  Show
//
//  Created by Badradine Boulahia on 21/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject

-(UIImage *) getImageFromURL:(NSString *)fileURL;
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;


@end
