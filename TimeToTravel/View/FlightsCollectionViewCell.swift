//
//  FlightsCollectionViewCell.swift
//  TimeToTravel
//
//  Created by 1234 on 01.06.2022.
//

import UIKit

class FlightsCollectionViewCell: UICollectionViewCell {

    static let identifier = "FlightsCollectionViewCell"
    var flight: Flight?

    private lazy var startCityLbael = makeLabel(fontSize: 22)
    private lazy var startCityCodeLbael = makeLabel(fontSize: 12)
    private lazy var endCityLbael = makeLabel(fontSize: 22)
    private lazy var endCityCodeLbael = makeLabel(fontSize: 12)
    private lazy var startDateLbael = makeLabel(fontSize: 19)
    private lazy var endDateLbael = makeLabel(fontSize: 19)
    private lazy var priceLbael = makeLabel(fontSize: 27)

    private let cityDivider: UILabel = {

        let label = UILabel()
        label.text = "<->"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .WbTheme.magenta
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray3
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
            // cell rounded section
            self.layer.cornerRadius = 15.0
            self.layer.masksToBounds = true
    }

    @objc func likeButtonPressed() {
        guard let flight = flight else { return }
        //если перелет находится в словаре likedFlights то удаляем его из словаря и убираем Like и наоборот
        if let _ = Storage.likedFlights[flight] {
            Storage.likedFlights[flight] = nil
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            Storage.likedFlights[flight] = true
            likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    //Настрока отображаемого текста о перелёте и иконки Like
    func setupCell() {
        guard let flight = flight else { return }
        startCityLbael.text = flight.startCity
        startCityCodeLbael.text = flight.startCityCode.uppercased()
        endCityLbael.text = flight.endCity
        endCityCodeLbael.text = flight.endCityCode.uppercased()
        startDateLbael.text = "Туда: " + dateToString(date: flight.startDate)
        endDateLbael.text = "Обратно: " + dateToString(date: flight.endDate)
        priceLbael.text = String(flight.price) + "₽"
        if let _ = Storage.likedFlights[flight] {
            likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    private func layout() {

        let interval: CGFloat = 12

        [startCityLbael,
         startCityCodeLbael,
         cityDivider,
         endCityLbael,
         endCityCodeLbael,
         startDateLbael,
         endDateLbael,
         priceLbael,
         likeButton
        ].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            startCityLbael.topAnchor.constraint(equalTo: contentView.topAnchor, constant: interval),
            startCityLbael.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: interval),

            cityDivider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: interval),
            cityDivider.leadingAnchor.constraint(equalTo: startCityLbael.trailingAnchor, constant: interval),

            endCityLbael.topAnchor.constraint(equalTo: contentView.topAnchor, constant: interval),
            endCityLbael.leadingAnchor.constraint(equalTo: cityDivider.trailingAnchor, constant: interval),
            endCityLbael.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -interval),

            startCityCodeLbael.topAnchor.constraint(equalTo: startCityLbael.bottomAnchor),
            startCityCodeLbael.leadingAnchor.constraint(equalTo: startCityLbael.leadingAnchor),

            endCityCodeLbael.topAnchor.constraint(equalTo: endCityLbael.bottomAnchor),
            endCityCodeLbael.leadingAnchor.constraint(equalTo: endCityLbael.leadingAnchor),

            endDateLbael.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -interval),
            endDateLbael.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: interval),

            startDateLbael.bottomAnchor.constraint(equalTo: endDateLbael.topAnchor, constant: -interval),
            startDateLbael.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: interval),

            priceLbael.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -interval),
            priceLbael.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -interval),

            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -interval),
            likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40)

        ])
    }
}
