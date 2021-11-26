//
//  UserDefaults.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/24/21.
//

import Foundation
import ALRT

extension UserDefaults {
    
    enum Keys: String {
        case name = "name"
        case id = "id"
        case isSignedIn = "isSignedIn"
        case isStudent = "isStudent"
        case courses = "courses"
    }
    
    static func getString(key: Keys) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func getBool(key: Keys) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func getInt(key: Keys) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func getArray(key: Keys) -> [Any]? {
        return UserDefaults.standard.array(forKey: key.rawValue)
    }
    
    static func getData(key: Keys) -> Data? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? Data
    }
    
    static func save(_ data: Any?, key: Keys) {
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
}

//Custom saving struct if not using json
struct SaveCourses {
    static let key = "courses"
    static func save(_ value: [CoursesStruct]!) {
         UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    static func get() -> [CoursesStruct]? {
        var userData: [CoursesStruct]?
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            do {
                userData = try PropertyListDecoder().decode([CoursesStruct].self, from: data)
            } catch {
                ALRT.create(.alert, title: "Error Getting Data", message: "Data structure has been changed, resetting save data").addOK().show()
            }
            return userData
        } else {
            return userData
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
