//
//  JsonContainer.swift
//  TimeToTravel
//
//  Created by 1234 on 31.05.2022.
//

import Foundation

struct Container: Codable {
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

//MARK: -Hashable
//Расширение сделано на предположении, что "searchToken" уникален для каждого перелёта. Тогда будет возможность восстанавливать лайки при обновлении списка авиаперелётов. Планируется, что лайки будут хранится на устройстве или отправлятся на сервер в пакете не собержащем в себе все парамметры структуры (город отправления, город прибытия и т.д.). В противном случае можно в структуру "Flight" добавить опциональную переменную "Лайк"
extension Flight: Hashable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.searchToken == rhs.searchToken
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(searchToken)
    }
}
