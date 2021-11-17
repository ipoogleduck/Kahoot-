//
//  TFVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/16/21.
//

import UIKit

class TFVC: UIViewController {
    
    @IBOutlet var LeftButtonView: UIView!
    @IBOutlet var RightButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonViews([
            LeftButtonView,
            RightButtonView
        ])
    }
    
    func configureButtonViews(_ views: [UIView]) {
        for view in views {
            view.backgroundColor = .secondarySystemGroupedBackground
            view.layer.cornerRadius = 15
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 6
        }
    }
    
    @IBAction func LeftButtonView(_ sender: Any) {
    }
    
    @IBAction func RightButtonView(_ sender: Any) {
    }
    
}
