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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
