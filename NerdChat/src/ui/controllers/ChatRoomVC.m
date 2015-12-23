//
//  ChatRoomVC.m
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "ChatRoomVC.h"
#import "NCChat.h"
#import "NCReplies.h"
#import "NCDefaultMessages.h"
#import "NCBubbles.h"
#import "NCHelper.h"

@interface ChatRoomVC ()

@property (weak, nonatomic) IBOutlet UITextField *sendMessageTF;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *navigationSubtitleLabel;

@property (strong, nonatomic) UIImagePickerController *pickerController;
@property (nonatomic, assign) BOOL isShowingKeyBoard;
@property (nonatomic, assign) BOOL areShowingAutoSuggestions;
@property (nonatomic, assign) CGFloat kbHeight;

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *yesterdayMessages;
@property (strong, nonatomic) NSMutableArray *todayMessages;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@end

@implementation ChatRoomVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupNavigationController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self goToLastMessage:NO];
}

- (void)setupNavigationController
{
    CGRect imageRect = CGRectMake(0, 0, 40, 40);
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:imageRect];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.layer.masksToBounds = YES;
    avatar.image = _avatar;
    
    UIBarButtonItem *avatarButton = [[UIBarButtonItem alloc] initWithCustomView:avatar];
    self.navigationItem.rightBarButtonItem = avatarButton;
    self.navigationTitleLabel.text = _name;
    self.navigationSubtitleLabel.text = _phone;
}

- (void)setupView
{
    NCDefaultMessages *messages = [[NCDefaultMessages alloc] init];
    self.yesterdayMessages = [[NSMutableArray alloc] init];
    self.todayMessages     = [[NSMutableArray alloc] init];
    self.messages = [[NSMutableArray alloc] initWithArray:[messages defaultMessages]];

    for (int i = 0; i < [_messages count]; i++) {
        NCChat *message = _messages[i];
        if (![[NSCalendar currentCalendar] isDateInToday:message.time]) {
            [self.yesterdayMessages addObject:message];
        } else {
            [self.todayMessages addObject:message];
        }
    }

    _isShowingKeyBoard = NO;
    
    self.timeFormatter = [[NSDateFormatter alloc]init];
    _timeFormatter.dateFormat = @"HH:mm";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];

    [self setupTableView];
    [self setupImagePicker];
}

- (void)setupTableView
{
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_chat"]]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiverTextTVC" bundle:nil] forCellReuseIdentifier:kReceiverTextReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiverImageTVC" bundle:nil] forCellReuseIdentifier:kReceiverImageReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SenderTextTVC" bundle:nil] forCellReuseIdentifier:kSenderTextReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SenderImageTVC" bundle:nil] forCellReuseIdentifier:kSenderImageReuseIdentifier];
    
}

- (void)setupImagePicker
{
    self.pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.allowsEditing = YES;
}

- (void)dealloc
{
    [self unregisterFromKeyboardNotifications];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultStr = [_sendMessageTF.text stringByReplacingCharactersInRange:range withString:string];
    if (resultStr.length == 0) {
        _sendMessageBtn.alpha = 0.8f;
        _sendMessageBtn.userInteractionEnabled = NO;
    } else {
        _sendMessageBtn.alpha = 1.0f;
        _sendMessageBtn.userInteractionEnabled = YES;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [_yesterdayMessages count];
            break;
        case 1:
            return [_todayMessages count];
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NCChat *message;
    if (indexPath.section == 0) {
        message = _yesterdayMessages[indexPath.row];
    } else {
        message = _todayMessages[indexPath.row];
    }
    
    CGFloat bubbleHeight;
    CGFloat cellHeight;
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    
    if (message.chatDataType == ChatData_Message){
        CGSize size  = [message.message sizeWithAttributes:@{NSFontAttributeName: font}];
        
        bubbleHeight = ((size.width/250) * size.height) + size.height;
        
        if (bubbleHeight < 34) {
            bubbleHeight = 34;
            cellHeight = bubbleHeight + 40;
        } else {
            cellHeight = bubbleHeight + 60;
        }
    }else {
        cellHeight = 130;
    }
    
    return cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont systemFontOfSize:12]];
    NSString *string;
    
    if (section == 0) {
        string = @"Older";

    } else {
        string = @"Today";
    }
    
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.85f]];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NCChat *message;
    if (indexPath.section == 0) {
        message = _yesterdayMessages[indexPath.row];
    } else {
        message = _todayMessages[indexPath.row];
    }
    
    switch (message.chatDataType) {
        case ChatData_Message:
        {
            if (message.isMine) {
                return [self tableView_MyMessage:tableView cellForRowAtIndexPath:indexPath];
            }else{
                return [self tableView_OtherMessage:tableView cellForRowAtIndexPath:indexPath];
            }
        }
            break;
        case ChatData_Image:
        {
            if (message.isMine) {
                return [self tableView_MyImage:tableView cellForRowAtIndexPath:indexPath];
            }
            else{
                return [self tableView_OtherImage:tableView cellForRowAtIndexPath:indexPath];
            }
        }
            break;
        case ChatData_None:
            NSLog(@"Error_ChatRoom:tableView--> chatData with ChatData_None value");
            return nil;
        default:
            break;
    }
    return nil;

}

#pragma mark - Private methods

