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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
