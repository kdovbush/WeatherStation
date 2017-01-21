//
//  ChartsViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/11/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class ChartsViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var temperatureCell: UITableViewCell!
    @IBOutlet weak var humidityCell: UITableViewCell!
    @IBOutlet weak var rainCell: UITableViewCell!
    @IBOutlet weak var heatIndexCell: UITableViewCell!

    // MARK: - Public properties
    
    var station: Station?
    
    var labels: [String] {
        return station?.getDateStrings() ?? []
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        populateWithData()
    }
    
    // MARK: - Configuration methods
    
    func configureTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
    }
    
    func populateWithData() {
        
        // Temperature
        
        let temperatureChartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 7, height: temperatureCell.bounds.height - 12)
        let temperatureChart = LineChart(frame: temperatureChartFrame)
        if let temperatures = station?.temperatures, temperatures.isEmpty == false {
            temperatureChart.xAxisLabels = labels
            temperatureChart.values = station?.temperatures ?? []
            temperatureChart.maxVisibleItems = 6
            temperatureChart.zeroLineEnabled = true
            temperatureChart.gradientColors = [UIColor.red, UIColor(hex: "007AFF")]
            temperatureChart.configure()
            temperatureChart.prepareData()
        }
        temperatureCell.contentView.addSubview(temperatureChart)
        
        // Humidity
        
        let humidityChartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 8, height: temperatureCell.bounds.height - 12)
        let humidityChart = LineChart(frame: humidityChartFrame)
        if let humidities = station?.humidities, humidities.isEmpty == false {
            humidityChart.xAxisLabels = labels
            humidityChart.values = station?.humidities ?? []
            humidityChart.maxVisibleItems = 6
            humidityChart.gradientColors = [UIColor(hex: "#19B5FE"), UIColor(hex: "#E4F1FE")]
            humidityChart.configure()
            humidityChart.prepareData()
        }
        humidityCell.contentView.addSubview(humidityChart)
        
        // Rain
        
        let rainChartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: temperatureCell.bounds.height - 12)
        let rainChart = BarChart(frame: rainChartFrame)
        if let rainAnalogs = station?.rainAnalogs, rainAnalogs.isEmpty == false {
            rainChart.xAxisLabels = labels
            rainChart.values = station?.rainAnalogs ?? []
            rainChart.maxVisibleItems = 7
            rainChart.barColor = UIColor(hex: "#22A7F0")
            rainChart.limitLine = 500
            //rainChart.minLeftAxis = 0
            //rainChart.maxLeftAxis = 1000
            rainChart.configure()
            rainChart.prepareData()
        }
        rainCell.contentView.addSubview(rainChart)

        // Heat index
        
        let heatIndexChartFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: temperatureCell.bounds.height - 12)
        let heatIndexChart = BarChart(frame: heatIndexChartFrame)
        if let heatIndexes = station?.heatIndexes, heatIndexes.isEmpty == false {
            heatIndexChart.xAxisLabels = labels
            heatIndexChart.values = station?.heatIndexes ?? []
            heatIndexChart.maxVisibleItems = 7
            heatIndexChart.barColor = UIColor(hex: "#6BB9F0")
            heatIndexChart.barColorDependingOnValue = true
            heatIndexChart.configure()
            heatIndexChart.prepareData()
        }
        heatIndexCell.contentView.addSubview(heatIndexChart)
    }

}
