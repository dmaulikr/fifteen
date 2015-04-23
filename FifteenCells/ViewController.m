//
//  ViewController.m
//  FifteenCells
//
//  Created by Elisa Chuang on 4/17/15.
//  Copyright (c) 2015 Elisa Chuang. All rights reserved.
//


#import "ViewController.h"
#import "ImageViewWithName.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *gameBoard;

@property (weak, nonatomic) IBOutlet ImageViewWithName *space1;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space2;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space3;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space4;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space5;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space6;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space7;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space8;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space9;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space10;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space11;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space12;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space13;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space14;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space15;
@property (weak, nonatomic) IBOutlet ImageViewWithName *space16;

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *scrambleButton;
- (IBAction)scrambleButtonTapped:(id)sender;

@property (strong, nonatomic) NSArray *tileImages;
@property (strong, nonatomic) NSMutableArray *currentGameState;

@property (strong, nonatomic) NSArray *spaces;

@property (nonatomic) NSUInteger indexOfEmptySpace;
@property (strong, nonatomic) ImageViewWithName *selectedTile;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.spaces = @[self.space1, self.space2, self.space3, self.space4, self.space5, self.space6, self.space7, self.space8, self.space9, self.space10, self.space11, self.space12, self.space13, self.space14, self.space15, self.space16];
    
    [self setImageViewNames];
    
    [self setImageViewImages];
    
    [self setUpStartingGameState];
    
    [self setUpInitialViewConstraints];
    
    [self drawBoardConstraints];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set up game

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setImageViewNames {
    for (NSInteger i = 0; i < [self.spaces count]; i++) {
        
        ImageViewWithName *imageView = self.spaces[i];
        
        NSString *spaceName = [NSString stringWithFormat:@"space%li", i+1];
        
        imageView.name = spaceName;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveTile:)];
        
        [imageView addGestureRecognizer:tapGestureRecognizer];
    }
}

-(void)setImageViewImages {
    
    for (NSInteger i = 0; i < 16; i++) {
        
        ImageViewWithName *currentSpace = self.spaces[i];
        
        if (i != 15) {
            
            NSString *imageTitle = [NSString stringWithFormat:@"tile%li", i + 1];
            currentSpace.image = [UIImage imageNamed:imageTitle];
            
        }
    }
    
}

-(void)setUpStartingGameState {
    
    self.currentGameState = [[NSMutableArray alloc] init];
    
    NSMutableArray *spacesCopy = [self.spaces mutableCopy];
    
    
    while ([spacesCopy count] > 0) {
        
        NSInteger randomIndex = arc4random_uniform([spacesCopy count] - 1);
        
        ImageViewWithName *selectedImage = spacesCopy[randomIndex];
        
        [self.currentGameState addObject:selectedImage];
        
        if ([selectedImage.name isEqualToString:@"space16"]) {
            self.indexOfEmptySpace = [self.currentGameState indexOfObject:selectedImage];
        }
        
        [spacesCopy removeObject:selectedImage];
        
        
    }
    
//    for (ImageViewWithName *imageView in spacesCopy) {
//        [self.currentGameState addObject:imageView];
//        
//        if ([imageView.name isEqualToString:@"space16"]) {
//            self.indexOfEmptySpace = [self.currentGameState indexOfObject:imageView];
//        }
//    }
    
    
}

-(void)setUpScrambleButton {
    
    [self.scrambleButton setTitle:@"Scramble" forState:UIControlStateNormal];
    [self.scrambleButton setBackgroundColor:[UIColor clearColor]];
    [self.scrambleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self.scrambleButton layer] setBorderWidth:2.0f];
    [[self.scrambleButton layer]setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self.scrambleButton layer] setCornerRadius:10];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(1.0, 2.0, 1.0, 2.0);
    
    [self.scrambleButton setTitleEdgeInsets:edgeInsets];
    
    self.scrambleButton.titleLabel.font = [UIFont systemFontOfSize:25];
    
    
}


#pragma mark - constraints 
-(void)setUpInitialViewConstraints {
    
    [self.view removeConstraints:self.view.constraints];
    [self.background removeConstraints:self.background.constraints];
    
    [self makeBackgroundConstraints];
    
    self.background.image = [UIImage imageNamed:@"blueGlitter.jpg"];
    
    
    [self.scrambleButton removeConstraints:self.scrambleButton.constraints];
    self.scrambleButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setUpScrambleButton];
    [self makeScrambleButtonConstraints];
}

-(void)removeConstraints {
    
    
    [self.gameBoard removeConstraints:self.gameBoard.constraints];
    
    [self.space1 removeConstraints:self.space1.constraints];
    [self.space2 removeConstraints:self.space2.constraints];
    [self.space3 removeConstraints:self.space3.constraints];
    [self.space4 removeConstraints:self.space4.constraints];
    [self.space5 removeConstraints:self.space5.constraints];
    [self.space6 removeConstraints:self.space6.constraints];
    [self.space7 removeConstraints:self.space7.constraints];
    [self.space8 removeConstraints:self.space8.constraints];
    [self.space9 removeConstraints:self.space9.constraints];
    [self.space10 removeConstraints:self.space10.constraints];
    [self.space11 removeConstraints:self.space11.constraints];
    [self.space12 removeConstraints:self.space12.constraints];
    [self.space13 removeConstraints:self.space13.constraints];
    [self.space14 removeConstraints:self.space14.constraints];
    [self.space15 removeConstraints:self.space15.constraints];
    [self.space16 removeConstraints:self.space16.constraints];

}

