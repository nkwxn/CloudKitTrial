//
//  SignInView.swift
//  TODOSync (iOS)
//
//  Created by Nicholas on 26/10/21.
//

import SwiftUI
import AuthenticationServices
import CloudKit

struct SignInView: View {
    @ObservedObject var viewModel = SignInViewModel()
    
    var body: some View {
        VStack {
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResult):
                        switch authResult.credential {
                        case let appleIDCred as ASAuthorizationAppleIDCredential:
                            let userID = appleIDCred.user
                            if let fullName = appleIDCred.fullName?.givenName ?? "" + " " + appleIDCred.fullName?.familyName ?? "",
                               let email = appleIDCred.email {
                                let record = CKRecord(recordType: "UsersData", recordID: CKRecord.ID(recordName: userID))
                                record["email"] = email
                                record["fullName"] = fullName
                                // Save to local
                                UserDefaults.standard.set(email, forKey: "email")
                                UserDefaults.standard.set(fullName, forKey: "fullName")
                                let publicDatabase = CKContainer.default().publicCloudDatabase
                                publicDatabase.save(record) { (_, _) in
                                    UserDefaults.standard.set(record.recordID.recordName, forKey: "userID")
                                }
                                // Change login state
                                self.viewModel.login = true
                                // change login state
                            } else {
                                // return to sign in
                                let publicDatabase = CKContainer.default().publicCloudDatabase
                                publicDatabase.fetch(withRecordID: CKRecord.ID(recordName: userID)) { record, error in
                                    if let fetchedInfo = record {
                                        let email = fetchedInfo["email"] as? String
                                        let firstName = fetchedInfo["firstName"] as? String
                                        let lastName = fetchedInfo["lastName"] as? String
                                        // Save to local
                                        UserDefaults.standard.set(userID, forKey: "userID")
                                        UserDefaults.standard.set(email, forKey: "email")
                                        UserDefaults.standard.set(firstName, forKey: "firstName")
                                        UserDefaults.standard.set(lastName, forKey: "lastName")
                                        // Change login state
                                        self.viewModel.login = true
                                    }
                                }
                            }
                        default: break
                        }
                        
                    case .failure(let error):
                        print("failure", error)
                        
                    }
                }
            )
            .signInWithAppleButtonStyle(.whiteOutline)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
