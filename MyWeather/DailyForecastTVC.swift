//
//  DailyForecastTVC.swift
//  MyWeather
//
//  Created by Javier González Rojo on 10/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import UIKit

class DailyForecastTVC: UITableViewCell {
    
    @IBOutlet weak var dayOfWeekLbl: UILabel!
    @IBOutlet weak var dayOfMonthLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var maxTemLbl: UILabel!
    @IBOutlet weak var alertImg: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
