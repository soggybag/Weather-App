//
//  OpenWeatherMap.swift
//  Weather Mock up 1
//
//  Created by mitchell hudson on 1/8/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//

// City Not found returns:
// {"message":"Error: Not found city","cod":"404"}


import UIKit

protocol OpenWeatherMapDelegate {
    func updateWeather()
}

class OpenWeatherMap {
    
    // Delegate that will display the weather
    var delegate: OpenWeatherMapDelegate!
    
    // Define some constants to hold info that won't change
    var openWeatherAPIKey = "0"
    let openWeatherURL = "http://api.openweathermap.org/data/2.5/weather"
    
    // Variables used by the program
    var cityName            = ""
    var weatherDescription  = ""
    var weatherTemp         = ""
    var weatherMinTemp      = ""
    var weatherMaxTemp      = ""
    var weatherDateString   = ""
    var weatherWindDeg      = ""
    var weatherWindSpeed    = ""
    var weatherImageName    = ""
    
    
    // MARK: - Initializer
    init() {
        
    }
    
    
    // MARK: - Load Weather
    
    // Load Weather 
    func loadWeather() {
        // Do any additional setup after loading the view, typically from a nib.
        
        // APPID=APIKEY
        // q=city name
        
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        request.GET(openWeatherURL, parameters: ["q":self.cityName, "APPID":openWeatherAPIKey], success: {(response: HTTPResponse) in
            // Wrap the dict with swifty
            if let dict = response.responseObject as? Dictionary<String, AnyObject> {
                let json = JSON(object: dict)
                
                // Get the weather description
                if let description = json["weather"][0]["description"].stringValue{
                    self.weatherDescription = description
                }
                
                // The temperature
                if let temp = json["main"]["temp"].doubleValue {
                    self.weatherTemp = "\(self.fixTempForDisplay(temp))°"
                }
                
                // The minimum temperature
                if let minTemp = json["main"]["temp_min"].doubleValue {
                    self.weatherMinTemp = "\(self.fixTempForDisplay(minTemp))"
                }
                
                // The maximum temperature
                if let maxTemp = json["main"]["temp_max"].doubleValue {
                    self.weatherMaxTemp = "\(self.fixTempForDisplay(maxTemp))"
                }
                
                // City name
                if let city = json["name"].stringValue {
                    self.cityName = city
                }
                
                if let dateTime = json["dt"].doubleValue {
                    let date = NSDate(timeIntervalSince1970: dateTime)
                    self.weatherDateString = self.formatDate(date)
                }
                
                if let windDeg = json["wind"]["deg"].doubleValue {
                    self.weatherWindDeg = "\(windDeg)"
                }
                
                if let windSpeed = json["wind"]["speed"].doubleValue {
                    self.weatherWindSpeed = "\(windSpeed)"
                }
                
                if let weatherImage = json["weather"][0]["icon"].stringValue {
                    self.weatherImageName = weatherImage
                }
                
                
                // Network session handled on separate thread, sync this with the main thread to update labels
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate.updateWeather()
                })
            }
            
            }, failure: {(error: NSError, repsonse: HTTPResponse?) in
                println("error \(error)")
        })
        
    }
    
    
    // MARK: - Helper functions
    func timeStampToDate(timeStamp: NSTimeInterval) -> NSDate {
        return NSDate(timeIntervalSince1970: timeStamp)
    }
    
    func formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        return dateFormatter.stringFromDate(date)
    }
    
    func cToF(tempC: Double) -> Double {
        return (tempC * 1.8) + 32
    }
    
    func fToC(tempF: Double) -> Double {
        return (tempF - 32) / 1.8
    }
    
    
    func kelvinToDegrees(tempK: Double) -> Double {
        return tempK - 272.15
    }
    
    
    func fixTempForDisplay(temp: Double) -> String {
        println("Kelvin: \(temp)")
        println("C: \(temp - 273.15)")
        
        let tempC = kelvinToDegrees(temp)
        let tempF = cToF(tempC)
        let tempR = round(tempF)
        let tempString = String(format: "%.0f", tempR)
        return tempString
    }

}













