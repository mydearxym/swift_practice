//
//  ViewController.swift
//  my-weather
//
//  Created by mydear-xym on 14-9-2.
//  Copyright (c) 2014年 xieyiming. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {
    let locationManger:CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        //TODO: set a image
        let background = UIImage(named: "me3.png")
        self.view.backgroundColor = UIColor(patternImage: background)

        if(ios8()) {
            locationManger.requestAlwaysAuthorization()
        }
        
        locationManger.startUpdatingLocation()
    }

    func ios8() -> Bool {
        return UIDevice.currentDevice().systemVersion == "8.0"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        var location:CLLocation = locations[locations.count-1] as CLLocation

        if (location.horizontalAccuracy > 0) {
            println(location.coordinate.latitude)
            println(location.coordinate.longitude)

            // 这里self 可以省去, 第一个参数不用参数名
            self.updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManger.stopUpdatingLocation()
        }
    }
    
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"

        let params = ["lat": latitude, "lon": longitude, "cnt": 0]

        manager.GET(url, parameters: params,
            success: {
                (operation:AFHTTPRequestOperation!, responseObject: AnyObject!)in println("JSON: "+responseObject.description!)
                self.updateUISuccess(responseObject as NSDictionary!)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in println("Error: " + error.localizedDescription)
            }
        )
        
    }

    func updateUISuccess(jsonResult: NSDictionary!) {

        if let tempResult = ((jsonResult["main"]? as NSDictionary)["temp"] as? Double) {
            
            // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
            var temperature: Double
            if let sys = (jsonResult["sys"]? as? NSDictionary) {
                if let country = (sys["country"] as? String) {
                    if (country == "US") {
                        // Convert temperature to Fahrenheit if user is within the US
                        temperature = round(((tempResult - 273.15) * 1.8) + 32)
                    }
                    else {
                        // Otherwise, convert temperature to Celsius
                        temperature = round(tempResult - 273.15)
                    }
                    
                    // Is it a bug of Xcode 6? can not set the font size in IB.
                    self.temperature.font = UIFont.boldSystemFontOfSize(60)
                    self.temperature.text = "\(temperature)°"
                }
                
                if let name = jsonResult["name"] as? String {
                    self.location.font = UIFont.boldSystemFontOfSize(25)
                    self.location.text = name
                }
                
                if let weather = jsonResult["weather"]? as? NSArray {
                    var condition = (weather[0] as NSDictionary)["id"] as Int
                    var sunrise = sys["sunrise"] as Double
                    var sunset = sys["sunset"] as Double
                    
                    var nightTime = false
                    var now = NSDate().timeIntervalSince1970
                    // println(nowAsLong)
                    
                    if (now < sunrise || now > sunset) {
                        nightTime = true
                    }
                    self.updateWeatherIcon(condition, nightTime: nightTime)
                    return
                }
            }
        }
/*
        if let tempResult = (jsonResult["main"]?["temp"] as? Double) {
            var temperature: Double
            if (jsonResult["sys"]?["country"]? as String == "US") {
                // Convert temperature to Fahrenheit if user is within the US
                temperature = round(((tempResult - 273.15)*1.8)+32)
            }
            else {
                temperature = round(tempResult - 273.15)
            }
            //绑定的 UIlabel temperature
            self.temperature.text = "\(temperature)^C"
            self.temperature.font = UIFont.boldSystemFontOfSize(60)
            
            var name = jsonResult["name"]?as String
            self.location.font = UIFont.boldSystemFontOfSize(25)
            self.location.text = "\(name)"
            
            var condition = (jsonResult["weather"]? as NSArray)[0]?["id"]?as Int
            var sunrise = jsonResult["sys"]?["sunrise"]? as Double
            var sunset = jsonResult["sys"]?["sunset"]? as Double
        
            var nightTime = false
            var now = NSDate().timeIntervalSince1970
            if (now < sunrise || now > sunset) {
                nightTime = true
            }
            self.updateWeatherIcon(condition, nightTime: nightTime)
        }
        else {
        
        }
    */
    }
    
    func updateWeatherIcon(condition: Int, nightTime: Bool) {
        if(condition < 300) {
            if nightTime {
                self.icon.image = UIImage(named: "tstorm1_night")
            }
            else {
                self.icon.image = UIImage(named: "tstorm1")
            }
        }
            //Drizzle
        else if (condition < 500) {
            self.icon.image = UIImage(named: "light_rain")
        }
            // Rain/ freezing rain / shower rain
        else if (condition < 600) {
            self.icon.image = UIImage(named: "shower3")
        }
    
            // snow
        else if (condition < 700) {
            self.icon.image = UIImage(named: "snow4")
        }
            //fog / mist / haze
        else if (condition < 771) {
            if nightTime {
                self.icon.image = UIImage(named: "fog_night")
            } else {
                self.icon.image = UIImage(named: "fog")
            }

        }
            // Tornado / Squalls
        else if (condition < 800) {
            self.icon.image = UIImage(named: "tstorm3")
            
        }
            // sky is clear
        else if (condition == 800) {
            if nightTime {
                self.icon.image = UIImage(named: "sunny_night")
            } else {
                self.icon.image = UIImage(named: "sunny")
            }
            
        }
            // few / scattered / broken clouds
        else if (condition < 804) {
            if nightTime {
                self.icon.image = UIImage(named: "cloudy2_night")
            } else {
                self.icon.image = UIImage(named: "cloudy2")
            }
            
        }
            // overcast clouds
        else if (condition == 804) {
            self.icon.image = UIImage(named: "overcast")
        }
            // Extreme
        else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000)) {
            self.icon.image = UIImage(named: "tstorm3")
        }
            // Cold
        else if (condition == 903) {
            self.icon.image = UIImage(named: "snow5")
        }
            // Hot
        else if (condition == 904) {
            self.icon.image = UIImage(named: "sunny")
        }
            // Weather condition is not available
        else {
            self.icon.image = UIImage(named: "dunno")
        }
    
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println(error)
    }

}

