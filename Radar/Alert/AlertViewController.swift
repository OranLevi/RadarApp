//
//  AlertViewController.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

public class AlertViewController: UIViewController {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageAlert: UIImageView!
    @IBOutlet weak var buttonAlert: UIButton!
    
    public var titleAlert: String = ""
    public var messageAlert: String = ""
    public var imageViewAlert:String?
    public var colorButtonAlert: UIColor?
    public var colorImage: UIColor?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        mainView.layer.cornerRadius = 8
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        buttonAlert.layer.cornerRadius = 8
        titleLabel.text = titleAlert
        messageLabel.text = messageAlert
        imageAlert.image = UIImage(systemName: "\(imageViewAlert ?? "")")
        imageAlert.tintColor = colorImage
        buttonAlert.backgroundColor = colorButtonAlert
        startAnimation()
    }
    
    func startAnimation(){
        mainView.alpha = 0
        self.mainView.frame.origin.y += 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.mainView.alpha = 1.0
            self.mainView.frame.origin.y -= 50
        })
    }
    
    func stopAnimation() {
        self.mainView.transform = .identity
        UIView.animate(withDuration: 0.5) {
            self.mainView.transform = CGAffineTransform(translationX: 0, y: self.mainView.frame.height)
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func buttonOk(_ sender: Any) {
        stopAnimation()
    }
}
