//
//  loginViewModel.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 03/10/22.
//

import Foundation

class loginViewModel: ObservableObject{
    var email: String = ""
    var password: String = ""
    
    func login(){
        WebService().login(email: email, password: password){ result in
            switch result{
            case.success(let token):
                print(token)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
