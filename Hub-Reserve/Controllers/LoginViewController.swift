//
//  LoginViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 18/09/22.
//  https://www.youtube.com/watch?v=JmPbnuJxzHg

import UIKit

fileprivate var aView : UIView?

class LoginViewController: UIViewController {
    //@StateObject private var loginVM = loginViewModel()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @Published var isAuthenticated: Bool = false
    
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
    
    @IBAction func login(_ sender: UIButton) {
        let email = emailTextField.text!
        doLogin (email: email, completion: {
            if self.isAuthenticated {
                let defaults = UserDefaults.standard
                guard let token = defaults.string(forKey: "jwt") else {
                    print("WRONG TOKEN")
                    return
                }
                guard let userId = defaults.string(forKey: "userId") else {
                    print("WRONG ID")
                    return
                }
                
                Task{
                    do{
                        let usuario = try await WebService().getUser(token: token, id: userId)
                        self.removeSpinner()
                        self.changeScreen()
                    } catch {
                        self.removeSpinner()
                        self.displayError(NetworkError.noData, title: "Error al cargar nombre de usuario")
                    }
                }
            }
        })
    }
    
    
    // Cerrar teclado
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func doLogin(email: String, completion: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        showSpinner()
        WebService().login(email: emailTextField.text ?? "", password: passwordTextField.text ?? ""){ result in
            switch result{
            case .success((let token, let id)):
                defaults.setValue(token, forKey: "jwt")
                defaults.setValue(id, forKey: "userId")
                defaults.setValue(email, forKey: "mail")
                
                DispatchQueue.main.async {
                    self.isAuthenticated = true
//                    self.removeSpinner()
                    completion()
                }
                
                //self.userToken = token
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    self.removeSpinner()
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
