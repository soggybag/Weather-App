//
//  ViewController.swift
//  Weather Mock up 1
//
//  Created by mitchell hudson on 1/3/15.
//  Copyright (c) 2015 mitchell hudson. All rights reserved.
//


// Todo:
// Need night images for weather icons

import UIKit

class ViewController: UIViewController, OpenWeatherMapDelegate {
    
    // MARK: - Variables
    
    var openWeatherMap = OpenWeatherMap()
    
    // Define some constants to hold info that won't change
    let openWeatherAPIKey = "2854c5771899ff92cd962dd7ad58e7b0"
    let openWeatherURL = "http://api.openweathermap.org/data/2.5/weather"
    
    
    // MARK: - IBOutlets
    
    // IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    // MARK: - IBActions
    
    // IBActions 
    @IBAction func cityButtonPressed(sender: AnyObject) {
        openAlertBox()
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set self as delegate for open weather map
        self.openWeatherMap.delegate = self
        self.openWeatherMap.cityName = "San Francisco"
        self.openWeatherMap.openWeatherAPIKey = self.openWeatherAPIKey
        self.openWeatherMap.loadWeather()
        
        self.openWeatherMap.loadWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - City Name Alert
    
    // This function opens an alert box with two buttons and an input field
    func openAlertBox() {
        // Make a UIAlertController
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: .Alert)
        
        // Make a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            // The cancel action could do something here
        }
        // Add the cancel action
        alert.addAction(cancelAction)
        
        // Make an OK action. This will look at the textfield in the alert.
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            // Choosing OK will set the city name
            if let cityTextField: UITextField = alert.textFields?.first as? UITextField {
                self.openWeatherMap.cityName = cityTextField.text
                self.openWeatherMap.loadWeather()
            }
        }
        // Add the OK action to the Alert
        alert.addAction(okAction)
        
        // Add a text field to the alert
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "city"
        }
        
        // Present the alert box.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Update Weather 
    
    func updateWeather() {
        cityLabel.text          = self.openWeatherMap.cityName
        descriptionLabel.text   = self.openWeatherMap.weatherDescription
        tempLabel.text          = self.openWeatherMap.weatherTemp
        minTempLabel.text       = self.openWeatherMap.weatherMinTemp
        maxTempLabel.text       = self.openWeatherMap.weatherMaxTemp
        dateLabel.text          = self.openWeatherMap.weatherDateString
        weatherImage.image      = UIImage(named: self.openWeatherMap.weatherImageName)
        weatherImage.contentMode = UIViewContentMode.ScaleAspectFill
    }


}

