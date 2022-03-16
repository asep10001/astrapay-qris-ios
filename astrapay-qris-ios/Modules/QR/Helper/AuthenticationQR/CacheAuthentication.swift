//
// Created by Gilbert on 04/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation

class CacheAuthentication : NSObject {

    let firstInstallKey: String = "First_Install"
//    let deviceIdentifier = UIDevice.current.identifierForVendor!.uuidString

    enum KeyName : CaseIterable {
        case LOGIN_DATA
        case SECURE_KEY
        case MOBILE
        case UPDATE_AT
        case USER_DATA
        case BALANCE
    }

//    func saveFirstInstall() {
//        UserDefaults.standard.setValue(true, forKey: self.firstInstallKey)
//    }
//
//    func isFirstInstall() -> Bool {
//        if (UserDefaults.standard.value(forKey: self.firstInstallKey)) != nil {
//            return false
//        } else {
//            return true
//        }
//    }
//
//    func saveLoginCredential(loginData: LoginUserResponse) {
//        do {
//            let jsonData = try JSONEncoder().encode(loginData)
//            let json = String(data: jsonData, encoding: .utf8)
//            UserDefaults.standard.setValue(json, forKey: "\(KeyName.LOGIN_DATA)")
//        } catch {
//        }
//    }
//
//    func getLoginCredential() -> LoginUserResponse? {
//        do {
//            if let json = UserDefaults.standard.string(forKey: "\(KeyName.LOGIN_DATA)") {
//                return try JSONDecoder().decode(LoginUserResponse.self, from: json.data(using: .utf16)! )
//            }
//            return nil
//        } catch {
//            return nil
//        }
//    }
//
//    func saveUserData(data: UserResponse) {
//        do {
//            let jsonData = try JSONEncoder().encode(data)
//            let json = String(data: jsonData, encoding: .utf8)
//            UserDefaults.standard.setValue(json, forKey: "\(KeyName.USER_DATA)")
//        } catch {
//        }
//    }
//
//    func getUserData() -> UserResponse? {
//        do {
//            if let json = UserDefaults.standard.string(forKey: "\(KeyName.USER_DATA)") {
//                return try JSONDecoder().decode(UserResponse.self, from: json.data(using: .utf16)! )
//            }
//            return nil
//        } catch {
//            return nil
//        }
//    }
//
//    func savePhone(phone: String) {
//        UserDefaults.standard.setValue(phone, forKey: "\(KeyName.MOBILE)" )
//    }
//
//    func getPhone() -> String? {
//        return UserDefaults.standard.string(forKey: "\(KeyName.MOBILE)")
//    }
//
//    func clearPhone() {
//        UserDefaults.standard.removeObject(forKey: "\(KeyName.MOBILE)")
//    }
//
//    func saveSecureKey(secureKey: String) {
//        UserDefaults.standard.setValue(secureKey, forKey: "\(KeyName.SECURE_KEY)")
//    }
//
//    func getSecureKey() -> String? {
//        return UserDefaults.standard.string(forKey: "\(KeyName.SECURE_KEY)")
//    }
//
//    func saveBalance(balance: Int) {
//        UserDefaults.standard.setValue(balance, forKey: "\(KeyName.BALANCE)" )
//    }
//
//    func getBalance() -> Int? {
//        return UserDefaults.standard.integer(forKey: "\(KeyName.BALANCE)")
//    }
//
//    func clearForLogout() {
//        for key in KeyName.allCases {
//            UserDefaults.standard.removeObject(forKey: "\(key)")
//        }
//    }
//
//    func clearToPin() {
//        for key in KeyName.allCases {
//            if key != KeyName.MOBILE {
//                UserDefaults.standard.removeObject(forKey: "\(key)")
//            }
//        }
//    }
//
//    func test() {
//        for key in KeyName.allCases {
//            print("---> keyName: \(key) --> \(UserDefaults.standard.string(forKey: "\(key)" ))")
//        }
//    }
//
//    func saveUpdateAt(updateAt: String) {
//        UserDefaults.standard.set(updateAt, forKey: "\(KeyName.UPDATE_AT)")
//    }
//
//    func getUpdateAt() -> String {
//        if let updateAt = UserDefaults.standard.value(forKey: "\(KeyName.UPDATE_AT)") as? String {
//            return updateAt
//        }
//        return ""
//    }
}