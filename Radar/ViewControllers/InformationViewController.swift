//
//  InformationViewController.swift
//  Radar
//
//  Created by Oran on 03/08/2022.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var buttonEmbassiesIsraelAtWorld: UIButton!
    @IBOutlet weak var buttonEmbassiesInIsrael: UIButton!
    
    var service = Service.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        buttonEmbassiesIsraelAtWorld.layer.cornerRadius = 20
        buttonEmbassiesInIsrael.layer.cornerRadius = 20
        service.animateButton(button: buttonEmbassiesIsraelAtWorld)
        service.animateButton(button: buttonEmbassiesInIsrael)
    }
}
