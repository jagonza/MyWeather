//
//  TimeMachineVC.swift
//  MyWeather
//
//  Created by Javier González Rojo on 16/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import UIKit

class TimeMachineVC: UIViewController {
    
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var currentDayLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailySummary: UILabel!
    
    var yearArray = [String]()
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        yearPicker.dataSource = self
        yearPicker.delegate = self
        hourlyForecastCollectionView.dataSource = self
        
        for year in (1900...2015).reverse() {
            yearArray.append("\(year)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.dateFromString("25/06/2015 18:00")!
        
        weather = Weather(latitude: "43.3957088", longitude: "-4.5369912", time: Int(date.timeIntervalSince1970))
        weather.downloadWeaher {
            self.updateUI()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUI() {
        
        currentWeatherImg.image = UIImage(named: weather.currentWeather.icon)
        currentTempLbl.text = weather.currentWeather.currentTemp
        currentDayLbl.text = Utils.getDateStringFromTimeInterval(weather.dailyWeatherArray[0].day , mask: "EEEE, dd 'de' MMMM 'de' yyyy")
        let dailyWeather = weather.dailyWeatherArray[0]
        minTempLbl.text = dailyWeather.minTemp
        maxTempLbl.text = dailyWeather.maxTemp
        sunriseLbl.text = dailyWeather.sunriseTime
        sunsetLbl.text = dailyWeather.sunsetTime
        dailySummary.text = weather.hourlySummary
        
        hourlyForecastCollectionView.reloadData()
    }

}


extension TimeMachineVC: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArray.count
    }
    
}

extension TimeMachineVC: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

     
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.dateFromString("25/06/\(yearArray[row]) 18:00")!
        
        weather = Weather(latitude: "43.3957088", longitude: "-4.5369912", time: Int(date.timeIntervalSince1970))
        weather.downloadWeaher {
            self.updateUI()
        }
    
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "AvenirNextCondensed-Regular", size: 50)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = yearArray[row]
        
        return pickerLabel!
        
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension TimeMachineVC : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if weather == nil {
            return 0
        } else {
            if collectionView == hourlyForecastCollectionView && weather.hourlyWeatherArray != nil{
                return weather.hourlyWeatherArray.count
            } else {
                return 0
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyForecastCollectionView {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HourlyForecastCVC", forIndexPath: indexPath) as? HourlyForeCastCVC {
                
                let hourlyWeather = weather.hourlyWeatherArray[indexPath.row]

                let hour = Utils.getDateStringFromTimeInterval(hourlyWeather.time, mask: "HH")

                if hour == "18" {
                    cell.backgroundColor = UIColor(red: 255/255, green: 248/255, blue: 218/255, alpha: 0.5)
                } else {
                    cell.backgroundColor = UIColor(red: 253/255, green: 227/255, blue: 255/255, alpha: 1.0)
                }
                
                cell.dayLbl.hidden = true
                cell.hourLbl.text = hour + "h"
                cell.iconImg.image = UIImage(named: "\(hourlyWeather.icon)")
                cell.precipProb.text = hourlyWeather.precipProb
                cell.tempLbl.text = hourlyWeather.temperature
                
                return cell
            }
        } 
        return UICollectionViewCell()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
}

