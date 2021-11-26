//
//  LessonVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

class LongTextVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: LongTextDelegate?
    var text: String!
    var isEditable: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = text
        textView.isEditable = isEditable
        if !isEditable {
            self.navigationItem.rightBarButtonItem = nil
        }
        updateSaveButton()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        delegate?.save(text: textView.text ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButton()
    }
    
    func updateSaveButton() {
        if !isStudent {
            if let currentText = textView.text, currentText != "" && currentText != text {
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        }
    }
    
    
}

protocol LongTextDelegate {
    func save(text: String)
}
