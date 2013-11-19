//
//  M4MHistogramViewController.m
//  meal4me
//
//  Created by again on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "M4MHistogramViewController.h"

@interface M4MHistogramViewController ()

@end

@implementation M4MHistogramViewController
@synthesize barChartView,barChartForTop;
@synthesize dataForPlot,dataForChart,dataForGraph1,dataForGraph2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = @"test";
        self.barChartView = [[[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)] autorelease];
        self.barChartView.layer.masksToBounds = YES;
        self.barChartView.layer.cornerRadius = 20;
        
//        self.dataForGraph1 = [[NSMutableArray alloc] init];
//        self.dataForPlot = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self constructTopBarChart];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)constructTopBarChart
{
	// Create barChart from theme
	barChartForTop = [[[CPTXYGraph alloc] initWithFrame:CGRectZero] autorelease];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
	[barChartForTop applyTheme:theme];
	barChartView.hostedGraph			 = barChartForTop;
	barChartForTop.plotAreaFrame.masksToBorder = NO;
    barChartForTop.plotAreaFrame.cornerRadius = 0.0f;
    barChartForTop.plotAreaFrame.borderLineStyle = nil;
    [self.view addSubview:barChartView];
    
	barChartForTop.paddingLeft   = 70.0;
	barChartForTop.paddingTop	   = 20.0;
	barChartForTop.paddingRight  = 20.0;
	barChartForTop.paddingBottom = 80.0;
    
    //configure the chart title
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 25.0;
    
    barChartForTop.title = [[NSString stringWithFormat:@"店铺排名前10位"]retain];
    barChartForTop.titleTextStyle = textStyle;
    barChartForTop.titleDisplacement = CGPointMake(0.0, -20.0);
    barChartForTop.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    
	// Add plot space for horizontal bar charts
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartForTop.defaultPlotSpace;
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(300.0f)];
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(11.0f)];
    
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChartForTop.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	x.axisLineStyle				  = nil;
	x.majorTickLineStyle		  = nil;
	x.minorTickLineStyle		  = nil;
	x.majorIntervalLength		  = CPTDecimalFromString(@"5");
	x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	x.title						  = @"店铺名称";
	x.titleLocation				  = CPTDecimalFromFloat(7.5f);
	x.titleOffset				  = 55.0f;
    
    CPTMutableTextStyle *AxisTitiletextStyle = [CPTMutableTextStyle textStyle];
    AxisTitiletextStyle.color = [CPTColor blackColor];
    AxisTitiletextStyle.fontSize = 20;
    AxisTitiletextStyle.fontName = @"Helvetica-Bold";
    
	// Define some custom labels for the data elements
	x.labelRotation	 = M_PI / 4;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], [NSDecimalNumber numberWithInt:4], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:6], [NSDecimalNumber numberWithInt:7], [NSDecimalNumber numberWithInt:8], [NSDecimalNumber numberWithInt:9], [NSDecimalNumber numberWithInt:10], nil];
	NSArray *xAxisLabels		 = [NSArray arrayWithObjects:@"店铺1", @"店铺2", @"店铺3", @"店铺4", @"店铺5",@"店铺6", @"店铺7", @"店铺8", @"店铺9", @"店铺10", nil];
	NSUInteger labelLocation	 = 0;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
	for ( NSNumber *tickLocation in customTickLocations ) {
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
		newLabel.tickLocation = [tickLocation decimalValue];
		newLabel.offset		  = x.labelOffset + x.majorTickLength;
		newLabel.rotation	  = M_PI / 4;
		[customLabels addObject:newLabel];
		[newLabel release];
	}
    
	x.axisLabels = [NSSet setWithArray:customLabels];
    x.titleTextStyle = AxisTitiletextStyle;
    
	CPTXYAxis *y = axisSet.yAxis;
	y.axisLineStyle				  = nil;
	y.majorTickLineStyle		  = nil;
	y.minorTickLineStyle		  = nil;
	y.majorIntervalLength		  = CPTDecimalFromString(@"50");
	y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	y.title						  = @"销售额";
	y.titleOffset				  = 35.0f;
	y.titleLocation				  = CPTDecimalFromFloat(270.0f);
    y.titleRotation = M_PI * 2;
    y.titleTextStyle = AxisTitiletextStyle;
    
	// First bar plot
	CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor darkGrayColor] horizontalBars:NO];
	barPlot.baseValue  = CPTDecimalFromString(@"1");
	barPlot.dataSource = self;
	barPlot.barOffset  = CPTDecimalFromFloat(0.4f);
	barPlot.identifier = @"Bar Plot 1";
    barPlot.barWidth = [[NSDecimalNumber numberWithFloat:0.8] decimalValue];
	[barChartForTop addPlot:barPlot toPlotSpace:plotSpace];
}

#pragma mark CPTBarPlot delegate method

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
	NSLog(@"barWasSelectedAtRecordIndex %d", index);
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return 11;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSDecimalNumber *num = nil;
    
	switch ( fieldEnum ) {
        case CPTBarPlotFieldBarLocation:
            if ( index == 0 ) {
                num = [NSDecimalNumber notANumber];
            }
            else {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
            }
            break;
            
        case CPTBarPlotFieldBarTip:
            if ( index == 0 ) {
                num = [NSDecimalNumber notANumber];
            }
            else 
            {
                if ([plot.identifier isEqual:@"Bar Plot 2"])
                {
                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:70- index * 5];
//                    [dataForGraph2 addObject:[NSNumber numberWithInt:(50 -index * 6)] ];
                }
                else
                {
                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:200];
//                [dataForGraph1 addObject:[NSNumber numberWithInt:(50 -index * 6)]];
                }
            }
            break;
    }
    
    
	return num;
}



@end