- (UITableViewCell *)tableView_MyMessage:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiverTextTVC *cell = [tableView dequeueReusableCellWithIdentifier:kReceiverTextReuseIdentifier];
    NCChat *message;
    if (indexPath.section == 0) {
        message = _yesterdayMessages[indexPath.row];
    } else {
        message = _todayMessages[indexPath.row];
    }
    
    cell.message.text = message.message;
    cell.time.text    = [_timeFormatter stringFromDate: message.time];
    
    return cell;
}

- (UITableViewCell *)tableView_MyImage:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiverImageTVC *cell = [tableView dequeueReusableCellWithIdentifier:kReceiverImageReuseIdentifier];
    
    NCChat *message;
    if (indexPath.section == 0) {
        message = _yesterdayMessages[indexPath.row];
    } else {
        message = _todayMessages[indexPath.row];
    }
    
    cell.photoIV.image  = message.image;
    cell.time.text      = [_timeFormatter stringFromDate: message.time];
    
    return cell;
}

- (UITableViewCell *)tableView_OtherMessage:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SenderTextTVC *cell = [tableView dequeueReusableCellWithIdentifier:kSenderTextReuseIdentifier];
    
    NCChat *message;
    if (indexPath.section == 0) {
        message = _yesterdayMessages[indexPath.row];
    } else {
        message = _todayMessages[indexPath.row];
    }
    
    cell.message.text   = message.message;
    cell.time.text      = [_timeFormatter stringFromDate: message.time];
    
    return cell;
}

- (UITableViewCell *)tableView_OtherImage:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SenderImageTVC *cell = [tableView dequeueReusableCellWithIdentifier:kSenderImageReuseIdentifier];
    
    NCChat *message;
    if (indexPath.section == 0) {
        message = _yesterdayMessages[indexPath.row];
    } else {
        message = _todayMessages[indexPath.row];
    }
    
    cell.photoIV.image  = message.image;
    cell.time.text      = [_timeFormatter stringFromDate: message.time];
    
    return cell;
}

- (void)goToLastMessage:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint bottomOffset = CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height);
        [_tableView setContentOffset:bottomOffset animated:animated];
    });
}

- (void)createReceiverTextMessage
{
    NCChat *message       = [[NCChat alloc] init];
    message.message       = _sendMessageTF.text;
    message.time          = [NSDate date];
    message.isMine        = YES;
    message.chatDataType  = ChatData_Message;
    [_todayMessages addObject:message];
}

- (void)createSenderTextMessage
{
    NCChat *message       = [[NCChat alloc] init];
    message.message       = [NCHelper getRandomReply];
    message.time          = [NSDate date];
    message.isMine        = NO;
    message.chatDataType  = ChatData_Message;
    [_todayMessages addObject:message];
}

- (void)createReceiverImageMessage:(UIImage *)photo
{
    NCChat *message       = [[NCChat alloc] init];
    message.image         = photo;
    message.time          = [NSDate date];
    message.isMine        = YES;
    message.chatDataType  = ChatData_Image;
    [_todayMessages addObject:message];
}

- (void)createSenderImageMessage:(UIImage *)photo
{
    NCChat *message       = [[NCChat alloc] init];
    message.image         = photo;
    message.time          = [NSDate date];
    message.isMine        = NO;
    message.chatDataType  = ChatData_Image;
    [_todayMessages addObject:message];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

//    If you want to save the photo to the camera roll...
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
//    }
    [self createReceiverImageMessage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions
- (IBAction)didPressImagePicker:(UIButton *)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *options = @[@"Take Photo or Video", @"Photo/Video Library"];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:[options firstObject]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                           _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                                                                        [self presentViewController:_pickerController animated:YES completion:nil];
                                                       }
                                                   }];
    [actionSheet addAction:camera];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:[options lastObject]
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                                 _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                 [self presentViewController:_pickerController animated:YES completion:nil];
                                                         }];
    [actionSheet addAction:photoLibrary];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


- (IBAction)didPressSendButton:(UIButton *)sender
{
    if (_sendMessageTF.text.length > 0) {

        [self createReceiverTextMessage];
        [self createSenderTextMessage];
        _sendMessageTF.text = nil;
        
        [_tableView reloadData];
    }
    CGPoint bottomOffset = CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height);
    [_tableView setContentOffset:bottomOffset animated:YES];
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
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        _kbHeight = kbSize.height;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect frame = _toolBar.frame;
            frame.origin.y -= kbSize.height;
            _toolBar.frame = frame;
            
            frame = self.view.frame;
            frame.size.height -= kbSize.height;
            self.view.frame = frame;
        }];
        [self goToLastMessage:YES];
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
        CGFloat autoSuggestionsSize = 30;
        
        [UIView animateWithDuration:0.2f animations:^{
            CGRect frame;
            if (kbSize.height < _kbHeight) {
                // Hide suggestions
                frame =  _toolBar.frame;
                frame.origin.y -= autoSuggestionsSize;
                _toolBar.frame = frame;
                
                frame = self.view.frame;
                frame.size.height -= autoSuggestionsSize;
                self.view.frame = frame;
            } else {
                // Show suggestions
                frame =  _toolBar.frame;
                frame.origin.y += autoSuggestionsSize;
                _toolBar.frame = frame;
                
                frame = self.view.frame;
                frame.size.height += autoSuggestionsSize;
                self.view.frame = frame;
            }
        }];
    }
}

@end
