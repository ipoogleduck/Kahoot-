//
//  CoursesTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

struct CoursesStruct: Codable {
    var name: String
    var instructor: String
    var lessons: [LessonStruct]
    var leaderboard: [LeaderboardStruct]
    var questions: [QuestionStruct]
}

class CoursesTVC: UITableViewController, saveCourseDelegate {
    
    var courses: [CoursesStruct] = []
    
    var lastCourseIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courses = exampleCourses
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
        guard let subjectTVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SubjectTVC") as? SubjectTVC else {
            fatalError("Unable to Instantiate View Controller")
        }
        subjectTVC.delegate = self
        subjectTVC.course = courses[indexPath.row]
        lastCourseIndex = indexPath.row
        navigationController?.pushViewController(subjectTVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignInSegue", sender: self)
    }
    
    func save(course: CoursesStruct) {
        courses[lastCourseIndex] = course
        tableView.reloadData()
    }
    
}

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
}
