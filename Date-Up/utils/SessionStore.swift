//
//  SessionStore.swift
//  Date-Up
//
//  Created by Łukasz Janiszewski on 09/08/2021.
//

import Foundation
import Firebase

struct User {
    var uid: String
    var email: String
}

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var isAnonymous = true
    private var firestoreManager = FirestoreManager()
    private var firebaseStorageManager = FirebaseStorageManager()
    
    var handle: AuthStateDidChangeListenerHandle?
    private let authRef = Auth.auth()
    public let currentUser = Auth.auth().currentUser
    
    func listen() {
        handle = authRef.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.isAnonymous = false
                self.session = User(uid: user.uid, email: user.email!)
            } else {
                self.isAnonymous = true
                self.session = nil
            }
        })
    }
    
    func signIn(email: String, password: String) {
        authRef.signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func signUp(firstName: String, lastName: String, birthDate: Date, country: String, city: String, language: String, email: String, password: String, preference: String) {
        authRef.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error)
            } else {
                self.firestoreManager.signUpDataCreation(id: result!.user.uid, firstName: firstName, lastName: lastName, birthDate: birthDate, country: country, city: city, language: language, email: email, password: password, preference: preference)
            }
        }
    }
    
    func signOut() {
        do {
            self.session = nil
            self.isAnonymous = true
            try authRef.signOut()
        } catch {
        }
    }
    
    func sendRecoveryEmail(_ email: String) {
        authRef.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Error sending recovery e-mail: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteUser(email: String, password: String) {
        let user = authRef.currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user?.reauthenticate(with: credential) { (result, error) in
            if let error = error {
                print("Error re-authenticating user \(error)")
            } else {
                user?.delete { (error) in
                    if let error = error {
                        print("Could not delete user: \(error)")
                    }
                }
                
                self.signOut()
            }
        }
    }
    
    func unbind() {
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
}
