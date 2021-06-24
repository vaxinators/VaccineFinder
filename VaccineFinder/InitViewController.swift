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
    @IBOutlet weak var tryAgain: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		UserDefaults.standard.setValue("00000", forKey: "userLocation")
		UserDefaults.standard.setValue(false, forKey: "showOnlyIfAvailable")
		UserDefaults.standard.setValue(10, forKey: "maxDistance")
        
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)
	}

	@objc func keyboardWillShow(notification: NSNotification) {
		if self.view.frame.origin.y == 0 {
			self.view.frame.origin.y -= 100
		}
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
	}
    
	@objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
		zipCodeTF.resignFirstResponder()
	}

	@IBAction func onGoButton(_ sender: Any) {
		let addressString = zipCodeTF.text!
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(addressString) { (placemarks, error) in
			if error == nil {
				if let placemark = placemarks?[0] {
					if placemark.country! == "United States" {
						UserDefaults.standard.setValue(addressString, forKey: "userLocation")
						self.performSegue(withIdentifier: "showLocationsTable", sender: self)
						return
					}
				}
			}
			self.tryAgain.textColor = .red
		}
	}
}

