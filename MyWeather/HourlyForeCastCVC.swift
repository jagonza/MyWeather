//
//  HourlyForeCastCVC.swift
//  MyWeather
//
//  Created by Javier González Rojo on 10/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import UIKit

class HourlyForeCastCVC: UICollectionViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var precipProb: UILabel!
    
    override func awakeFromNib() {
        
        dayLbl.numberOfLines = 0;
        dayLbl.lineBreakMode = NSLineBreakMode.ByCharWrapping;
        
    }
    
}
