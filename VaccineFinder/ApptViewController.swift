//  ApptViewController.swift
//  VaccineFinder
//
//  Created by IOSGroup on 4/11/21.

import UIKit

class ApptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	var appointments: [[String: Any]] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.dataSource = self
		tableView.delegate = self
		loadApiData()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return appointments.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ApptCell") as! ApptTableViewCell

		let location = appointments[indexPath.row]
		let properties = location["properties"] as! [String: Any]
		cell.locationName.text = properties["provider"] as? String
		cell.locationAddress.text = properties["address"] as? String

		return cell
	}

	func loadApiData() {
		let url = URL(string: "https://www.vaccinespotter.org/api/v0/states/NY.json")!
		let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
		let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
		let task = session.dataTask(with: request) { data, _, error in
			if let error = error {
				print(error.localizedDescription)
			} else if let data = data {
				let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
				self.appointments = dataDictionary["features"] as! [[String: Any]]
				self.tableView.reloadData()
			}
		}
		task.resume()
	}


}

