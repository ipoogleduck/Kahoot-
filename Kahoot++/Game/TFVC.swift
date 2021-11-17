//
//  TFVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/16/21.
//

import UIKit

class TFVC: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var LeftButtonView: UIView!
    @IBOutlet var RightButtonView: UIView!
    
    var delegate: GameDelegate?
    var question: QuestionStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question.question
        
        configureButtonViews([
            LeftButtonView,
            RightButtonView
        ])
        LeftButtonView.backgroundColor = .red
        RightButtonView.backgroundColor = .blue
    }
    
    func configureButtonViews(_ views: [UIView]) {
        for view in views {
            view.layer.cornerRadius = 15
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 6
        }
    }
    
    @IBAction func LeftButtonView(_ sender: Any) {
        delegate?.showFeedback(from: self, correct: !question.trueOrFalse!)
    }
    
    @IBAction func RightButtonView(_ sender: Any) {
        delegate?.showFeedback(from: self, correct: question.trueOrFalse!)
    }
    
}
