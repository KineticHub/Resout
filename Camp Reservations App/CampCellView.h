//
//  CampCellView.h
//  Goshen Scout Reservation App
//
//  Created by Kinetic on 12/7/12.
//  Copyright (c) 2012 BSA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_CELL_TITLE_FONT [UIFont boldSystemFontOfSize:18.0] 
#define DEFAULT_CELL_DESCRIPTION_FONT [UIFont boldSystemFontOfSize:16.0] 

@interface CampCellView : UITableViewCell
@property (nonatomic, strong) UIImageView *customImageView;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isSelectable:(BOOL)isSelectableCell;
-(void)setCellImage:(NSURLRequest *)imageURL;
@end
