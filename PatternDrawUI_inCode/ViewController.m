//
//  ViewController.m
//  PatternDrawUI_inCode
//
//  Created by Uber on 04/04/2018.
//  Copyright © 2018 uber. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"

#define offset 20.f

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@interface ViewController ()

@property (nonatomic, strong) UILabel* welcomeLbl;
@property (nonatomic, strong) UIView* rectView;

@end

@implementation ViewController

// ------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------
/* -------------- Philosophy of life viewController  ----------
 
 1. Remove everything from the screen. Set all properties to nil.
 2. Perform initialization of all properties. (Only init. Without set size or backgroundColor)
 3. Update their UI style (Set backgroundColors,cornerRadius ect...)
 4. Insert the content. (Text, pictures, properties..)
 5. Do recalculate the size of each UI subview.
 6. Add subviews to superView
 
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------

 The method named -someActionForPrepareVCbeforeUsing   performs all necessary actions in the correct order.
 Call it when you will have data for you subviews.
 
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 
 The order of calling methods:
 
  1. -Init or -initWithCoder
  2.  SettingOrCreating model for controller
  3.  -setModel:
  3.1 -viewDidLoad
  4.0 -someActionForPrepareVCbeforeUsing
      4.1  -setAllSubviewInNilandRemoveFromSuperView
      4.2  -initSubviewsByModel
      4.3  -updateUIByModel                 (*And also methods of setting values of the view itself)
      4.8  -putContentInSubviewsFromModel
      4.9  -resizeSubviewsByModel:          (*And also methods of setting values of the view itself)
      4.10 -addSubviewsOnSuperView
 
 5.  -viewDidLayoutSubviews
 6.  -viewDidAppear:

 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 
 
 The order the methods are called after changing orientation
 
 1. -viewWillTransitionToSize:withTransitionCoordinator:
 2. -viewDidLayoutSubviews
    2.1  (*And also methods of setting values of the view itself)
 3. -viewDidLayoutSubviews
 
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 
 Structure the location of the methods in the file

 
   1. A method that guides the sequence of calls to other methods for the life of the subviews
 
        #pragma mark - Life cycle of UI subviews
        - (void) someActionForPrepareVCbeforeUsing;

   2. Init    methods
      #pragma mark - Init methods

   3. Settter methods
      #pragma mark - Settter

   4. Life cycle of viewcontroller
      #pragma mark - Life cycle of viewcontroller

   5. Methods that are responsible for the life of subviews
      list:
         - (void) setAllSubviewInNilandRemoveFromSuperView
         - (void) initSubviewsByModel:(TestModel*) model
         - (void) resizeSubviewsByModel:(TestModel*) model
         - (void) addSubviewsOnSuperView
         - (void) updateUIByModel:(TestModel*) model
         - (void) putContentInSubviewsFromModel:(TestModel*) model
      #pragma mark - Private UI methods for work with subviews

   6. Many methods on the principle of.  One property is  - one method for its UI configuration.
      #pragma mark  - Setup (UI-settings) for subviews

   7. Methods that need to handle button presses
      #pragma mark - Action
 
   8. Coordinate calculation methods for subtitles
      #pragma mark - Calculate size for subviews
 
 
    9. Methods that return fine components ui for your property.
       For example, a method that returns a font, color, size, and so on.
       #pragma mark - Another UI Helpers (Create UIFonts/ ect...)
 
    10. Another your helpers
      #pragma mark - Helpers
 
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------
*/


#pragma mark - Life cycle of UI subviews

- (void) someActionForPrepareVCbeforeUsing{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (self.view){
        [self setAllSubviewInNilandRemoveFromSuperView];
        [self initSubviewsByModel:  _model];
        [self updateUIByModel:      _model];
        [self putContentInSubviewsFromModel:_model];
        [self resizeSubviewsByModel:_model];
        [self addSubviewsOnSuperView];
    }
}

#pragma mark - Init methods

- (instancetype)init {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (self = [super init]) {
        self.model = [TestModel mockup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    self = [super initWithCoder:coder];
    if (self) {
        self.model = [TestModel mockup];
    }
    return self;
}


#pragma mark - Settter

- (void) setModel:(TestModel *)model{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    _model = model;
    if (self.view){
        /*
        Every time we change the model. You need to start redrawing the screen.
        */
         [self someActionForPrepareVCbeforeUsing];
    }
}

#pragma mark - Life cycle of viewcontroller

- (void)viewDidLoad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidAppear:animated];
    
    if (self.model && self.view.subviews <= 0){
        [self someActionForPrepareVCbeforeUsing];
    }else if (!self.model){
        self.model = [TestModel mockup];
    }
}

- (void)viewDidLayoutSubviews {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    __weak ViewController* bself = self;

    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
     
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [bself resizeSubviewsByModel:self.model];
        } completion:nil];
        
    }];
}