-(void)setTranslateAutoresizingMaskToNo {
    
    
    self.gameBoard.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.space1.translatesAutoresizingMaskIntoConstraints = NO;
    self.space2.translatesAutoresizingMaskIntoConstraints = NO;
    self.space3.translatesAutoresizingMaskIntoConstraints = NO;
    self.space4.translatesAutoresizingMaskIntoConstraints = NO;
    self.space5.translatesAutoresizingMaskIntoConstraints = NO;
    self.space6.translatesAutoresizingMaskIntoConstraints = NO;
    self.space7.translatesAutoresizingMaskIntoConstraints = NO;
    self.space8.translatesAutoresizingMaskIntoConstraints = NO;
    self.space9.translatesAutoresizingMaskIntoConstraints = NO;
    self.space10.translatesAutoresizingMaskIntoConstraints = NO;
    self.space11.translatesAutoresizingMaskIntoConstraints = NO;
    self.space12.translatesAutoresizingMaskIntoConstraints = NO;
    self.space13.translatesAutoresizingMaskIntoConstraints = NO;
    self.space14.translatesAutoresizingMaskIntoConstraints = NO;
    self.space15.translatesAutoresizingMaskIntoConstraints = NO;
    self.space16.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)makeGameBoardConstraints {
    
    
    NSLayoutConstraint *gameBoardWidth = [NSLayoutConstraint constraintWithItem:self.gameBoard attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0];
    [self.view addConstraint:gameBoardWidth];
    
    NSLayoutConstraint *gameBoardHeight = [NSLayoutConstraint constraintWithItem:self.gameBoard attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.50 constant:0];
    [self.view addConstraint:gameBoardHeight];
    
    NSLayoutConstraint *gameBoardCenterX = [NSLayoutConstraint constraintWithItem:self.gameBoard attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view addConstraint:gameBoardCenterX];
    
    NSLayoutConstraint *gameBoardCenterY = [NSLayoutConstraint constraintWithItem:self.gameBoard attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraint:gameBoardCenterY];
    
    
}

-(void)makeScrambleButtonConstraints {
    
    NSLayoutConstraint *scrambleButtonCenterX = [NSLayoutConstraint constraintWithItem:self.scrambleButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:scrambleButtonCenterX];
    
    NSLayoutConstraint *scrambleButtonCenterY = [NSLayoutConstraint constraintWithItem:self.scrambleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.25 constant:0.0];
    [self.view addConstraint:scrambleButtonCenterY];
    
    
    NSLayoutConstraint *scrambleButtonWidth = [NSLayoutConstraint constraintWithItem:self.scrambleButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    [self.view addConstraint:scrambleButtonWidth];
    
    NSLayoutConstraint *scrambleButtonHeight = [NSLayoutConstraint constraintWithItem:self.scrambleButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.05 constant:0];
    [self.view addConstraint:scrambleButtonHeight];
    
    
    
}

-(void)makeBackgroundConstraints {
    
    NSLayoutConstraint *backgroundCenterX = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:backgroundCenterX];
    
    NSLayoutConstraint *backgroundCenterY = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.view addConstraint:backgroundCenterY];
    
    
    NSLayoutConstraint *backgroundWidth = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self.view addConstraint:backgroundWidth];
    
    NSLayoutConstraint *backgroundHeight = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.view addConstraint:backgroundHeight];
}

-(void)makeRowConstraintsWithViewDictionary:(NSDictionary *)viewDictionary {
    
    
    for (NSInteger i =0; i < 4; i++) {
        
        NSMutableString *vflString = [[NSMutableString alloc] initWithString:@"H:|"];
        
        NSString *firstImageViewInLineName = @"";
        
        for (NSInteger j = 0; j < 4; j++) {
            
            NSInteger currentIndex = (i * 4) + j;
            
            ImageViewWithName *currentImageView = self.currentGameState[currentIndex];
            
            if (j == 0) {
                
                [vflString appendFormat:@"[%@]", currentImageView.name];
                firstImageViewInLineName = currentImageView.name;
                
            } else {
            
                [vflString appendFormat:@"[%@(==%@)]", currentImageView.name, firstImageViewInLineName];
                
            }
        }
        
        [vflString appendString:@"|"];
        
        NSArray *row = [NSLayoutConstraint constraintsWithVisualFormat:vflString options:0 metrics:nil views:viewDictionary];
        [self.gameBoard addConstraints:row];
        
    }
    
}

