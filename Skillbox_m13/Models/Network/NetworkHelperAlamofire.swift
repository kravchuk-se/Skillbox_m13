//
//  NetworkHelperAlamofire.swift
//  Skillbox_m13
//
//  Created by Kravchuk Sergey on 27.10.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHelperAlamofire {
    
    func fetchCurrentWeather(comlpetion: @escaping (AccuWeatherCurrentConditions)->Void ) {
        request(AccuWeatherAPI.currentWeatherURL).response  { response in
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            if let result = try? decoder.decode([AccuWeatherCurrentConditions].self, from: data),
                let currentWeather = result.first {
                comlpetion(currentWeather)
            }
        }
    }
    
    func fetchHourlyForecast(metric: Bool, comletion: @escaping ([AccuWeatherHourlyForecast]) -> Void) {
        request(AccuWeatherAPI.hourlyForecastURL(metric: metric)).response {response in
                    guard let data = response.data else { return }
                    
                    let decoder = JSONDecoder()
                    if let forecastData = try? decoder.decode([AccuWeatherHourlyForecast].self, from: data) {
                        comletion(forecastData)
                    }
        }
    }
    
    func fetchDailyForecast(metric: Bool, completion: @escaping ([AccuWeatherDailyForecast]) -> Void) {
        request(AccuWeatherAPI.dailyForecastURL(metric: metric)).responseJSON { response in
            if let jsonData = response.value as? NSDictionary,
                let forecastsData = jsonData.value(forKey: "DailyForecasts") as? [NSDictionary] {
                let forecasts = forecastsData.compactMap { AccuWeatherDailyForecast(data: $0) }
                completion(forecasts)
            }
        }
    }
    
}