#pragma mark - Private UI methods for work with subviews
/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ____    __    ____  ______   .______       __  ___     __    __   __          _______. __    __  .______   ____    ____  __   ___________    __    ____   _______.
 \   \  /  \  /   / /  __  \  |   _  \     |  |/  /    |  |  |  | |  |        /       ||  |  |  | |   _  \  \   \  /   / |  | |   ____\   \  /  \  /   /  /       |
  \   \/    \/   / |  |  |  | |  |_)  |    |  '  /     |  |  |  | |  |       |   (----`|  |  |  | |  |_)  |  \   \/   /  |  | |  |__   \   \/    \/   /  |   (----`
   \            /  |  |  |  | |      /     |    <      |  |  |  | |  |        \   \    |  |  |  | |   _  <    \      /   |  | |   __|   \            /    \   \
    \    /\    /   |  `--'  | |  |\  \----.|  .  \     |  `--'  | |  |    .----)   |   |  `--'  | |  |_)  |    \    /    |  | |  |____   \    /\    / .----)   |
     \__/  \__/     \______/  | _| `._____||__|\__\     \______/  |__|    |_______/     \______/  |______/      \__/     |__| |_______|   \__/  \__/  |_______/
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
/*
 1. - (void) setAllSubviewInNilandRemoveFromSuperView;          - Удаляем все subviews и устанавливаем их в nil
 2. - (void) initSubviewsByModel:(TestModel*)   model;          - Инитим  все subviews (Тут просто создаем. БЕЗ НАСТРОЕК!)
 3. - (void) updateUIByModel:(TestModel*)       model;          - Устанавливаем UIстили
 4. - (void) putContentInSubviewsFromModel:(TestModel*) model;  - Вставляем контент
 5. - (void) resizeSubviewsByModel:(TestModel*) model;          - Проходим по всем subviews и задаем им новые размеры
 6. - (void) addSubviewsOnSuperView;                            - Добавляем все subviews на self.view
 */

- (void) setAllSubviewInNilandRemoveFromSuperView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Here delete all properties.
    for (UIView* subview in self.view.subviews){
        [subview removeFromSuperview];
    }
    self.welcomeLbl = nil;
    self.rectView   = nil;
}

- (void) initSubviewsByModel:(TestModel*) model
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Here we initialize all properties
    if (self.view){
        self.welcomeLbl  = [UILabel new];
        self.rectView    = [UIView new];
    }
}

- (void) resizeSubviewsByModel:(TestModel*) model
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Here we start the mechanism of recalculation of the subview's sizes
    if (self.view){
        if (self.welcomeLbl) { self.welcomeLbl.frame   = [self cgrectFor_WelcomeLblwithModel:model withParentFrame:self.view.frame]; }
        if (self.rectView)   { self.rectView.frame     = [self cgrectFor_RectViewWithModel:model   withParentFrame:self.view.frame]; }
    }
}

- (void) addSubviewsOnSuperView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Here we add subviews to the screen
    if (self.view){
        if (self.welcomeLbl){  [self.view addSubview:self.welcomeLbl];}
        if (self.rectView)  {  [self.view addSubview:self.rectView];}
    }
}

- (void) updateUIByModel:(TestModel*) model{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Here set UI-style to subviews.
    if (self.welcomeLbl)  [self setupUI_WelcomeLbl:  self.welcomeLbl];
    if (self.rectView)    [self setupUI_RectView:    self.rectView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) putContentInSubviewsFromModel:(TestModel*) model{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Here insert content from model to ui properties
     self.welcomeLbl.text = self.model.textMainLbl;
}

#pragma mark  - Setup (UI-settings) for subviews

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      _______. _______ .___________. __    __  .______       __    __   __          .______   .______        ______   .______    _______ .______      .___________.____    ____
     /       ||   ____||           ||  |  |  | |   _  \     |  |  |  | |  |         |   _  \  |   _  \      /  __  \  |   _  \  |   ____||   _  \     |           |\   \  /   /
    |   (----`|  |__   `---|  |----`|  |  |  | |  |_)  |    |  |  |  | |  |  ______ |  |_)  | |  |_)  |    |  |  |  | |  |_)  | |  |__   |  |_)  |    `---|  |----` \   \/   /
     \   \    |   __|      |  |     |  |  |  | |   ___/     |  |  |  | |  | |______||   ___/  |      /     |  |  |  | |   ___/  |   __|  |      /         |  |       \_    _/
 .----)   |   |  |____     |  |     |  `--'  | |  |         |  `--'  | |  |         |  |      |  |\  \----.|  `--'  | |  |      |  |____ |  |\  \----.    |  |         |  |
 |_______/    |_______|    |__|      \______/  | _|          \______/  |__|         | _|      | _| `._____| \______/  | _|      |_______|| _| `._____|    |__|         |__|
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
/*
 1.- (void) setupUI_WelcomeLbl:(UILabel*) label  - Тут устанавливаем ui настройки по типу backgroundColor
 2.- (void) setupUI_RectView:(UIView*) rectView
 */

