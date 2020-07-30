//
//  ViewController.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/15.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"

#import "NormalCollectionViewController.h"
#import "CardCollectionViewController.h"
#import "WaterViewController.h"
#import "ScrollNestViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.contentInset = UIEdgeInsetsZero;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"kMainTableViewCellID"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMainTableViewCellID" forIndexPath:indexPath];
    cell.titLabel.text = [self titLabelText:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            NormalCollectionViewController *normalVC = [[NormalCollectionViewController alloc]init];
            [self.navigationController pushViewController:normalVC animated:YES];
        }
            break;
        case 1:{
            CardCollectionViewController *cardVC = [[CardCollectionViewController alloc]init];
            [self.navigationController pushViewController:cardVC animated:YES];
        }
            break;
        case 2:{
            ScrollNestViewController *scrollVC = [[ScrollNestViewController alloc]init];
            [self.navigationController pushViewController:scrollVC animated:YES];
        }
            break;
        case 10:{
            WaterViewController *waterVC = [[WaterViewController alloc]init];
            [self.navigationController pushViewController:waterVC animated:YES];
        }
        default:
            break;
    }
}

- (NSString *)titLabelText:(NSInteger)row
{
    NSString *result = [NSString stringWithFormat:@"第 %ld 行",(long)row];
    switch (row) {
        case 0:
            result = @"正常控制器";
            break;
        case 1:
            result = @"整页控制器";
            break;
        case 2:
            result = @"嵌套Scroll控制器";
            break;
        case 10:
            result = @"瀑布流控制器";
            break;
        default:
            break;
    }
    return result;
}
@end
