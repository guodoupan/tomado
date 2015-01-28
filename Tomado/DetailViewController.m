//
//  DetailViewController.m
//  Tomado
//
//  Created by Doupan Guo on 1/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailTableViewCell.h"

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

- (void) loadOriginalImage;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self) {
        self.title = [self.movieDictionary objectForKey:@"title"];
    }
    
    // add header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    self.detailTable.tableHeaderView = headerView;
    
    NSString *proUrl = [[[self.movieDictionary objectForKey:@"posters"] objectForKey:@"original"]
                     stringByReplacingOccurrencesOfString:@"tmb" withString:@"pro"];
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:proUrl]];
    
    [self performSelector:@selector(loadOriginalImage) withObject:nil afterDelay:0.1];
    
    
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.backgroundColor = [UIColor clearColor];
    
    UINib *nib = [UINib nibWithNibName:@"DetailTableViewCell" bundle:nil];
    [self.detailTable registerNib:nib forCellReuseIdentifier:@"DetailTableViewCell"];
}


- (void)loadOriginalImage {
    NSString *originalUrl = [[[self.movieDictionary objectForKey:@"posters"] objectForKey:@"original"]
                    stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    [self.posterImageView setImageWithURL:[NSURL URLWithString:originalUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.detailTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
    
    NSString *title = [self.movieDictionary valueForKey:@"title"];
    NSString *year = [self.movieDictionary valueForKey:@"year"];
    NSString *synopsis = [self.movieDictionary valueForKey:@"synopsis"];
    NSString *mpaaRating = [self.movieDictionary valueForKey:@"mpaa_rating"];
    NSDictionary *rating = [self.movieDictionary objectForKey:@"ratings"];
    int audienceScore = [[rating objectForKey:@"audience_score"] intValue];
    int criticsScore = [[rating objectForKey:@"critics_score"] intValue];
    
    cell.descLabel.text = [NSString stringWithFormat:@"%@ (%@)\nCritics Score: %d, Audience Score: %d\n%@\n\n%@",
                           title, year, criticsScore, audienceScore, mpaaRating, synopsis];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