-(void)makeColumnConstraintsWithViewDictionary:(NSDictionary *)viewDictionary {
    
    
    for (NSInteger i = 0; i < 4; i++) {
        
        NSMutableString *vflString = [[NSMutableString alloc] initWithString:@"V:|"];
        
        NSString *firstImageViewInLineName = @"";
        
        for (NSInteger j = 0; j < 4; j++) {
            
            NSInteger currentIndex = (j * 4) + i;
            
            ImageViewWithName *currentImageView = self.currentGameState[currentIndex];
            
            
            if (j == 0) {
                
                [vflString appendFormat:@"[%@]", currentImageView.name];
                firstImageViewInLineName = currentImageView.name;
                
            } else {
                
                [vflString appendFormat:@"[%@(==%@)]", currentImageView.name, firstImageViewInLineName];
                
            }
        }
        
        [vflString appendString:@"|"];
        
        
        NSArray *column = [NSLayoutConstraint constraintsWithVisualFormat:vflString options:0 metrics:nil views:viewDictionary];
        [self.gameBoard addConstraints:column];
    }
}



-(void)drawBoardConstraints {
    
    [self removeConstraints];
    
    [self setTranslateAutoresizingMaskToNo];
    
    NSDictionary *views = @{@"gameBoard" : self.gameBoard,
                            @"space1" : self.space1,
                            @"space2" : self.space2,
                            @"space3" : self.space3,
                            @"space4" : self.space4,
                            @"space5" : self.space5,
                            @"space6" : self.space6,
                            @"space7" : self.space7,
                            @"space8" : self.space8,
                            @"space9" : self.space9,
                            @"space10" : self.space10,
                            @"space11" : self.space11,
                            @"space12" : self.space12,
                            @"space13" : self.space13,
                            @"space14" : self.space14,
                            @"space15" : self.space15,
                            @"space16" : self.space16};
    
    
    
    [self makeGameBoardConstraints];
    [self makeRowConstraintsWithViewDictionary:views];
    [self makeColumnConstraintsWithViewDictionary:views];
    
    
}

#pragma mark - game play

-(void)moveTile:(UITapGestureRecognizer *)sender {
    
    self.selectedTile = (ImageViewWithName *)sender.view;
    
    if ([self isValidMove]) {
        
        [self updateCurrentGameStatus];
        
//        [self animateGamePiece];
        [self drawBoardConstraints];
        
        if ([self gameIsWon]) {
            NSLog(@"done");
        }
        
    }
    
    
}

-(void)updateCurrentGameStatus {
    
    NSInteger indexOfSelectedTile = [self.currentGameState indexOfObject:self.selectedTile];
    
    
    [self.currentGameState replaceObjectAtIndex:self.indexOfEmptySpace withObject:self.selectedTile];
    
    [self.currentGameState replaceObjectAtIndex:indexOfSelectedTile withObject:self.space16];
    
    self.indexOfEmptySpace = indexOfSelectedTile;
    
}

-(void)logCurrentGame {
    
    NSMutableString *gameboard = [[NSMutableString alloc]initWithString:@"\n"];
    
    for (NSInteger i = 0; i < 4; i++) {
        for (NSInteger j = 0; j < 4; j++) {
            NSInteger index = (i*4) + j;
            
            ImageViewWithName *now = self.currentGameState[index];
            
            if ([now.name isEqualToString:@"space16"]) {
                [gameboard appendString:@"__ | "];
            } else {
                [gameboard appendFormat:@"%@ | ", now.name];
            }
            
        }
        
        [gameboard appendString:@"\n"];
    }
    NSLog(@"%@", gameboard);
}

-(void)animateGamePiece {
    
//    NSArray *selectedTileConstraints = self.selectedTile.constraints;
//    
//    NSLog(@"selected tile constraints: %@", selectedTileConstraints);

    

    [UIView animateWithDuration:2.0 animations:^{
        NSLog(@"Animating");
        [self drawBoardConstraints];
    }];
//    
//    [UIView animateKeyframesWithDuration:2 delay:0 options:0 animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
//            [self drawBoardConstraints];
//        }];
//    } completion:^(BOOL finished) {
//        finished = YES;
//    }];
}


#pragma mark - game logic
-(BOOL)gameIsWon {
    
    if ([self.currentGameState isEqualToArray:self.spaces]) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Game Won"
                                              message:@"You've won!"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
       
        return YES;
    
    } else {
    
        return NO;
    
    }
}

-(BOOL)isValidMove {
    
    
    NSInteger indexBelowEmpty = self.indexOfEmptySpace + 4;
    NSInteger indexAboveEmpty = self.indexOfEmptySpace - 4;
    NSInteger indexLeftOfEmpty = self.indexOfEmptySpace - 1;
    NSInteger indexRightOfEmpty = self.indexOfEmptySpace + 1;
    
    NSInteger indexOfSelectedTile = [self.currentGameState indexOfObject:self.selectedTile];
    
    if (indexOfSelectedTile == indexAboveEmpty || indexOfSelectedTile == indexBelowEmpty || indexOfSelectedTile == indexLeftOfEmpty || indexOfSelectedTile == indexRightOfEmpty) {
        
        return YES;
    }
    
    return NO;
}

- (IBAction)scrambleButtonTapped:(id)sender {
    
    [self setUpStartingGameState];
    [self drawBoardConstraints];
}







@end
