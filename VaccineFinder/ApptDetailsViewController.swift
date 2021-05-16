//  ApptDetailsViewController.swift
//  VaccineFinder
//
//  Created by Favian Flores on 5/9/21.

import UIKit

class ApptDetailsViewController: UIViewController {

	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var providerName: UILabel!
	@IBOutlet weak var apptAvailability: UILabel!
	@IBOutlet weak var firstDoseAvailability: UILabel!
	@IBOutlet weak var secondDoseAvailability: UILabel!
	@IBOutlet weak var website: UITextView!
	@IBOutlet weak var distanceTo: UILabel!

	var properties: [String: Any]!

	override func viewDidLoad() {
		super.viewDidLoad()
		addressLabel.text = properties["address"] as? String ?? "address not found"
		let distance = properties["distanceTo"] as! Double
		distanceTo.text = String(distance)
		
		var provider = properties["provider"] as? String ?? "provider not found"
		if provider != "provider not found" {
			provider = provider.replacingOccurrences(of: "_", with: " ")
			provider = provider.capitalized
			if provider == "Cvs" {
				provider = "CVS"
			}
		}
		providerName.text = provider
		website.text = properties["url"] as? String ?? "website not found"
		let anyDoses = properties["appointments_available"] as? Bool ?? false
		let allDosesAvailable = properties["appointments_available_all_doses"] as? Bool ?? false
		let secondDoseAvailable = properties["appointments_available_2nd_dose_only"] as? Bool ?? false
		if anyDoses {
			apptAvailability.text = "Appointment available"
		}
		else {
			apptAvailability.text = "No available appointments"
		}
		if allDosesAvailable {
			firstDoseAvailability.text = "available"
			secondDoseAvailability.text = "available"
			firstDoseAvailability.textColor = .green
			secondDoseAvailability.textColor = .green
		}
		else if secondDoseAvailable {
			firstDoseAvailability.text = "unavailable"
			secondDoseAvailability.text = "available"
			firstDoseAvailability.textColor = .red
			secondDoseAvailability.textColor = .green
		}
		else {
			firstDoseAvailability.text = "unavailable"
			secondDoseAvailability.text = "unavailable"
			firstDoseAvailability.textColor = .red
			secondDoseAvailability.textColor = .red
		}
	}

}

