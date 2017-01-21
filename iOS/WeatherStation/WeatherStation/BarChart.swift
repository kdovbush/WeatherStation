//
//  BarChart.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/14/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import Charts

class BarChart: UIView {

    // MARK: - Public properties
    
    var chartView: BarChartView!
    
    var xAxisLabels: [String] = []
    var values: [Double] = [] {
        didSet {
            prepareData()
            if oldValue.count > 0 {
                chartView.data?.notifyDataChanged()
            }
        }
    }
    
    var minLeftAxis: Double?
    var maxLeftAxis: Double?
    var limitLine: Double?
    
    var maxVisibleItems: Double = 5.0
    var barColor: UIColor = UIColor.black
    var barColorDependingOnValue: Bool = false
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        chartView = BarChartView(frame: frame)
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
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = true
        chartView.borderColor = UIColor.lightGray
        
        // User interactions
        chartView.pinchZoomEnabled = false
        chartView.dragEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)
        
        // Left Axis
        chartView.leftAxis.enabled = true
        chartView.leftAxis.drawGridLinesEnabled = true
        
        if let minLeftAxis = minLeftAxis, let maxLeftAxis = maxLeftAxis {
            chartView.leftAxis.axisMinimum = minLeftAxis
            chartView.leftAxis.axisMaximum = maxLeftAxis
        }
        
        // Right Axis
        chartView.rightAxis.enabled = false
        if let limitLine = limitLine {
            chartView.rightAxis.addLimitLine(ChartLimitLine(limit: limitLine, label: "Wet"))
        }
        
        // X Axis
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        
        if !xAxisLabels.isEmpty {
            let xAxisFormatter = XAxis()
            xAxisFormatter.valueFormatter = self
            chartView.xAxis.valueFormatter = xAxisFormatter.valueFormatter
        }
        
        chartView.animate(yAxisDuration: 2.0, easingOption: .linear)
        
        // Limit visible items and scoll to end
        chartView.setVisibleXRangeMaximum(maxVisibleItems)
    }
    
    func prepareData() {
        var dataEntries: [BarChartDataEntry] = []
        
        var index = 0.0
        for value in values {
            dataEntries.append(BarChartDataEntry(x: index, y: Double(value)))
            index += 1.0
        }

        let barChartDataSet = BarChartDataSet(values: dataEntries, label: "Temperature")
        barChartDataSet.colors = barColorDependingOnValue ? prepareColorsForValues() : [barColor]
        barChartDataSet.highlightEnabled = false
        
        chartView.data = BarChartData(dataSets: [barChartDataSet])
    }
    
    func prepareColorsForValues() -> [UIColor] {
        var colors: [UIColor] = []
        for value in values {
            switch value {
            case 0 ... 79:
                colors.append(UIColor(hex: "#2ecc71"))
            case 80...90:
                colors.append(UIColor(hex: "#FDD835"))
            case 91...103:
                colors.append(UIColor(hex: "#FF8F00"))
            case 104...124:
                colors.append(UIColor(hex: "#d35400"))
            case 125...140:
                colors.append(UIColor(hex: "#a20025"))
            default:
                break
            }
        }
        return colors
    }
    
}

extension BarChart: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xAxisLabels[Int(value)]
    }
    
}
