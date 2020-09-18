import Foundation
import AuthenticationServices
import GoogleSignIn
import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
    }
    
    private func initializeData() {
        /// Placeholder text
        userNameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        
        userNameTextField.layer.cornerRadius = 8
        passwordTextField.layer.cornerRadius = 8
        
        /// Delegate the protocol
        viewModel.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func didTapSignInButton(_ sender: Any) {
        viewModel.login(username: userNameTextField.text, password: passwordTextField.text, type: .normal)
    }
    
    @IBAction func didTapGoogleButton(_ sender: Any) {
        handleGoogleAuthentication()
    }
    
    @IBAction func didTapForgotPasswordButton(_ sender: Any) {
        // TBD
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        // TBD
    }
}

// MARK: - Login with google
extension SignInController: GIDSignInDelegate {
    
    /// Our custom functions
    private func handleGoogleAuthentication() {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = "191338076786-mgso1r2dqd9ror5g8ci2ar5hqufadqgu.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    /// Required functions from protocols
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            logUser(isSuccess: false, type: .google)
        } else {
            viewModel.login(username: user.profile.email, password: "", type: .google)
        }
    }
}

// MARK: - Show result
extension SignInController: LoginResultProtocol {
    func logUser(isSuccess: Bool, user: User? = nil, type: LoginType) {
        print("login attempt for user with email: \(user?.username) was \(isSuccess)")
    }
    
    func success(user: User?, type: LoginType) {
        logUser(isSuccess: true, user: viewModel.user, type: type)
        UserDefaults.standard.set(user?.username, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    
    func error(error: Error, type: LoginType) {
        logUser(isSuccess: false, type: type)
    }
}
