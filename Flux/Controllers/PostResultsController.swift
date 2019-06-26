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
    
    let legend = UITableView()
    
    init(_ post:Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    var content:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refresh)
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = self.view.safeAreaLayoutGuide.layoutFrame
        scrollView.addSubview(view)
        content = view
//        UIImageView.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).contentMode = .scaleAspectFit

        let control = UISegmentedControl(items: [#imageLiteral(resourceName: "pie").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), resizingMode: .stretch), #imageLiteral(resourceName: "line").withRenderingMode(.alwaysTemplate)])
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.tintColor = UIColor.appBlue
        view.addSubview(control)
        control.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        control.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        control.heightAnchor.constraint(equalToConstant: 50).isActive = true
        control.addTarget(self, action: #selector(switchGraph(_:)), for: .valueChanged)
        
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.isUserInteractionEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.enabled = false
        pieChart.animate(xAxisDuration: 0.3, yAxisDuration: 0.3, easingOption: .easeInOutSine)
        view.addSubview(pieChart)
        pieChart.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 12).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: control.centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pieChart.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.alpha = 0
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.enabled = false
        lineChart.legend.enabled = false
        lineChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 20)
        lineChart.leftAxis.labelTextColor = UIColor.appBlue
        lineChart.isUserInteractionEnabled = false
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.generatesDecimalNumbers = false
        lineChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        lineChart.leftAxis.granularityEnabled = true
        lineChart.leftAxis.granularity = 1
        view.addSubview(lineChart)
        lineChart.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 12).isActive = true
        lineChart.centerXAnchor.constraint(equalTo: control.centerXAnchor).isActive = true
        lineChart.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineChart.heightAnchor.constraint(equalToConstant: 250).isActive = true
        refreshCharts()
        
        
        
        legend.translatesAutoresizingMaskIntoConstraints = false
        legend.isScrollEnabled = false
        legend.delegate = self
        legend.dataSource = self
        legend.tableFooterView = UIView()
        view.addSubview(legend)
        legend.topAnchor.constraint(equalTo: pieChart.bottomAnchor).isActive = true
        legend.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        legend.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        legend.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        return post.choices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = post.choices![indexPath.row]
        cell.detailTextLabel?.text = "\(post.getAnswers()[indexPath.row]) vote\(post.getAnswers()[indexPath.row] == 1 ? "" : "s")"
        cell.textLabel?.textColor = UIColor.postColors[post.colors?[indexPath.row] ?? "b"]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.accessoryType = .disclosureIndicator
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
            pieChart.alpha = 1
            lineChart.alpha = 0
        }else{
            pieChart.alpha = 0
            lineChart.alpha = 1
        }
    }
    
    func refreshCharts(){
        refreshPieChart()
        refreshLineChart()
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
        for c in post.colors ?? [] {
            colors.append(UIColor.postColors[c] ?? UIColor.appGreen)
        }
        dataSet.colors = colors
        pieChart.data = PieChartData(dataSet: dataSet)
        pieChart.notifyDataSetChanged()
        
    }
    
    func refreshLineChart(){
        var dataEntries:[[ChartDataEntry]] = []
        let answers = post.answers ?? []
        let now = Date()
        let postTime = Date.fromStamp(post.timeStamp!)
        
        var timestamps:[Date] = []
        timestamps.append(postTime)
        for answer in answers {
            let answerDate = Date.fromStamp(answer.timestamp)
            timestamps.append(answerDate)
//            let difference = answerDate.timeIntervalSince1970 - postTime.timeIntervalSince1970
//            let xVal = difference / (now.timeIntervalSince1970 - postTime.timeIntervalSince1970)
//            print(xVal)
            
        }
        timestamps.append(now)
        var changedAnswers:[Date:[Int]] = [:]
        for time in timestamps {
//            print(post.getAnswers(time))
            changedAnswers[time] = post.getAnswers(time)
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
            set.colors = [UIColor.postColors[post.colors?[counter] ?? "b"] ?? UIColor.appBlue]
            set.lineWidth = 5
            set.circleRadius = 0
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
