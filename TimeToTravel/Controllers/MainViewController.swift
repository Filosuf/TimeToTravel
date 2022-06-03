//
//  ViewController.swift
//  TimeToTravel
//
//  Created by 1234 on 31.05.2022.
//

import UIKit

final class MainViewController: UIViewController {

    private var flights = [Flight]()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray6
        collectionView.register(FlightsCollectionViewCell.self, forCellWithReuseIdentifier: FlightsCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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
        layout()
        getFlights()
    }

    // скрываем NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //
    private func getFlights() {
        let travelURL = URL(string: "https://travel.wildberries.ru/statistics/v1/cheap")
        guard let url = travelURL else { return }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let inputData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let conteiner = try! decoder.decode(Container.self, from: inputData)
                    self.flights = conteiner.data
                    // Когда данные получены и расшифрованы,
                    // мы останавливаем наш индикатор и обновляем CollectionView.
                    DispatchQueue.main.async {
                        self.spinnerView.stopAnimating()
                        self.collectionView.reloadData()
                    }
                }
            } else {
                debugPrint("Failed loading JSON")
            }
        }
        dataTask.resume()
    }

    private func layout() {
        [collectionView, spinnerView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([

            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        flights.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightsCollectionViewCell.identifier, for: indexPath) as! FlightsCollectionViewCell
        cell.flight = flights[indexPath.row]
        cell.setupCell()
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    private var sideInsert: CGFloat { return Constants.cellSideInsert}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 2 * sideInsert) / 1
        return CGSize(width: width, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sideInsert
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sideInsert
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: sideInsert, left: sideInsert, bottom: sideInsert, right: sideInsert)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FlightDetailsViewController()
        vc.flight = flights[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

