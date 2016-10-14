//
//  CPDatabaseManager.m
//  CPWhereIAmWithSqlite
//
//  Created by Student P_08 on 14/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import "CPDatabaseManager.h"

@interface CPDatabaseManager ()

@end

@implementation CPDatabaseManager

+(instancetype)sharedManager {
    
    static CPDatabaseManager *sharedInstance;
    
    if (sharedInstance == nil) {
        sharedInstance = [[CPDatabaseManager alloc]init];
    }
    
    return sharedInstance;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString *)getDatabasePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SQLDatabase.sqlite"];
}


-(int)executeQuery:(NSString *)query {
    
    int success = 0;
    sqlite3_stmt *statement;
    const char *UTFquery = [query UTF8String];
    const char *UTFDatabasePath = [[self getDatabasePath] UTF8String];
    
    if (sqlite3_open(UTFDatabasePath, &myDB) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(myDB, UTFquery, -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                success = 1;
            }
        }
        
        sqlite3_close(myDB);
    }
    
    
    
    return success;
    
}

-(NSMutableArray *)getAllTask {
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    sqlite3_stmt *statement;
    
    NSString *query = @"SELECT TASK FROM TASK_TABLE";
    
    const char *UTFquery = [query UTF8String];
    const char *UTFDatabasePath = [[self getDatabasePath] UTF8String];
    
    if (sqlite3_open(UTFDatabasePath, &myDB) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(myDB, UTFquery, -1, &statement, nil) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                const char * taskString = (const char *)sqlite3_column_text(statement, 0);
                
                
                
                NSString *task = [NSString stringWithUTF8String:taskString];
                
                [mArray addObject:task];
                
                
                
            }
            
        }
        
        sqlite3_close(myDB);
    }
    
    return mArray;
    
}



@end
