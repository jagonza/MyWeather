//
//  Constants.swift
//  MyWeather
//
//  Created by Javier González Rojo on 3/4/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//
import UIKit

typealias DownloadCompleted = () -> ()

//TEST
let TEST = "test"

//MARK: - URL
let BASE_URL = "https://api.forecast.io/forecast/"

//MARK: - API
let API_ID_VALUE = "20460f38ff37e39f747dff1882a4d26f"

//MARK: - KEYS
let KEY_ICON = "icon"
let KEY_TEMPERATURE = "temperature"
let KEY_TEMPERATURE_MIN = "temperatureMin"
let KEY_TEMPERATURE_MAX = "temperatureMax"
let KEY_APPARENT_TEMPERATURE = "apparentTemperature"
let KEY_PRECIP_PROBABILITY = "precipProbability"
let KEY_TIME = "time"
let KEY_CURRENT_WEATHER = "currentWeather"
let KEY_HOURLY_WEATHER_ARRAY = "hourlyWeatherArray"
let KEY_DAILY_WEATHER_ARRAY = "dailyWeatherArray"
let KEY_URL = "url"
let KEY_DATE_FOR_PREDICTION = "dateForPrediction"
let KEY_SUMMARY = "summary"
let KEY_HOURLY_SUMMARY = "hourly_summary"
let KEY_DAILY_SUMMARY = "daily_summary"
let KEY_SUNRISE_TIME = "sunriseTime"
let KEY_SUNSET_TIME = "sunsetTime"
let KEY_CURRENT_SUMMARY = "current_summary"

//MARK: - CONSTANTS
let CT_SECONDS_TO_UPDATE: Double = 15 * 60


//MARK: - COLORS
let COLOR_APP_BACKGROUND = UIColor(red: 255/255, green: 250/255, blue: 240/255, alpha: 0.4)

//MARK: - DATE MASK
let MASK_DAY_OF_MONTH = "dd/MM"
let MASK_DAY_OF_WEEK = "EEE"