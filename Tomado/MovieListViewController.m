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
#import "DetailViewController.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface MovieListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *movieTable;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UILabel *headerView;

- (void)loadData;
- (void)checkNetwork;

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.movieTable insertSubview:self.refreshControl atIndex:0];
    
    UINib *nib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.movieTable registerNib:nib forCellReuseIdentifier:@"MovieCell"];

    self.headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.headerView.text = @"Connection lost";
    self.headerView.textColor = [UIColor redColor];
    self.headerView.textAlignment = NSTextAlignmentCenter;
    self.headerView.backgroundColor = [UIColor grayColor];
    
    [self loadData];
    [self checkNetwork];
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
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.movieDictionary = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)loadData {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=h6spu2je87qup8xv88xumcnr"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.dataArray = [dictionary valueForKeyPath:@"movies"];
            [self.movieTable reloadData];
//        NSLog(@"response: %@", dictionary);
        }
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
    }];
    [SVProgressHUD show];
}

- (void)checkNetwork {
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusReachableViaWWAN:
             case AFNetworkReachabilityStatusReachableViaWiFi:
             {
                 NSLog(@"SO REACHABLE");
                 self.movieTable.tableHeaderView = nil;
                 [operationQueue setSuspended:NO]; // or do whatever you want
                 
                 break;
             }
                 
             case AFNetworkReachabilityStatusNotReachable:
             default:
             {
                 NSLog(@"SO UNREACHABLE");
                 [operationQueue setSuspended:YES];
                 self.movieTable.tableHeaderView = self.headerView;
                 //not reachable,inform user perhaps
                 break;
             }
         }
     }];
    [manager.reachabilityManager startMonitoring];
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
