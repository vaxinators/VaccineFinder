//
//  MapViewController.swift
//  VaccineFinder
//
//  Created by Favian Flores on 6/23/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

	var	rawData: [[String: Any]] = []
	var sortedData: [[String: Any]] = []
	var locationMarker: CLPlacemark?
	@IBOutlet weak var mapView: MKMapView!
	let locationManager = CLLocationManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
		mapView.showsUserLocation = true
		getPlacemark()
	}
    

	func getPlacemark() {
		let userLocation = locationManager.location!
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation (userLocation) { (placemarks, error) in
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
			var properties = rawData[i]["properties"] as! [String: Any]
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
			let newAnnotation = MKPointAnnotation()
			newAnnotation.title = properties["provider"] as? String
			newAnnotation.coordinate = CLLocationCoordinate2D(
				latitude: CLLocationDegrees(locationCoordinates[1]),
				longitude: CLLocationDegrees(locationCoordinates[0])
			)
			mapView.addAnnotation(newAnnotation)

			distanceTo = (distanceTo * 0.00621371192)
			distanceTo.round()
			distanceTo = distanceTo/10
			properties.updateValue(distanceTo, forKey: "distanceTo")
			rawData[i].updateValue(properties, forKey: "properties")

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
			let properties1 = item1["properties"] as! [String: Any]
			let properties2 = item2["properties"] as! [String: Any]
			let distance1 = properties1["distanceTo"] as! Double
			let distance2 = properties2["distanceTo"] as! Double
			return distance1 < distance2
		}

		for i in 0...(tempData.count-1) {
			let maxDistance = UserDefaults.standard.double(forKey: "maxDistance")
			let properties = tempData[i]["properties"] as! [String: Any]
			let distanceTo = properties["distanceTo"] as! Double
			if maxDistance < distanceTo {
				break
			}
			sortedData.append(tempData[i])
		}

		// add points to map
	}

//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		let cell = sender as! UITableViewCell
//		let indexPath = tableView.indexPath(for: cell)!
//		var properties = sortedData[indexPath.row]
//		properties = properties["properties"] as! [String: Any]
//		let ApptDetailsViewController = segue.destination as! ApptDetailsViewController
//		ApptDetailsViewController.properties = properties
//		tableView.deselectRow(at: indexPath, animated: true)
//	}
}
