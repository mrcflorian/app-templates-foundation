//
//  ATCLoginViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/6/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import FacebookCore
import FacebookLogin
import TwitterKit
import UIKit

let kLoginButtonBackgroundColor = UIColor(colorLiteralRed: 31/255, green: 75/255, blue: 164/255, alpha: 1)
let kLoginButtonTintColor = UIColor.white
let kLoginButtonCornerRadius: CGFloat = 13.0


let kTwitterLoginButtonBackgroundColor = UIColor(colorLiteralRed: 85/255, green: 172/255, blue: 239/255, alpha: 1)
let kTwitterLoginButtonTintColor = UIColor.white
let kTwitterLoginButtonCornerRadius: CGFloat = 13.0

let kFacebookLoginButtonBackgroundColor = UIColor(colorLiteralRed: 59/255, green: 89/255, blue: 153/255, alpha: 1)
let kFacebookLoginButtonTintColor = UIColor.white
let kFacebookLoginButtonCornerRadius: CGFloat = 13.0

class ATCLoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!

    @IBOutlet var facebookLoginButton: UIButton!
    @IBOutlet var twitterLoginButton: UIButton!
    // Facebook login permissions
    // Add extra permissions you need
    // Remove permissions you don't need
    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLoginButton(loginButton)
        prepareTwitterButton(twitterLoginButton)
        prepareFacebookButton(facebookLoginButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    fileprivate func prepareLoginButton(_ button: UIButton) {
        button.backgroundColor = kLoginButtonBackgroundColor
        button.layer.cornerRadius = kLoginButtonCornerRadius
        button.tintColor = kLoginButtonTintColor
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }

    fileprivate func prepareTwitterButton(_ button: UIButton) {
        button.backgroundColor = kTwitterLoginButtonBackgroundColor
        button.layer.cornerRadius = kTwitterLoginButtonCornerRadius
        button.tintColor = kTwitterLoginButtonTintColor
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        button.addTarget(self, action: #selector(didTapTwitterLoginButton), for: .touchUpInside)
    }

    fileprivate func prepareFacebookButton(_ button: UIButton) {
        button.backgroundColor = kFacebookLoginButtonBackgroundColor
        button.layer.cornerRadius = kFacebookLoginButtonCornerRadius
        button.tintColor = kFacebookLoginButtonTintColor
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        button.addTarget(self, action: #selector(didTapFacebookLoginButton), for: .touchUpInside)
    }

    @objc
    fileprivate func didTapLoginButton(_ sender: LoginButton) {
        // Regular login attempt. Add the code to handle the login by email and password.
        guard let email = usernameTextField.text, let pass = passwordTextField.text else {
            // It should never get here
            return
        }
        didLogin(method: "email and password", info: "Email: \(email) \n Password: \(pass)")
    }

    @objc
    fileprivate func didTapFacebookLoginButton(_ sender: UIButton) {
        // Facebook login attempt
        LoginManager().logIn(readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }

    @objc
    fileprivate func didTapTwitterLoginButton(_ sender: UIButton) {
        // Twitter login attempt
        Twitter.sharedInstance().logIn(completion: { session, error in
            if let session = session {
                // Successful log in with Twitter
                print("signed in as \(session.userName)");
                let info = "Username: \(session.userName) \n User ID: \(session.userID)"
                self.didLogin(method: "Twitter", info: info)
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
    }

    fileprivate func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_): break
        default: break
        }
    }

    fileprivate func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let facebookAPIManager = ATCFacebookAPIManager(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                if let email = facebookUser?.email,
                    let firstName = facebookUser?.firstName,
                    let lastName = facebookUser?.lastName {
                    let info = "First name: \(firstName) \n Last name: \(lastName) \n Email: \(email)"
                    self.didLogin(method: "Facebook", info: info)
                }
            })
        }
    }

    fileprivate func didLogin(method: String, info: String) {
        let message = "Successfully logged in with \(method). " + info
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
