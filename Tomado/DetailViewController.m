//
//  DetailViewController.m
//  Tomado
//
//  Created by Doupan Guo on 1/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

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
    
    NSString *url = [[[self.movieDictionary objectForKey:@"posters"] objectForKey:@"original"]
                     stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    [self.posterImageView setImageWithURL:[NSURL URLWithString:url]];
    
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.backgroundColor = [UIColor clearColor];
    
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableCell"];
    }
    NSString *title = [self.movieDictionary valueForKey:@"title"];
    NSString *year = [self.movieDictionary valueForKey:@"year"];
    NSString *synopsis = [self.movieDictionary valueForKey:@"synopsis"];
    NSString *mpaaRating = [self.movieDictionary valueForKey:@"mpaa_rating"];
    NSDictionary *rating = [self.movieDictionary objectForKey:@"ratings"];
    int audienceScore = [[rating objectForKey:@"audience_score"] intValue];
    int criticsScore = [[rating objectForKey:@"critics_score"] intValue];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)\nCritics Score: %d, Audience Score: %d\n%@\n\n%@",
                           title, year, criticsScore, audienceScore, mpaaRating, synopsis];
    [cell.textLabel sizeToFit];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithWhite:(0) alpha:0.7];
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
