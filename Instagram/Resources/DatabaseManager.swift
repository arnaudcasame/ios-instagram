//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Arnaud Casame on 2/24/21.
//

import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    // MARK: - Public
    
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void){
        completion(true)
    }
    
    public func insertNewUser(with email:  String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
            if error == nil {
                // succeeded
                completion(true)
                return
            }else{
                // failed
                completion(false)
                return
            }
        }
    }
}
