//
//  MovieTableViewCell.h
//  Tomado
//
//  Created by Doupan Guo on 1/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end
