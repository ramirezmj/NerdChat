//
//  ViewController.m
//  BaseProject
//
//  Created by Jose Manuel Ramírez Martínez on 29/11/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "HomeVC.h"
#import "NCHelper.h"
#import "NCFriends.h"
#import "NCUsersTVC.h"
#import "ChatRoomVC.h"

static NSString *const kNCUsersCellReuseIdentifier = @"kNCUsersCellReuseIdentifier";

@interface HomeVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *users;

@end

#pragma mark - Life cycle

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"NCUsersTVC" bundle:nil] forCellReuseIdentifier:kNCUsersCellReuseIdentifier];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    NCFriends *friendsFactory = [[NCFriends alloc] init];
    self.users = [friendsFactory friends];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NCUsersTVC *cell = [tableView dequeueReusableCellWithIdentifier:kNCUsersCellReuseIdentifier];
                    
    cell.avatar.image = [_users[indexPath.row] avatar];
    cell.name.text    = [_users[indexPath.row] name];
    cell.phone.text   = [_users[indexPath.row] phone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"homeToChatroomSegue" sender:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToChatroomSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ChatRoomVC *chatRoomVC = segue.destinationViewController;
        chatRoomVC.avatar      = [_users[indexPath.row] avatar];
        chatRoomVC.name        = [_users[indexPath.row] name];
        chatRoomVC.phone       = [_users[indexPath.row] phone];
        NSLog(@"This");
    }
}

@end
