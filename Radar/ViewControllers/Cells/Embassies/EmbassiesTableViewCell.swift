//
//  EmbassiesTableViewCell.swift
//  Radar
//
//  Created by Oran on 03/08/2022.
//

import UIKit

class EmbassiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
