//
//  SecondViewController.h
//  CPWhereIAmWithSqlite
//
//  Created by Student P_08 on 14/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPDatabaseManager.h"
#import "AppDelegate.h"

@interface SecondViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray *allTask;
    
    
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

