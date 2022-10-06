//
//  LoginViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 18/09/22.
//  https://www.youtube.com/watch?v=JmPbnuJxzHg

import UIKit

class LoginViewController: UIViewController {
    var userControlador = UserController()
    //@StateObject private var loginVM = loginViewModel()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @Published var isAuthenticated: Bool = false
    
    @IBAction func login(_ sender: UIButton) {
        doLogin {
            if self.isAuthenticated {
                self.changeScreen()
            }
        }
    }
    
    
    // Cerrar teclado
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func doLogin(completion: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        
        WebService().login(email: emailTextField.text ?? "", password: passwordTextField.text ?? ""){ result in
            switch result{
            case .success(let token):
                defaults.setValue(token, forKey: "jwt")
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    completion()
                }
                
                //self.userToken = token
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    self.showBadLogin()
                    completion()
                    print(error)
                }
            }
        }
        
    }
    
    func showBadLogin(){
        let alertView = UIAlertController(title: "Error", message: "Su correo o contraseña son incorrectos", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Reintentar", style: .cancel))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func changeScreen() {
        let nextScreen = self.storyboard!.instantiateViewController(withIdentifier: "main") as! UITabBarController
        nextScreen.modalPresentationStyle = .fullScreen
        self.present(nextScreen, animated: false, completion: nil)
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }

        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
    }

    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
}
