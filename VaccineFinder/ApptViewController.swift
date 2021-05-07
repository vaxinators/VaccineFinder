//  ApptViewController.swift
//  VaccineFinder
//
//  Created by IOSGroup on 4/11/21.

import UIKit
import CoreLocation

class ApptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	var	rawData: [[String: Any]] = []
	var sortedData: [[String: Any]] = []
	var locationMarker: CLPlacemark?

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		getPlacemark()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// TODO: Insert loading screen for tableview
		if sortedData.count == 0 {
			return 7
		}

		return sortedData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ApptCell") as! ApptTableViewCell

		// TODO: Insert loading screen for tableview
		if sortedData.count == 0 {
			cell.locationName.text = "Loading..."
			cell.locationAddress.text = "Loading..."
			cell.distanceTo.text = "Loading..."
			return cell
		}

		let location = sortedData[indexPath.row]
		let properties = location["properties"] as! [String: Any]
		let distanceTo = location["distanceTo"] as! Double
		cell.locationName.text = properties["provider"] as? String
		cell.locationAddress.text = properties["address"] as? String
		cell.distanceTo.text = String(distanceTo)

		return cell
	}

	func getPlacemark() {
		let userLocation = UserDefaults.standard.string(forKey: "userLocation")!
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(userLocation) { (placemarks, error) in
			if error == nil {
				if let placemark = placemarks?[0] {
					self.locationMarker = placemark
					self.loadApiData()
					return
				}
			}
		}
	}

	func loadApiData() {
		let state = locationMarker!.administrativeArea!
		print(state)
		let url = URL(string: "https://www.vaccinespotter.org/api/v0/states/" + state + ".json")!
		let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
		let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
		let task = session.dataTask(with: request) { data, _, error in
			if error == nil {
				if let data = data {
					let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
					self.rawData = dataDictionary["features"] as! [[String: Any]]
					self.prepareApiData()
					return
				}
			}
			// TODO: Insert visual cue for error loading data
			print(error!.localizedDescription)
		}
		task.resume()
	}

	func prepareApiData() {
		var	tempData: [[String: Any]] = []

		for i in 0...(rawData.count-1) {
			let geometry = rawData[i]["geometry"] as! [String: Any]
			let properties = rawData[i]["properties"] as! [String: Any]
			let locationCoordinates = geometry["coordinates"] as! [Double]
			let userCoordinates = locationMarker!.location!
			let showOnlyIfAvailable = UserDefaults.standard.bool(forKey: "showOnlyIfAvailable")
			let available = properties["appointments_available"] as? Bool

			var distanceTo = userCoordinates.distance(
				from: CLLocation(
					latitude: CLLocationDegrees(locationCoordinates[1]),
					longitude: CLLocationDegrees(locationCoordinates[0])
				)
			)
			distanceTo = (distanceTo * 0.00621371192)
			distanceTo.round()
			distanceTo = distanceTo/10
			rawData[i].updateValue(distanceTo, forKey: "distanceTo")

			if showOnlyIfAvailable {
				if let available = available {
					if available {
						tempData.append(rawData[i])
					}
				}
			} else {
				tempData.append(rawData[i])
			}
		}

		tempData.sort { (item1, item2) -> Bool in
			let distance1 = item1["distanceTo"] as! Double
			let distance2 = item2["distanceTo"] as! Double
			return distance1 < distance2
		}

		for i in 0...(tempData.count-1) {
			let maxDistance = UserDefaults.standard.double(forKey: "maxDistance")
			let distanceTo = tempData[i]["distanceTo"] as! Double
			if maxDistance < distanceTo {
				break
			}
			sortedData.append(tempData[i])
		}

		tableView.reloadData()
	}
}

