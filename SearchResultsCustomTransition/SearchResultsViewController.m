//
//  SearchResultsViewController.m
//  SearchResultsCustomTransition
//
//  Created by Peter Jensen on 9/6/15.
//  Copyright © 2015 Peter Jensen. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "DetailViewController.h"

#import "TransitionAnimator.h"

@interface SearchResultsViewController ()

@property (nonatomic, strong) NSArray *filteredObjects;

@end

@implementation SearchResultsViewController

@synthesize objects = _objects;
@synthesize filteredObjects = _filteredObjects;

#pragma mark - Initialization

#pragma mark - Getters and setters

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredObjects = self.objects;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scene management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)__unused sender
{
    if ([[segue identifier] isEqualToString:@"presentDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;

        UINavigationController *navigationController = [segue destinationViewController];
        NSMutableArray *items = [navigationController.navigationBar.items mutableCopy];
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Back"];
        [items insertObject:navigationItem atIndex:0];
        [navigationController.navigationBar setItems:[items copy]];

        navigationController.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)navigationController.delegate;
        navigationController.modalPresentationStyle = UIModalPresentationCustom;
    }
}

#pragma mark - <UITableviewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)__unused tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)__unused tableView numberOfRowsInSection:(NSInteger)__unused section
{
    return self.filteredObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *description = self.filteredObjects[indexPath.row];
    cell.textLabel.text = description;
    return cell;
}

- (BOOL)tableView:(UITableView *)__unused tableView canEditRowAtIndexPath:(NSIndexPath *)__unused indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - <UITableViewDelegate>

#pragma mark - <UISearchResultsUpdating>

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;

    if (searchString.length)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", searchString];
        self.filteredObjects = [self.objects filteredArrayUsingPredicate:predicate];
    }
    else
    {
        self.filteredObjects = self.objects;
    }
    [self.tableView reloadData];
}

#pragma mark - <UIStateRestoring>

#pragma mark - Notification handlers

#pragma mark - Actions

#pragma mark - Private methods

@end
