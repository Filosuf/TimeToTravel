//
//  FlightDetailsViewController.swift
//  TimeToTravel
//
//  Created by 1234 on 01.06.2022.
//

import UIKit

final class FlightDetailsViewController: UIViewController {

    let flightDetailsView = FlightDetailsView()
    var flight: Flight?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setBar()
        layout()
        setupView()

    }

    private func setBar() {
        title = "Подробнее"
    }

    private func setupView() {
        flightDetailsView.setupView(flight: flight)
        flightDetailsView.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
    }

    @objc func likeButtonPressed() {
        guard let flight = flight else { return }
        if let _ = Storage.likedFlights[flight] {
            Storage.likedFlights[flight] = nil
            flightDetailsView.likeButton.configuration?.image = UIImage(systemName: "heart")
        } else {
            Storage.likedFlights[flight] = true
            flightDetailsView.likeButton.configuration?.image = UIImage(systemName: "heart.fill")
        }
    }

    private func layout() {
        flightDetailsView.translatesAutoresizingMaskIntoConstraints = false
        [flightDetailsView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            flightDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            flightDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flightDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flightDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
