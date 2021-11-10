//
//  LessonVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

class LessonVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = lessons[selectedLessonIndex].title
        textView.isEditable = !isStudent
        if isStudent {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
}
