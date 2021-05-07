//
//  InitViewController.swift
//  VaccineFinder
//
//  Created by Favian Flores on 5/2/21.
//

import UIKit
import CoreLocation

class InitViewController: UIViewController {

	@IBOutlet weak var zipCodeTF: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		UserDefaults.standard.setValue("00000", forKey: "userLocation")
		UserDefaults.standard.setValue(true, forKey: "showOnlyIfAvailable")
		UserDefaults.standard.setValue(10, forKey: "maxDistance")
	}

	@IBAction func onGoButton(_ sender: Any) {
		let addressString = zipCodeTF.text!
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(addressString) { (placemarks, error) in
			if error == nil {
				if let placemark = placemarks?[0] {
					if placemark.country! == "United States" {
						UserDefaults.standard.setValue(addressString, forKey: "userLocation")
						self.performSegue(withIdentifier: "showLocations", sender: self)
						return
					}
				}
			}
			// TODO: Add visual cue for incorrect zipcode
			print("incorrect zipcode")
		}
	}
}
