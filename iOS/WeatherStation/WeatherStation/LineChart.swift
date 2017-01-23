//
//  LineChart.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/13/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import Charts

class LineChart: UIView {

    // MARK: - Public properties
    
    var chartView: LineChartView!
    
    var xAxisLabels: [String] = []
    var values: [Double] = [] {
        didSet {
            prepareData()
            if oldValue.count > 0 {
                chartView.data?.notifyDataChanged()
            }
        }
    }
    
    var maxVisibleItems: Double = 5.0
    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 1.0
    /// First item - top color, Second item - bottom color
    var gradientColors: [UIColor] = []
    var zeroLineEnabled: Bool = false
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        chartView = LineChartView(frame: frame)
        addSubview(chartView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        chartView.moveViewToX(Double(values.count))
    }
    
    // MARK: - Configuration methods
    
    func configure() {
        chartView.noDataText = "Data is not available now"
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        
        chartView.gridBackgroundColor = UIColor.white
        chartView.drawGridBackgroundEnabled = true
        chartView.drawBordersEnabled = true
        chartView.borderColor = UIColor.lightGray
        
        // User interactions
        chartView.pinchZoomEnabled = false
        chartView.dragEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)
        
        // Left Axis
        chartView.leftAxis.enabled = true
        chartView.leftAxis.drawZeroLineEnabled = zeroLineEnabled
        chartView.leftAxis.drawGridLinesEnabled = true
        
        // Right Axis
        chartView.rightAxis.enabled = false
        
        // X Axis
        chartView.xAxis.drawGridLinesEnabled = true
        chartView.xAxis.labelPosition = .bottom
        
        if !xAxisLabels.isEmpty {
            let xAxisFormatter = XAxis()
            xAxisFormatter.valueFormatter = self
            chartView.xAxis.valueFormatter = xAxisFormatter.valueFormatter
        }
        
        chartView.animate(yAxisDuration: 1.0, easingOption: .linear)
        
        // Limit visible items
        chartView.setVisibleXRangeMaximum(maxVisibleItems)
    }
    
    func prepareData() {
        var dataEntries: [ChartDataEntry] = []
        
        var index = 0.0
        for value in values {
            dataEntries.append(ChartDataEntry(x: index, y: Double(value)))
            index += 1.0
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Temperature")
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.cubicIntensity = 0
        lineChartDataSet.setColor(lineColor)
        lineChartDataSet.lineWidth = lineWidth
        lineChartDataSet.setCircleColor(lineColor)
        lineChartDataSet.circleRadius = 3.0
        lineChartDataSet.highlightEnabled = false
        
        
        // Gradient
        if gradientColors.count == 2 {
            let colorLocations = [1.0, 0.0] as [CGFloat]
            let colors = [gradientColors[0].cgColor, gradientColors[1].cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: colorLocations)
            
            lineChartDataSet.fillAlpha = 0.8
            lineChartDataSet.fill = Fill(linearGradient: gradient!, angle: 90.0)
            lineChartDataSet.drawFilledEnabled = true
        }
        
        chartView.data = LineChartData(dataSets: [lineChartDataSet])
    }

}

extension LineChart: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xAxisLabels[Int(value)]
    }
    
}





