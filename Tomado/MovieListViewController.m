//
//  MovieListViewController.m
//  Tomado
//
//  Created by Doupan Guo on 1/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *movieTable;
@property (strong, nonatomic) NSArray *dataArray;

- (void)loadData;

@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        self.title = @"Tomado";
    }
    self.movieTable.dataSource = self;
    self.movieTable.delegate = self;
    self.movieTable.rowHeight = 200;
    
    UINib *nib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.movieTable registerNib:nib forCellReuseIdentifier:@"MovieCell"];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"MovieCell";
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSDictionary *data = self.dataArray[indexPath.row];
    NSString *title = [data valueForKey:@"title"];
    NSDictionary *rating = [data objectForKey:@"ratings"];
    
    int score = [[rating objectForKey:@"audience_score"] intValue];
    cell.titleLabel.text = title;
    cell.ratingLabel.text = [NSString stringWithFormat:@"Score: %d", score];
    
    NSString *url = [[[data valueForKey:@"posters"] valueForKey:@"thumbnail"] stringByReplacingOccurrencesOfString:@"tmb" withString:@"pro"];
    [cell.posterImage setImageWithURL:[NSURL URLWithString:url]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.movieTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadData {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=h6spu2je87qup8xv88xumcnr"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.dataArray = [dictionary valueForKeyPath:@"movies"];
        [self.movieTable reloadData];
        NSLog(@"response: %@", dictionary);
    }];
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
