//
//  CoursesTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

struct CoursesStruct {
    var name: String
    var instructor: String
}

var courses = [
    CoursesStruct(name: "Math 251", instructor: "Bob Marley"),
    CoursesStruct(name: "Writing 121", instructor: "Yogurt Sauce"),
    CoursesStruct(name: "Engineering 102", instructor: "Dr. Jennifer Parham-Mocello")
]

var selectedCourseIndex: Int!

class CoursesTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        let course = courses[indexPath.row]
        cell.titleLabel.text = course.name
        cell.subTitleLabel.text = "Taught by \(course.instructor)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCourseIndex = indexPath.row
        performSegue(withIdentifier: "materialSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignInSegue", sender: self)
    }
    
}

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
}
