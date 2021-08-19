//
//  UserViewModel.swift
//  Date-Up
//
//  Created by Łukasz Janiszewski on 02/08/2021.
//

import Foundation
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    private let dataBase = Firestore.firestore()
    private let user = Auth.auth().currentUser
    public let session = SessionStore()
    
    init() {
        self.getUserInfo()
    }
    
    func getUserInfo() {
        if (user != nil) {
            dataBase.collection("profiles").document(user!.uid).getDocument { (document, error) in
                if let document = document {
                    let id = self.user!.uid
                    let firstName = document.get("firstName") as? String ?? ""
                    let lastName = document.get("lastName") as? String ?? ""
                    let birthDate = document.get("birthDate") as? Date ?? Date()
                    let age = document.get("age") as? Int ?? 0
                    let preference = document.get("preference") as? String ?? ""
                    let bio = document.get("bio") as? String ?? ""
                    let email = self.user!.email
                    
                    self.profile = Profile(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate, age: age, preference: preference, bio: bio, email: email!)
                }
            }
        }
    }
}

public func yearsBetweenDate(startDate: Date, endDate: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: startDate, to: endDate)
    return components.year!
}


