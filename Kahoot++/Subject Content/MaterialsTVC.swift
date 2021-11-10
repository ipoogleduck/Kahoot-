//
//  Materials.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

struct LessonStruct {
    var title: String
    var text: String
    var attachedLink: URL? = nil
}

var lessons: [LessonStruct] = []

var selectedLessonIndex: Int!

class MaterialsTVC: UITableViewController {
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isStudent {
            self.navigationItem.rightBarButtonItem = nil
        }
        lessons = [
            LessonStruct(title: "Implicit Differentiation", text: "Read in OpenStax: The subsection of Section 2.4 titled \"Continuity over an Interval\" from example 2.35 through Theorem 2.10, then Theorem 2.10  - Continuity of Trigonometric Functions"),
            LessonStruct(title: "Trig and Exponential", text: "Read in OpenStax: The subsection of Section 2.4"),
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lessons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialCell", for: indexPath) as! MaterialCell
        let lesson = lessons[indexPath.row]
        cell.titleLabel.text = lesson.title
        cell.contentLabel.text = lesson.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLessonIndex = indexPath.row
        performSegue(withIdentifier: "toLessonSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class MaterialCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
}
