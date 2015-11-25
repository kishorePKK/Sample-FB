//
//  FBBViewController.m
//  Sample FB
//
//  Created by TechRAQ on 5/28/15.
//  Copyright (c) 2015 TechRAQ. All rights reserved.
//

#import "FBBViewController.h"
#define IS_IPAD ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@interface FBBViewController ()

@end

@implementation FBBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fbCall];
    
   albumIdArray=[[NSMutableArray alloc]init];
}

#pragma mark - FBLoginView Delegate method implementation

-(void)fbCall
{
    /*
     //    FBLoginView *loginView = [[FBLoginView alloc] init];
     //    loginView.frame = CGRectOffset(loginView.frame, 380, 45);
     //    loginView.delegate = self;
     //    [self.view addSubview:loginView];
     //    [loginView sizeToFit];
     
     // loginButton.delegate = self;
     // loginButton.readPermissions = @[@"public_profile", @"email"];
     
     // loginButton =[[FBLoginView alloc] initWithPublishPermissions:[NSArray arrayWithObjects:@"email",@"user_friends",@"public_profile",nil] defaultAudience:FBSessionDefaultAudienceFriends];
     //    if ([[FBSession activeSession] isOpen])
     //    {
     //        [[FBSession activeSession] close];
     //    }
     //    if(!yourFBLoginView)
     //    {
     //        yourFBLoginView = [FBLoginView alloc] init...];
     //    }
     //[[FBSession activeSession] close];
     //    if (FBSessionStateOpen)
     //    {
     //        [loginButton removeFromSuperview];
     //        [[FBSession activeSession]close];
     //    }
     */
    
    loginButton =[[FBLoginView alloc]init];
    loginButton.readPermissions=@[@"public_profile", @"email",@"public_profile"];
    
  
    if (IS_IPHONE_5) {
        loginButton.frame = CGRectMake(36, 230, 246, 51);
    }else if(IS_IPAD){
        loginButton.frame = CGRectMake(118, 450, 557, 130);
    }else{
        loginButton.frame = CGRectMake(36, 230, 246, 51);
    }
    
    for (id obj in loginButton.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton1 =obj;
            
            if (IS_IPAD)
            {
                UIImage *loginImage = [UIImage imageNamed:@""];
                [loginButton1 setBackgroundImage:loginImage forState:UIControlStateNormal];
                [loginButton1 setBackgroundImage:nil forState:UIControlStateSelected];
                [loginButton1 setBackgroundImage:nil forState:UIControlStateHighlighted];
                // [loginBtn setImage:[UIImage imageNamed:@"connectfb_iPad.png"] forState:UIControlStateNormal];
                
            }
            else
            {
                UIImage *loginImage = [UIImage imageNamed:@"facebook_butn.png"];
                [loginButton1 setBackgroundImage:loginImage forState:UIControlStateNormal];
                [loginButton1 setBackgroundImage:nil forState:UIControlStateSelected];
                [loginButton1 setBackgroundImage:nil forState:UIControlStateHighlighted];
            }
            
            
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text =@"-"; //@"Log in to facebook";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame =CGRectMake(123,149, 280, 55);// CGRectMake(0, 0, 271, 37);
        }
    }
    
    loginButton.delegate = self;
    [self.view addSubview:loginButton];
    
}

-(void)toggleHiddenState:(BOOL)shouldHide
{
    //    self.lblUsername.hidden = shouldHide;
    //    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
    
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
    
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    
    NSLog(@"***********Name %@",user.name);
    NSLog(@"***********Name %@",[user objectForKey:@"email"]);
    NSLog(@"***********first_name %@",[user objectForKey:@"first_name"]);
    NSLog(@"***********id %@",[user objectForKey:@"id"]);

    
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    NSLog(@"*******fbAccessToken %@",fbAccessToken);
    
    
    
    NSLog(@"*******ProfilePic %@",[user objectForKey:@"public_profile"]);
   // self.profilePicture.profileID = user.id;
    
    //if(userName.length>0)
    //{
//    [[FBSession activeSession]close];
//    [FBSession.activeSession closeAndClearTokenInformation];
    
    
    FBRequest *request = [FBRequest requestForGraphPath:@"me/albums"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary <FBGraphUser> *my, NSError *error) {
        if ([my[@"data"]count]) {
            for (FBGraphObject *obj in my[@"data"]) {
                FBRequest *r = [FBRequest requestForGraphPath:[NSString stringWithFormat:@"/%@/photos", obj[@"id"]]];
                [r startWithCompletionHandler:^(FBRequestConnection *c, NSDictionary <FBGraphUser> *m, NSError *err) {
                    //here you will get pictures for each album
                    NSLog(@"*******r %@",obj[@"id"]);
                    [albumIdArray addObject:obj[@"id"]];
                    
                }];
            }
        }
        
    }];
    
    
    [self performSelector:@selector(Parse) withObject:nil afterDelay:4];
    
}

-(void)Parse
{
   // NSLog(@"***********albumIdArray %d:",albumIdArray.count);

    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSMutableArray *imgArray=[[NSMutableArray alloc]init];


    for (int i=0; i<albumIdArray.count; i++)
    {
        
        NSString *albumId=[albumIdArray objectAtIndex:i];
        
        NSString *  post =[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?access_token=CAAMlbvsEhB4BAFr9SY2hZBLzEOIVT2XrMeqMyssZACLOWomEjd9peVW3lcZBJmZCuT6goEOOioRKOBZCynn50pPrzZBafxKArIvlkHEDxTTUVeZAcL1LOYNl6lfOgGUeWbaOapM11wTuQme9o1lrkh4z7PQ6YRszWnXHFrzLVmuZBAHmtfmmOi7ZCOlcZAwVlZA6SovkWUr5uBh2SCuwLs4dhI6",albumId ];
        //NSLog(@"*****post%@",post);
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:post]];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data //1
                              
                              options:kNilOptions
                              error:&error];
        
        id value=[json valueForKey:@"data"];
        
       // NSLog(@"*****dataa%@",value);
        
        
        if ([value isKindOfClass:[NSArray class]]) {
            array=value;
        }
        else if([value isKindOfClass:[NSDictionary class]])
        {
            array = [NSMutableArray arrayWithObjects:value, nil];
        }
        
      //  NSLog(@"********array.count:%d",array.count);
        
        for (NSString *str  in array)
        {
            [imgArray addObject:[str valueForKey:@"picture"]];
        }
        
        NSLog(@"********imgArray.count:%d",imgArray.count);

    }
    
    NSString *imgStr;
    for (int i=0; i<imgArray.count; i++)
    {
        NSString *dateStr;
       // dateStr=[[imgArray objectAtIndex:i]valueForKey:@"updated_time"];
        imgStr=[imgArray objectAtIndex:i];
        NSLog(@"********dateStr%@",dateStr);
        NSLog(@"********imgStr%@",imgStr);
        
    }
    
    _displayImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]]];

}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    //self.lblLoginStatus.text = @"You are logged out";
    [self toggleHiddenState:YES];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


