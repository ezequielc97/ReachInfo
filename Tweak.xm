#import "Tweak.h"
#import "widgets.h"

%group reachinfo
%hook SBReachabilityBackgroundView

- (void)_setupChevron {
    if (kChevron) {

    } else {
        %orig;
    }
}

%end

%hook SBReachabilityWindow

// TODO: charasar bo ama garna, widget y tr drwst bka
- (void)layoutSubviews {
    // layoutSubviews. i know. not a good method to hook. but it was also my only option, trust me its not that bad (in this case, since it wont get called as much/it's not always on screen) & i've done a lot of things to better the performance.

    [RIView removeFromSuperview]; // thanks @Muirey03
    RIView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    CGFloat height = [[%c(SBReachabilityManager) sharedInstance] effectiveReachabilityYOffset];
    RIView.frame = CGRectMake(self.frame.origin.x, -height + H, self.frame.size.width, height);
    //RIView.backgroundColor = [UIColor colorWithRed:15/255.0 green:25/255.0 blue:35/255.0 alpha:1];
    [self addSubview:RIView];
    [self bringSubviewToFront:RIView];


#pragma mark - Bash-Like
    if ([kTemplate isEqual:@"bash"]) {
        [bashLike show];
    }

#pragma mark - Clock
    if ([kTemplate isEqual:@"clock"]) {
        [Clock show];
    }
#pragma mark - The Two Astronauts
    if ([kTemplate isEqual:@"astronauts"]) {
        [Astro show];
    }
#pragma mark - The Two Astronauts
    if ([kTemplate isEqual:@"detailed"]) {
        [Detailed show];
    }
}

%end
%end

#pragma mark - ctor
static void prefsChanged() {
    prefs = [[HBPreferences alloc] initWithIdentifier:@"com.1di4r.reachinfoprefs"];

    kEnabled = [([prefs objectForKey:@"kEnabled"] ? : @(YES)) boolValue];
    kTemplate = [([prefs objectForKey:@"Template"] ? : @"bash") stringValue];
    kChevron = [([prefs objectForKey:@"kChevron"] ? : @(YES)) boolValue];
    H = [([prefs objectForKey:@"kHeight"] ? : @(0)) intValue];

}
%ctor {
    prefsChanged();
    if (kEnabled) {
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        %init(reachinfo);
    }
}
