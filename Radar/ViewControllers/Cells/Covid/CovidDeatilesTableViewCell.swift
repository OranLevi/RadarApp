//
//  CovidDetailsTableViewCell.swift
//  Radar
//
//  Created by Oran on 05/08/2022.
//

import UIKit

class CovidDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
