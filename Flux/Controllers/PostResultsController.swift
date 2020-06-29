//
//  PostResultsController.swift
//  Flux
//
//  Created by Johnny Waity on 5/15/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import Charts

class PostResultsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let post:Post
    
    let pieChart = PieChartView()
    let lineChart = LineChartView()
    let ratingChart = RatingResultView(lowered: false)
    
    let legend = UITableView()
    var legendHeight:NSLayoutConstraint? = nil
    
    init(_ post:Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = true
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refresh)
        

        let control = UISegmentedControl(items: [#imageLiteral(resourceName: "pie").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), resizingMode: .stretch), #imageLiteral(resourceName: "line").withRenderingMode(.alwaysTemplate)])
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.tintColor = UIColor.appBlue
        scrollView.addSubview(control)
        control.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        control.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        control.heightAnchor.constraint(equalToConstant: 50).isActive = true
        control.addTarget(self, action: #selector(switchGraph(_:)), for: .valueChanged)
        
        pieChart.isHidden = true
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.isUserInteractionEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.enabled = false
        pieChart.animate(xAxisDuration: 0.3, yAxisDuration: 0.3, easingOption: .easeInOutSine)
        scrollView.addSubview(pieChart)
        pieChart.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 12).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: control.centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        lineChart.isHidden = true
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.enabled = false
        lineChart.legend.enabled = false
        lineChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 20)
        lineChart.leftAxis.labelTextColor = UIColor.black
        lineChart.isUserInteractionEnabled = false
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.generatesDecimalNumbers = false
        lineChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        lineChart.leftAxis.granularityEnabled = true
        lineChart.leftAxis.granularity = 1
        scrollView.addSubview(lineChart)
        lineChart.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 12).isActive = true
        lineChart.centerXAnchor.constraint(equalTo: control.centerXAnchor).isActive = true
        lineChart.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineChart.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        ratingChart.isHidden = true
        scrollView.addSubview(ratingChart)
        ratingChart.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 12).isActive = true
        ratingChart.centerXAnchor.constraint(equalTo: control.centerXAnchor).isActive = true
        ratingChart.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        ratingChart.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        if post.postType == .Rating {
            ratingChart.isHidden = false
        }else{
            pieChart.isHidden = false
        }
        
        refreshCharts()
        
        
        
        legend.translatesAutoresizingMaskIntoConstraints = false
        legend.isScrollEnabled = false
        legend.delegate = self
        legend.dataSource = self
        legend.tableFooterView = UIView()
        scrollView.addSubview(legend)
        legend.topAnchor.constraint(equalTo: pieChart.bottomAnchor).isActive = true
        legend.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        legend.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        legend.heightAnchor.constraint(equalToConstant: post.postType == .Rating ? CGFloat(44 * 12) : CGFloat((post.choices?.count ?? 0) * 44)).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: legend.bottomAnchor).isActive = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func refresh(_ refresh:UIRefreshControl){
        post.invalidate()
        post.fetch {
            self.refreshCharts()
            self.legend.reloadData()
            refresh.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if post.postType == .Rating {
            return 11
        }else{
            return post.choices?.count ?? 0
        }
    }
    
    let clrs = [UIColor.appBlue, UIColor.appGreen, UIColor.red, UIColor.purple]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        if post.postType == .Rating {
            cell.textLabel?.text = "\(indexPath.row)/10"
            cell.textLabel?.textColor = UIColor.black
        }else{
            cell.textLabel?.text = post.choices![indexPath.row]
            cell.textLabel?.textColor = clrs[indexPath.row]
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = "\(post.getAnswers()[indexPath.row]) vote\(post.getAnswers()[indexPath.row] == 1 ? "" : "s")"
        if post.getAnswers()[indexPath.row] == 0 {
            cell.accessoryView?.alpha = 0
            cell.accessoryView = UIView()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if post.getAnswers()[indexPath.row] > 0 {
            let userList = UserListController()
            userList.setUsers(post.getUsers(indexPath.row))
            navigationController?.pushViewController(userList, animated: true)
        }
        
    }
    
    @objc
    func switchGraph(_ control:UISegmentedControl){
        if control.selectedSegmentIndex == 0 {
            lineChart.isHidden = true
            if post.postType == .Rating {
                ratingChart.isHidden = false
            }else{
                pieChart.isHidden = false
            }
        }else{
            pieChart.isHidden = true
            ratingChart.isHidden = true
            lineChart.isHidden = false
        }
    }
    
    func refreshCharts(){
        if post.postType == .Rating {
            refreshRatingChart()
        }else{
            refreshPieChart()
        }
        refreshLineChart()
    }
    
    func refreshRatingChart(){
        let avg = post.getRatingAverage()
        ratingChart.updateValue(avg: avg)
    }
    
    func refreshPieChart(){
        var dataEntries:[PieChartDataEntry] = []
        let results = post.getAnswers()
        var counter = 0
        for result in results {
            let dataEntry1 = PieChartDataEntry(value: Double(result), label: post.choices?[counter] ?? "")
            dataEntries.append(dataEntry1)
            counter += 1
        }
        
        let dataSet = PieChartDataSet(values: dataEntries, label: nil)
        dataSet.valueFont = UIFont.boldSystemFont(ofSize: 18)
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        noZeroFormatter.numberStyle = .percent
        noZeroFormatter.maximumFractionDigits = 1
        noZeroFormatter.multiplier = 1
        dataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        var colors:[NSUIColor] = []
        for i in 0..<(post.choices?.count ?? 0) {
            switch i {
            case 0:
                colors.append(UIColor.appBlue)
                break
            case 1:
                colors.append(UIColor.appGreen)
                break
            case 2:
                colors.append(UIColor.red)
                break
            default:
                colors.append(UIColor.purple)
            }
        }
        dataSet.colors = colors
        pieChart.data = PieChartData(dataSet: dataSet)
        pieChart.notifyDataSetChanged()
        
    }
    
    func refreshLineChart(){
        var dataEntries:[[ChartDataEntry]] = []
        let answers = post.answers ?? []
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM-dd-yyyy:HH-mm-ss"
        let nowString = dateFormatter.string(from: Date())
        let now = Date.UTCDate(date: nowString)
        let postTime = Date.UTCDate(date: post.timeStamp!)
        
        var timestamps:[Date] = []
        timestamps.append(postTime)
        for answer in answers {
            let answerDate = Date.UTCDate(date: answer.timestamp)
            timestamps.append(answerDate)
        }
        timestamps.append(now)
        var changedAnswers:[Date:[Int]] = [:]
        for time in timestamps {
            if post.postType == .Rating {
                changedAnswers[time] = [Int(roundf(post.getRatingAverage(time)))]
            }else{
                changedAnswers[time] = post.getAnswers(time)
            }
        }
        
        for _ in 0..<(changedAnswers[now]?.count ?? 0) {
            dataEntries.append([])
        }
        var c = 0
        for date in timestamps {
//            let difference = date.timeIntervalSince1970 - postTime.timeIntervalSince1970
//            let xVal = difference / (now.timeIntervalSince1970 - postTime.timeIntervalSince1970)
            let answers = changedAnswers[date]
            var counte = 0
            for a in answers ?? [] {
                let entry = ChartDataEntry(x: Double(c) * (1.0 / Double((timestamps.count - 1))), y: Double(a), data: "hi" as AnyObject)
                
                dataEntries[counte].append(entry)
                counte += 1
            }
            c += 1
        }
        var sets:[LineChartDataSet] = []
        var counter = 0
        for entries in dataEntries {
            let set = LineChartDataSet(values: entries, label: post.choices?[counter] ?? "Option")
            set.valueTextColor = UIColor.clear
            var color = UIColor.appBlue
            if counter == 0 {
                color = UIColor.appBlue
            }else if counter == 1 {
                color = UIColor.appGreen
            }else if counter == 2 {
                color = UIColor.red
            }else if counter == 3 {
                color = UIColor.purple
            }
            set.colors = [color]
            set.lineWidth = 5
            set.circleRadius = 2.5
            set.circleColors = [color]
            sets.append(set)
            counter += 1
        }
        lineChart.data = LineChartData(dataSets: sets)
        lineChart.notifyDataSetChanged()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
