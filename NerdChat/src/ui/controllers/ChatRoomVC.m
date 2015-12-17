//
//  ChatRoomVC.m
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "ChatRoomVC.h"

@interface ChatRoomVC ()

@property (weak, nonatomic) IBOutlet UITextField *sendMessageTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic, assign) BOOL isShowingKeyBoard;
@property (nonatomic, assign) CGFloat kbHeight;

@end

@implementation ChatRoomVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupNavigationController];
}

- (void)setupNavigationController
{
    CGRect rect = CGRectMake(0, 0, 40, 40);
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:rect];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.layer.masksToBounds = YES;
    avatar.image = _avatar;
    
    UIBarButtonItem *avatarButton = [[UIBarButtonItem alloc] initWithCustomView:avatar];
    self.navigationItem.rightBarButtonItem = avatarButton;
    self.navigationItem.title = _name;
}

- (void)setupView
{
    _isShowingKeyBoard = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];

    [self setupTableView];
}

- (void)setupTableView
{
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_chat"]]];
}

- (void)dealloc
{
    [self unregisterFromKeyboardNotifications];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];

    }
    return cell;
}

#pragma mark - Keyboard Management

- (void)dismissKeyboard
{
    [_sendMessageTF resignFirstResponder];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
}

- (void)unregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification
                                                  object:nil];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (!_isShowingKeyBoard) {
        
        _isShowingKeyBoard = YES;
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        _kbHeight = kbSize.height;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect frame = _toolBar.frame;
            frame.origin.y -= kbSize.height;
            _toolBar.frame = frame;
            
            frame = self.view.frame;
            frame.size.height -= kbSize.height;
            self.view.frame = frame;
            //        [self goToLastMessage];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (_isShowingKeyBoard) {
        
        _isShowingKeyBoard = NO;
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect frame = _toolBar.frame;
            frame.origin.y += kbSize.height;
            _toolBar.frame = frame;
            
            frame = self.view.frame;
            frame.size.height += kbSize.height;
            self.view.frame = frame;
        }];
    }
}

- (void)keyboardDidChangeFrame:(NSNotification*)aNotification
{
    if (_isShowingKeyBoard) {
        NSDictionary *info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

        [UIView animateWithDuration:0.2f animations:^{
        
            CGRect frame;
            if (kbSize.height <= _kbHeight) {
                frame =  _toolBar.frame;
                frame.origin.y -= 30;
                _toolBar.frame = frame;
                
                frame = self.view.frame;
                frame.size.height -= 30;
                self.view.frame = frame;
            } else {
                frame =  _toolBar.frame;
                frame.origin.y += 30;
                _toolBar.frame = frame;
                
                frame = self.view.frame;
                frame.size.height += 30;
                self.view.frame = frame;
            }
        }];
    }
}

@end
