//
//  ApptTableViewCell.swift
//  VaccineFinder
//
//  Created by Favian Flores on 4/30/21.
//

import UIKit

class ApptTableViewCell: UITableViewCell {

	@IBOutlet weak var locationName: UILabel!
	@IBOutlet weak var locationAddress: UILabel!
	@IBOutlet weak var distanceTo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // adding shadows
        /*
        locationName.layer.shadowColor = UIColor.white.cgColor
        locationName.layer.shadowOffset = .zero
        locationName.layer.shadowOpacity = 0.6
        locationName.layer.shadowRadius = 10.0
 */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
