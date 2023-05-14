//
//  Weather_Temp_data.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 12/05/2023.
//

import UIKit

class Weather_Temp_data: NSObject, Decodable {
    
    var temperature: [Double]?
    
    private enum CodingKeys: String, CodingKey {
        case hour = "hourly"
    }

    private enum RootKeys: String, CodingKey {
        case temperature = "temperature_2m"
    }
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let hourlyContainer = try rootContainer.nestedContainer(keyedBy: RootKeys.self, forKey: .hour)
        print(hourlyContainer)
        // Get authors as an array then compact
        if let temperatureArray = try? hourlyContainer.decode([Double].self, forKey: .temperature) {
            temperature = temperatureArray
        }
        
    }

}
