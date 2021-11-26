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
    
    var delegate: saveMaterialDelegate?
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
        presentLongTextVC(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if isStudent {
            return nil
        } else {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, handler) in
                self.lessons.remove(at: indexPath.row)
                self.delegate?.save(lessons: self.lessons)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    @IBAction func newButton(_ sender: Any) {
        let alert = UIAlertController(title: "Title your lesson", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            let answer = alert.textFields![0].text ?? ""
            let lesson = LessonStruct(title: answer, text: "Add course material here")
            self.lessons.insert(lesson, at: 0)
            self.delegate?.save(lessons: self.lessons)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.presentLongTextVC(for: indexPath)
        }
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    func presentLongTextVC(for indexPath: IndexPath) {
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
    }
    
    func save(text: String) {
        lessons[lastEditIndex].text = text
        tableView.reloadData()
        delegate?.save(lessons: lessons)
    }
    
}

protocol saveMaterialDelegate {
    func save(lessons: [LessonStruct])
}

class MaterialCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
}
