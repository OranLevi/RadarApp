//
//  CustomHeaderTask.swift
//  Radar
//
//  Created by Oran Levi on 30/11/2022.
//

import UIKit

class CustomHeaderTask: UITableViewCell {

    @IBOutlet weak var flightNumberTask: UILabel!
    @IBOutlet weak var flightDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
