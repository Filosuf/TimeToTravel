//
//  FlightDetailsView.swift
//  TimeToTravel
//
//  Created by 1234 on 02.06.2022.
//

import UIKit

class FlightDetailsView: UIView {

    private let fontSize: CGFloat = 20
    private let highlightFontSize: CGFloat = 30

    private lazy var startCityLbael = makeLabel(fontSize: fontSize)
    private lazy var endCityLbael = makeLabel(fontSize: fontSize)
    private lazy var startDateLbael = makeLabel(fontSize: fontSize)
    private lazy var endDateLbael = makeLabel(fontSize: fontSize)
    private lazy var priceLbael = makeLabel(fontSize: fontSize)

    //Button for iOS15 or later
    let likeButton: UIButton = {
        var configuration = UIButton.Configuration.gray()

        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 35)
        // 1 Добавление текста
        configuration.attributedTitle = AttributedString("Like", attributes: container)
        //2 Добавление изображения и положение внутри кнопки
        configuration.image = UIImage(systemName: "heart")
        configuration.titleAlignment = .trailing
        configuration.imagePlacement = .trailing
        // 3 Размер изображения и отступ от текста
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 35)
        configuration.imagePadding = 10
        //4 Размер кнопки
        configuration.buttonSize = .large
        //5 Скругление кнопки
        configuration.cornerStyle = .large
        //6 Назначение цвета
        configuration.baseForegroundColor = .WbTheme.magenta
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(flight: Flight?) {
        guard let flight = flight else { return }
        startCityLbael.text = "Город отправления:\n\(flight.startCity)\n\(flight.startCityCode.uppercased())"
        startCityLbael.attributedText = setAttributText(mainString: startCityLbael.text!, highlight: flight.startCity)

        endCityLbael.text = "Город прибытия:\n\(flight.endCity)\n\(flight.endCityCode.uppercased())"
        endCityLbael.attributedText = setAttributText(mainString: endCityLbael.text!, highlight: flight.endCity)

        startDateLbael.text = "Дата отправления:\n" + dateToString(date: flight.startDate)
        startDateLbael.attributedText = setAttributText(mainString: startDateLbael.text!, highlight: dateToString(date: flight.startDate))

        endDateLbael.text = "Дата прибытия:\n" + dateToString(date: flight.endDate)
        endDateLbael.attributedText = setAttributText(mainString: endDateLbael.text!, highlight: dateToString(date: flight.endDate))

        priceLbael.text = "Цена: " + String(flight.price) + "₽"
        priceLbael.attributedText = setAttributText(mainString: priceLbael.text!, highlight: String(flight.price))

        if let _ = Storage.likedFlights[flight] {
            likeButton.configuration?.image = UIImage(systemName: "heart.fill")
        } else {
            likeButton.configuration?.image = UIImage(systemName: "heart")
        }
    }

    private func setAttributText(mainString: String, highlight: String) -> NSMutableAttributedString {
        let colorOfTime = UIColor.WbTheme.darkViolet
        //setting a different color and font size
        let range = (mainString as NSString).range(of: highlight)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorOfTime, range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: highlightFontSize, weight: .bold), range: range)
        return mutableAttributedString
    }


    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    private func layout() {

        let interval: CGFloat = 12

        [startCityLbael,
         endCityLbael,
         startDateLbael,
         endDateLbael,
         priceLbael,
         likeButton
        ].forEach { addSubview($0) }

        NSLayoutConstraint.activate([

            startCityLbael.topAnchor.constraint(equalTo: topAnchor, constant: interval),
            startCityLbael.leadingAnchor.constraint(equalTo: leadingAnchor, constant: interval),

            endCityLbael.topAnchor.constraint(equalTo: startCityLbael.bottomAnchor, constant: interval),
            endCityLbael.leadingAnchor.constraint(equalTo: leadingAnchor, constant: interval),

            startDateLbael.topAnchor.constraint(equalTo: endCityLbael.bottomAnchor, constant: interval),
            startDateLbael.leadingAnchor.constraint(equalTo: leadingAnchor, constant: interval),

            endDateLbael.topAnchor.constraint(equalTo: startDateLbael.bottomAnchor, constant: interval),
            endDateLbael.leadingAnchor.constraint(equalTo: leadingAnchor, constant: interval),

            priceLbael.topAnchor.constraint(equalTo: endDateLbael.bottomAnchor, constant: interval),
            priceLbael.leadingAnchor.constraint(equalTo: leadingAnchor, constant: interval),

            likeButton.topAnchor.constraint(equalTo: priceLbael.bottomAnchor, constant: interval),
            likeButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