- (void) setupUI_WelcomeLbl:(UILabel*) label
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    UIFont * customFont = [ViewController font_WelcomeLbl];
    label.font = customFont;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor       = [UIColor blackColor];
    label.backgroundColor = [UIColor blueColor];
    label.textAlignment   = NSTextAlignmentCenter;
}

- (void) setupUI_RectView:(UIView*) rectView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    rectView.backgroundColor = [UIColor blueColor];
}


#pragma mark - Action
/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      ___        ______ .___________. __    ______   .__   __.
     /   \      /      ||           ||  |  /  __  \  |  \ |  |
    /  ^  \    |  ,----'`---|  |----`|  | |  |  |  | |   \|  |
   /  /_\  \   |  |         |  |     |  | |  |  |  | |  . `  |
  /  _____  \  |  `----.    |  |     |  | |  `--'  | |  |\   |
 /__/     \__\  \______|    |__|     |__|  \______/  |__| \__|
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
/*
 1. -(void) nextBtnClicked:(UIButton*)sender;   - After pressing the button "Next"
 2.
 */
-(void) nextBtnClicked:(UIButton*)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"nextBtnClicked");
}


#pragma mark - Calculate size for subviews

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   ______   ______    __    __  .__   __. .___________.        _______. __   ________   _______
  /      | /  __  \  |  |  |  | |  \ |  | |           |       /       ||  | |       /  |   ____|
 |  ,----'|  |  |  | |  |  |  | |   \|  | `---|  |----`      |   (----`|  | `---/  /   |  |__
 |  |     |  |  |  | |  |  |  | |  . `  |     |  |            \   \    |  |    /  /    |   __|
 |  `----.|  `--'  | |  `--'  | |  |\   |     |  |        .----)   |   |  |   /  /----.|  |____
  \______| \______/   \______/  |__| \__|     |__|        |_______/    |__|  /________||_______|
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
/*
 1. - (CGRect) cgrectFor_WelcomeLblwithModel:(TestModel*) model;   - "Hellow world!"  (UILabel)
 2. - (CGRect) cgrectFor_RectViewWithModel:(TestModel*) model;     - "Red rectangle"  (UIView)
 */

- (CGRect) cgrectFor_WelcomeLblwithModel:(TestModel*) model withParentFrame:(CGRect) frame{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)){
        frame = self.view.frame;
    }
    float x = offset;
    float y = offset;
    NSString* text  = (model.textMainLbl) ? model.textMainLbl : @"mockup text";
    float height    = 50.f;   // mockupValue
    float width     = 50.f;   // mockupValue
    
    UILabel* lblForCalulating = [UILabel new];
    [self setupUI_WelcomeLbl:lblForCalulating];
    lblForCalulating.text = text;

    CGSize neededSize =  CGSizeZero;
    
    // Another layout and design for another orientation
    UIInterfaceOrientation  orientation  = [[UIApplication sharedApplication] statusBarOrientation];
    if ((orientation == UIInterfaceOrientationPortrait) || (orientation ==UIInterfaceOrientationPortraitUpsideDown)) {
        width  = CGRectGetWidth(frame) - (offset * 2);
    }
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation ==UIInterfaceOrientationLandscapeRight)) {
        width  = CGRectGetWidth(frame)/2 - (offset * 2);
    }
    neededSize = [lblForCalulating sizeThatFits:CGSizeMake(width , CGFLOAT_MAX)];
    height = neededSize.height;
    return  CGRectMake(x, y, width, height);
}


- (CGRect) cgrectFor_RectViewWithModel:(TestModel*) model withParentFrame:(CGRect) frame{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    float height = 0;
    float width = 0;
    float x = 0;
    float y = 0;
    
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)){
        frame = self.view.frame;
    }
    // Another layout and design for another orientation
    UIInterfaceOrientation  orientation  = [[UIApplication sharedApplication] statusBarOrientation];
    if ((orientation == UIInterfaceOrientationPortrait) || (orientation ==UIInterfaceOrientationPortraitUpsideDown)) {

        width  = CGRectGetWidth(frame) - (offset * 2);
        height = CGRectGetHeight(frame)- ((CGRectGetMaxY(self.welcomeLbl.frame)+offset) + (offset));
        y = CGRectGetMaxY(self.welcomeLbl.frame)+offset;
        x = offset;
    }
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation ==UIInterfaceOrientationLandscapeRight)) {
        
        y = offset;
        x = CGRectGetMaxX(self.welcomeLbl.frame)+offset;
        width  = CGRectGetWidth(frame)-x-offset;
        height = CGRectGetHeight(frame)-(offset*2);
    }

    return  CGRectMake(x, y, width, height);
}


#pragma mark - Another UI Helpers (Create UIFonts/ ect...)


+(UIFont*) font_WelcomeLbl{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    float size = (IDIOM == IPAD) ? 30.f  : 20.f;
    return [UIFont fontWithName:@"Arial" size:size];
}

#pragma mark - Helpers

- (UIColor *)colorFromHexString:(NSString *)hexString {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
