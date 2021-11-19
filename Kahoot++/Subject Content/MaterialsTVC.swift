//
//  Materials.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

struct LessonStruct: Codable {
    var title: String
    var text: String
    var attachedLink: URL? = nil
}

class MaterialsTVC: UITableViewController, LongTextDelegate {
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    var lessons: [LessonStruct]!
    
    var lastEditIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isStudent {
            self.navigationItem.rightBarButtonItem = nil
        }
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
        guard let longTextVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LongTextVC") as? LongTextVC else {
            fatalError("Unable to Instantiate View Controller")
        }
        longTextVC.delegate = self
        lastEditIndex = indexPath.row
        let lesson = lessons[indexPath.row]
        longTextVC.title = lesson.title
        longTextVC.text = lesson.text
        longTextVC.isEditable = !isStudent
        navigationController?.pushViewController(longTextVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func save(text: String) {
        lessons[lastEditIndex].text = text
    }
    
}

class MaterialCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
}
