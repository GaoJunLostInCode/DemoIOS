//
//  GJExpendTableViewController.m
//  Demo
//
//  Created by 高 军 on 15/2/17.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJExpendTableViewController.h"
#import "GJExpendHeaderView.h"
#import "SettingsUtil.h"
#import "GJSectionInfo.h"
#import "GJCellInfo.h"
#import "GJExpendTableViewCell.h"


static const NSString *IDENTIFIER_CELL = @"CELL";
static const NSString *IDENTIFIER_HEADER = @"HEADER";

@interface GJExpendTableViewController ()<GJExpendHeaderViewDelegate>

@property NSMutableArray *objects;

@end


@implementation GJExpendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadTestDataFromPlist];
    [self.tableView registerNib:[UINib nibWithNibName:@"GJExpendTableViewCell" bundle:nil] forCellReuseIdentifier:IDENTIFIER_CELL];
    [self.tableView registerNib:[UINib nibWithNibName:@"GJExpendHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:IDENTIFIER_HEADER];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    GJSectionInfo *sectionInfo = [self.objects objectAtIndex:section];

    if (sectionInfo.isOpen)
    {
        return [sectionInfo cellCount];
    }else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GJExpendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_CELL forIndexPath:indexPath];

    GJSectionInfo *sectionInfo = [self.objects objectAtIndex:indexPath.section];
    GJCellInfo *cellInfo = [sectionInfo cellInfoAtIndex:indexPath.row];
    [cell showCellInfo:cellInfo];

    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GJExpendHeaderView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:IDENTIFIER_HEADER];
    header.delegate = self;
    
    GJSectionInfo *sectionInfo = [self.objects objectAtIndex:section];
    sectionInfo.section = section;
    [header showSectionInfo:sectionInfo];
    
    
    return header;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

/**
 *  实现 -(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath 函数后下面这两个函数的效果会被替代
 */
//- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        GJSectionInfo *sectionInfo = [self.objects objectAtIndex:indexPath.section];
//        [sectionInfo removeCellInfoAtIndex:indexPath.row];
//        
//        
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    
//}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:
                                    ^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
                                                GJSectionInfo *sectionInfo = [self.objects objectAtIndex:indexPath.section];
                                                [sectionInfo removeCellInfoAtIndex:indexPath.row];
                                              
                                                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                            }];
    
    UITableViewRowAction *cancelAttentionAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消关注" handler:
                                                   ^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                       NSLog(@"取消关注 %ld", indexPath.row);
                                                   }];
    
    
    return @[deleteAction, cancelAttentionAction];
}

#pragma mark GJExpendHeaderView delegate

- (void)expendHeaderClicked:(GJExpendHeaderView*)header sectionInfo:(GJSectionInfo*)sectionInfo isOpen:(BOOL)open
{
    NSMutableArray *rows = [[NSMutableArray alloc]init];
    for (NSInteger i=0, len=sectionInfo.cellCount; i<len; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionInfo.section];
        [rows addObject:indexPath];
    }
    
    if (open)
    {
        [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
    }else
    {
        [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadTestDataFromPlist
{
    self.objects = [[NSMutableArray alloc] init];
    
    NSDictionary *dicGroup = [SettingsUtil getDictionaryForName:@"dic_group" plistName:@"ExpendTableView"];
    NSArray *keys = [dicGroup allKeys];
    for (NSString *key in keys) {
        GJSectionInfo *sectionInfo = [[GJSectionInfo alloc] init];

        NSMutableArray *arrCells = [[NSMutableArray alloc] init];
        sectionInfo.arrCellInfo = arrCells;
        sectionInfo.sectionName = key;
        
        NSArray *arr = [dicGroup objectForKey:key];
        for (NSString *cellName in arr)
        {
            GJCellInfo *cellInfo = [[GJCellInfo alloc] init];
            cellInfo.title = cellName;
            
            [arrCells addObject:cellInfo];
        }
        
        [self.objects addObject:sectionInfo];
    }
}

@end
