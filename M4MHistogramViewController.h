//
//  M4MHistogramViewController.h
//  meal4me
//
//  Created by again on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"

@interface M4MHistogramViewController : UIViewController<CPTBarPlotDataSource, CPTBarPlotDelegate>
{
    CPTGraphHostingView *barChartView;
    CPTXYGraph *barChartForTop;
    NSMutableArray *dataForPlot, *dataForChart;
    NSMutableArray *dataForGraph1, *dataForGraph2;
}

@property (nonatomic, retain) CPTGraphHostingView *barChartView;
@property (nonatomic, retain) CPTGraph *barChartForTop;
@property (nonatomic, retain) NSMutableArray *dataForPlot;
@property (nonatomic, retain) NSMutableArray *dataForChart;
@property (nonatomic, retain) NSMutableArray *dataForGraph1, *dataForGraph2;

-(void)constructTopBarChart;

@end
