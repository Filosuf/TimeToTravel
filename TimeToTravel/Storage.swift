//
//  Storage.swift
//  TimeToTravel
//
//  Created by 1234 on 02.06.2022.
//

import Foundation

final class Storage {

    //Словарь содержащий понравившееся перелёты
    static var likedFlights = [Flight: Bool]()
    //Массив содержащий перелёты загруженные из API
    static var flightsArray = [Flight]()
}
