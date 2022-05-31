//
//  ViewController.swift
//  TimeToTravel
//
//  Created by 1234 on 31.05.2022.
//

import UIKit

final class MainViewController: UIViewController {

    private var flights = [Flight]()

    private let internetImage: UIImageView = {

        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .systemMint
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()

    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
            activityView.hidesWhenStopped = true
            activityView.translatesAutoresizingMaskIntoConstraints = false
            activityView.startAnimating()
            return activityView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        getFlights()
        layout()
    }

    private func getFlights() {
        let travelURL = URL(string: "https://travel.wildberries.ru/statistics/v1/cheap")

        guard let url = travelURL else { return }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let inputData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let conteiner = try! decoder.decode(Container.self, from: inputData)
//                    dump(conteiner)
                    self.flights = conteiner.data
                    print(self.flights[0])
                    // Когда данные получены и расшифрованы,
                    // мы останавливаем наш индикатор и он исчезает.
                    DispatchQueue.main.async {
                        self.spinnerView.stopAnimating()
                    }

                }
            } else {
                print("Failed loading JSON")
            }
        }
        dataTask.resume()
    }

    private func layout() {
        let spaceInterval: CGFloat = 16
        [internetImage, spinnerView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            internetImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spaceInterval),
            internetImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spaceInterval),
            internetImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spaceInterval),
            internetImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spaceInterval),

            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

