//
//  LessonVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

class LongTextVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var delegate: LongTextDelegate?
    var text: String!
    var isEditable: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
        textView.isEditable = isEditable
        if !isEditable {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
}

protocol LongTextDelegate {
    func save(text: String)
}
