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
    
    var labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
    var values = [12.0, 22.0, 15.0, 9.0, 25.0, 23.0, 19.0, 0.0, -4.0, -5.0, -7.0, -12.0, 18.0, -20.0, -22.0]
    
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
        
        let temperatureChartFrame = CGRect(x: 2, y: 2, width: UIScreen.main.bounds.width - 8, height: temperatureCell.bounds.height - 12)
        let temperatureChart = LineChart(frame: temperatureChartFrame)
        temperatureChart.xAxisLabels = labels
        temperatureChart.values = values
        temperatureChart.maxVisibleItems = 5
        temperatureChart.zeroLineEnabled = true
        temperatureChart.gradientColors = [UIColor.red, UIColor(hex: "007AFF")]
        temperatureChart.configure()
        temperatureChart.prepareData()
        
        temperatureCell.contentView.addSubview(temperatureChart)
        
        // Humidity
        
        let humidityChartFrame = CGRect(x: 2, y: 2, width: UIScreen.main.bounds.width - 8, height: temperatureCell.bounds.height - 12)
        let humidityChart = LineChart(frame: humidityChartFrame)
        humidityChart.xAxisLabels = labels
        humidityChart.values = [30.0, 56.0, 70.0, 100.0, 100.0, 90.0, 80.0, 69.0, 40.0, 20.0, 50.0, 77.0, 93.0, 57.0, 62.0]
        humidityChart.maxVisibleItems = 5
        humidityChart.gradientColors = [UIColor(hex: "#19B5FE"), UIColor(hex: "#E4F1FE")]
        humidityChart.configure()
        humidityChart.prepareData()
        
        humidityCell.contentView.addSubview(humidityChart)
        
        // Rain
        
        let rainChartFrame = CGRect(x: 4, y: 2, width: UIScreen.main.bounds.width - 10, height: temperatureCell.bounds.height - 12)
        let rainChart = BarChart(frame: rainChartFrame)
        rainChart.xAxisLabels = labels
        rainChart.values = [809.0, 469.0, 209.0, 509.0, 609.0, 920.0, 950, 970, 100.0, 102, 104, 115, 124.0, 126.0, 130.0]
        rainChart.maxVisibleItems = 7
        rainChart.barColor = UIColor(hex: "#22A7F0")
        rainChart.limitLine = 500
        rainChart.minLeftAxis = 0
        rainChart.maxLeftAxis = 1000
        rainChart.configure()
        rainChart.prepareData()
        
        rainCell.contentView.addSubview(rainChart)

        // Heat index
        
        let heatIndexChartFrame = CGRect(x: 4, y: 2, width: UIScreen.main.bounds.width - 10, height: temperatureCell.bounds.height - 12)
        let heatIndexChart = BarChart(frame: heatIndexChartFrame)
        heatIndexChart.xAxisLabels = labels
        heatIndexChart.values = [80.0, 46.0, 20.0, 50.0, 60.0, 92, 95, 97, 100.0, 102, 104, 115, 124.0, 126.0, 130.0]
        heatIndexChart.maxVisibleItems = 7
        heatIndexChart.barColor = UIColor(hex: "#6BB9F0")
        heatIndexChart.barColorDependingOnValue = true
        heatIndexChart.configure()
        heatIndexChart.prepareData()
        
        heatIndexCell.contentView.addSubview(heatIndexChart)
    }

}
