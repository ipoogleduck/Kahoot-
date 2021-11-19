//
//  MCVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/16/21.
//

import UIKit

class MCVC: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var TLButtonView: UIView!
    @IBOutlet var TRButtonView: UIView!
    @IBOutlet var BLButtonView: UIView!
    @IBOutlet var BRButtonView: UIView!
    
    @IBOutlet var TLButton: UIButton!
    @IBOutlet var TRButton: UIButton!
    @IBOutlet var BLButton: UIButton!
    @IBOutlet var BRButton: UIButton!
    
    
    var delegate: GameDelegate?
    var question: QuestionStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question.question
        
        configureButtonViews([
            TLButtonView,
            TRButtonView,
            BLButtonView,
            BRButtonView
        ])
        
        question.multipleChoice = question.multipleChoice!.shuffled()
        
        TLButton.setTitle(question.multipleChoice![0].answer, for: .normal)
        TRButton.setTitle(question.multipleChoice![1].answer, for: .normal)
        BLButton.setTitle(question.multipleChoice![2].answer, for: .normal)
        BRButton.setTitle(question.multipleChoice![3].answer, for: .normal)
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
    
    @IBAction func TLButtonView(_ sender: Any) {
        delegate?.showFeedback(from: self, correct: question.multipleChoice![0].correct)
    }
    
    @IBAction func TRButtonView(_ sender: Any) {
        delegate?.showFeedback(from: self, correct: question.multipleChoice![1].correct)
    }
    
    @IBAction func BLButtonView(_ sender: Any) {
        delegate?.showFeedback(from: self, correct: question.multipleChoice![2].correct)
    }
    
    @IBAction func BRButtonView(_ sender: Any) {
        delegate?.showFeedback(from: self, correct: question.multipleChoice![3].correct)
    }
    
    
}
