//
//  SignInViewModel.swift
//  TODOSync (iOS)
//
//  Created by Nicholas on 26/10/21.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    @AppStorage("login") var login = false
    
    let userID = UserDefaults.standard.object(forKey: "userID") as? String
}
