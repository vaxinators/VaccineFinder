//
//  SettingsViewController.swift
//  VaccineFinder
//
//  Created by Favian Flores on 5/16/21.
//

import UIKit

class SettingsViewController: UIViewController {

	@IBOutlet weak var apptSwitch: UISwitch!
	@IBOutlet weak var distanceSelector: UISegmentedControl!

    override func viewDidLoad() {
			super.viewDidLoad()
			let currentApptPref = UserDefaults.standard.bool(forKey: "showOnlyIfAvailable")
			let currentDistancePref = UserDefaults.standard.double(forKey: "maxDistance")
			var currentDistanceIndex = 0
			if currentDistancePref == 10 {
				currentDistanceIndex = 1
			}
			if currentDistancePref == 15 {
				currentDistanceIndex = 2
			}
			apptSwitch.setOn(currentApptPref, animated: true)
			distanceSelector.selectedSegmentIndex = currentDistanceIndex
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		UserDefaults.standard.setValue(apptSwitch.isOn, forKey: "showOnlyIfAvailable")
		var maxDistance = 5
		if distanceSelector.selectedSegmentIndex == 1 {
			maxDistance = 10
		}
		if distanceSelector.selectedSegmentIndex == 2 {
			maxDistance = 15
		}
		UserDefaults.standard.setValue(maxDistance, forKey: "maxDistance")
	}
}
