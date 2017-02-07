//
//  ATCFirebaseLoginManager.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/6/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import FirebaseAuth

public class ATCFirebaseLoginManager {
    static func login(credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                // ...
                return
            }
        }
    }

    static func signIn(email: String, pass: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: pass) { (user, error) in
            if let error = error {
                if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .errorCodeUserNotFound:
                        FIRAuth.auth()?.createUser(withEmail: email, password: pass) { (user, error) in
                            if error == nil {
                                ATCFirebaseLoginManager.signIn(email: email, pass: pass)
                            }
                        }
                    default:
                        return
                    }
                }
            }
        }
    }
}
