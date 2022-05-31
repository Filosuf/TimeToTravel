//
//  JsonContainer.swift
//  TimeToTravel
//
//  Created by 1234 on 31.05.2022.
//

import Foundation

struct Container: Codable {
//    let meta: Any
    let data: [Flight]
}

struct Flight: Codable {
    let startCity: String
    let startCityCode: String
    let endCity: String
    let endCityCode: String
    let startDate: Date
    let endDate: Date
    let price: Int
    let searchToken: String
}
