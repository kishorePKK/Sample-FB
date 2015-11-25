//
//  FBBViewController.h
//  Sample FB
//
//  Created by TechRAQ on 5/28/15.
//  Copyright (c) 2015 TechRAQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBBViewController : UIViewController<FBLoginViewDelegate>
{
    FBLoginView *loginButton;
    NSMutableArray *albumIdArray;
}
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (nonatomic,strong)IBOutlet UIImageView *displayImg;
@end
