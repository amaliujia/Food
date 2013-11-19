//
//  M4MDishViewController.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MDishViewController.h"
#import "M4MCommentViewController.h"

@interface M4MDishViewController ()

@property (retain, nonatomic) NSDictionary *nutritionResult;
@property (retain, nonatomic) NSArray *detailsArray;
@property (retain, nonatomic) NSArray *dishCommentResult;
- (void)configureDishInfo;

@end

@implementation M4MDishViewController
@synthesize detailsArray = _detailsArray;
@synthesize nutritionResult = _nutritionResult;
@synthesize dishCommentResult = _dishCommentResult;
@synthesize dish = _dish;
@synthesize photoView = _photoView;
@synthesize nameLabel = _nameLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize segmentedControl = _segmentedControl;
@synthesize detailTableView = _detailTableView;
@synthesize commentTextField = _commentTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.dish);
    [self configureDishInfo];
	// Do any additional setup after loading the view.
    
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    
    
    [client requestDishNutritionWithDishId:[self.dish valueForKey:@"dishId"]];
//    [client requestDishCommentWithDishId:[self.dish valueForKey:@"dishId"]];
    
    

    
}

- (void)viewDidUnload
{
    [self setPhotoView:nil];
    [self setNameLabel:nil];
    [self setDescriptionLabel:nil];
    [self setNutritionResult:nil];
    [self setDetailsArray:nil];
    [self setDishCommentResult:nil];
    [self setSegmentedControl:nil];
    [self setDetailTableView:nil];
    [self setCommentTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    
    [client requestDishCommentWithDishId:[self.dish valueForKey:@"dishId"]];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)configureDishInfo
{
    [self.nameLabel setText:[self.dish valueForKey:@"dishName"]];
    [self.descriptionLabel setText:[self.dish valueForKey:@"dishDescription"]];
    [self.photoView setImageURL:[NSURL URLWithString:[self.dish valueForKey:@"image"]]];
}

- (void)dealloc {
    [_photoView release];
    [_nameLabel release];
    [_descriptionLabel release];
    [_nutritionResult release];
    [_detailsArray release];
    [_dishCommentResult release];
    [_segmentedControl release];
    [_detailTableView release];
    [_commentTextField release];
    [super dealloc];
}

#pragma mark - M4M client delegate

- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    if (requestType == M4MHttpRequestTypeGetDishNutrition) {
        self.nutritionResult = [result valueForKey:@"foodNutrientDetails"];
        self.detailsArray = [NSArray arrayWithObjects:[self.nutritionResult valueForKey:@"204"], [self.nutritionResult valueForKey:@"601"], [self.nutritionResult valueForKey:@"205"], [self.nutritionResult valueForKey:@"269"], [self.nutritionResult valueForKey:@"203"], [self.nutritionResult valueForKey:@"318"], [self.nutritionResult valueForKey:@"401"], [self.nutritionResult valueForKey:@"301"], nil];
        
//        [self.detailTableView reloadData];
        [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];

    } else if (requestType == M4MHttpRequestTypeGetDishComent) {
        self.dishCommentResult = [result valueForKey:@"comment_list"];

        
        [self.detailTableView reloadData];
//        [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.segmentedControl selectedSegmentIndex] == 0) {
        return [self.detailsArray count];
    } else {
        return [self.dishCommentResult count] + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.segmentedControl selectedSegmentIndex] == 0) {
        return 32;
    } else {
        if (indexPath.row == 0) {
            return 30;
        }
        return 60;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.segmentedControl selectedSegmentIndex] == 0)
    // selected nutrition
    {
        static NSString *CellIdentifier = @"nutritionCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSArray *currentNutrition = [self.detailsArray objectAtIndex:indexPath.row];  
        
        
        [cell.textLabel setText:[currentNutrition objectAtIndex:2]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f%@", [[currentNutrition objectAtIndex:0]doubleValue], [currentNutrition objectAtIndex:1]]];
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCommentCell"];
            //[cell.backgroundView setBackgroundColor:[UIColor lightGrayColor]];
            [cell setBackgroundColor:[UIColor lightGrayColor]];
            return cell;
        }
        static NSString *CellIdentifier = @"commentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSDictionary *currentComment = [self.dishCommentResult objectAtIndex:indexPath.row-1];  
        
        [cell.textLabel setText:[currentComment valueForKey:@"comments"]];
        [cell.detailTextLabel setText:[currentComment valueForKey:@"date"]];
        int numStar = [(NSString *)[currentComment valueForKey:@"rating"] intValue];
        for (int i = 0; i < numStar; i++) {
            UIImageView *star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"littleStar.png"]];
            [star setFrame:CGRectMake(290-i*20, 32, 16, 16)];
            [cell addSubview:star];
            [star release];
        }
        return cell;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
//    
//    M4MDishViewController *dishVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dishViewController"];
//    // ...
//    // Pass the selected object to the new view controller.
//    dishVC.dish= [[self.menuResult objectForKey:@"dishList"] objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:dishVC animated:YES];
    
}

- (IBAction)changeSegment:(id)sender {
    [self.detailTableView reloadData];
}

- (IBAction)didEndAddComment:(id)sender {
    [self resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNewComment"])    
    {
        [[segue destinationViewController] setDish_id:[self.dish valueForKey:@"dishId"]];
    }
}

- (void)orderBtnPress:(id)sender
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"dish is ordered" message:@"you can find your order in myOrder view" delegate:self cancelButtonTitle:@"not now" otherButtonTitles:@"OK", nil]autorelease];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }
    else
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *arr1 = [ud objectForKey:@"myOrder"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:arr1];
        
        if (arr == nil) {
            arr = [[NSMutableArray alloc]init];
        }
        [arr addObject:self.dish];
        [ud setValue:arr forKey:@"myOrder"];
//        NSLog(@"arr = %@", [arr description]);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


@end
