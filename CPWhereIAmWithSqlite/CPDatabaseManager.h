//
//  CPDatabaseManager.h
//  CPWhereIAmWithSqlite
//
//  Created by Student P_08 on 14/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface CPDatabaseManager : UIViewController
{
    sqlite3 *myDB;
}
+(instancetype) sharedManager;
-(NSString *)getDatabasePath;

-(int)executeQuery:(NSString *)query;

-(NSMutableArray *)getAllTask;


@end
