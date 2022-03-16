//
// Created by Gilbert on 04/11/21.
// Copyright (c) 2021 Astra Digital Arta. All rights reserved.
//

import Foundation


struct QrEncryptorPayload{
    var key : String
    var salt : String
}


class QrEncryptor {
    var key : Data = ".bersamaqris987.".data(using: .utf8)!
    static let arr : [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var iv : Data = Data(QrEncryptor.arr)
    var salt : Data = "!behelpfulpeople!".data(using: .utf8)!

    struct QRISEncryptorPayload{
        static let key = ".bersamaqris987."
        static let salt = "!behelpfulpeople!"
    }

    struct CommonEncryptorPayload {
        static let key = "Astrapay150!"
    }

    init(_ payload : QrEncryptorPayload) {
        self.key = payload.key.data(using: .utf8)!
        self.salt = payload.salt.data(using: .utf8)!
    }

    func encrypt(_
                 params: String) -> String {
        var returnValue = ""
        do {
            var digest = "".data(using: .utf8)!
            let req = params.data(using: .utf8)!
            digest = req
            let key = try AES256.createKey(key: self.key, salt: salt)
            let aes = try AES256(key: key, iv: iv)
            let encrypted = try aes.encrypt(digest)
            returnValue = encrypted.base64EncodedString()
            return returnValue
        } catch {
            print("Failed Encrypt with error \(error)")
            return "Encrypt Error"
        }
    }

    func decrypt(_ params : String) -> String {
        var returnValue = ""
        do {
            var digest = Data()
            let resps = Data(base64Encoded: params, options: .ignoreUnknownCharacters)!
            digest = resps
            let key = try AES256.createKey(key: self.key, salt: salt)
            let aes = try AES256(key: key, iv: iv)
            let decrypted = try aes.decrypt(digest)
            returnValue = String(data: decrypted, encoding: .utf8) ?? "Decrypt Failed"
            return returnValue
        } catch {
            print("Failed Decrypt with error \(error)")
            return "Decrypt Error"
        }
    }

    static func encryptPassword(phoneNumber: String, password: String) -> String {
        let encryptor = QrEncryptor(QrEncryptorPayload(
                key: QrEncryptor.CommonEncryptorPayload.key,
                salt: "\(phoneNumber)-\(DateFormatter.generateCurrentDateQR(FromTypeDateQR.yyyyMMddStrip))"))
        return encryptor.encrypt(password)
    }



    //MARK: BOTTOM WILL NOT USED
    func encryptRequest(keys : String,
                        iv: String = "0000000000000000",
                        salt: String,
                        params: String) -> String {
        var returnValue = ""

        self.key = keys.data(using: .utf8)!
        self.iv = iv.data(using: .utf8)!
        self.salt = salt.data(using: .utf8)!

        do {
            var digest = "".data(using: .utf8)!
            let resps = Data(base64Encoded: params, options: .ignoreUnknownCharacters)!
            digest = resps
            let key = try AES256.createKey(key: self.key, salt: self.salt)
            let aes = try AES256(key: key, iv: self.iv)
            let encrypted = try aes.encrypt(digest)
            print(String(data: encrypted, encoding: .utf8) ?? "Decrypt Failed")
            returnValue = String(data: encrypted, encoding: .utf8) ?? "Decrypt Failed"
            return returnValue
        } catch {
            print("Failed Decrypt with error \(error)")
            return "Decrypt Error"
        }
    }


    func decryptQRISTranslate(_ params : String) -> String{
        var returnValue = ""

        self.key = QRISEncryptorPayload.key.data(using: .utf8)!
        self.salt = QRISEncryptorPayload.salt.data(using: .utf8)!

        do {
            print(params)
            var digest = Data()//"".data(using: .utf8)!
//            let resps = Data(base64Encoded: params, options: .ignoreUnknownCharacters)!
            print("PARAMS IN : " + params)
            let temp = params
            let resps = Data(base64Encoded: temp)!
            print(resps.base64EncodedString())
            digest = resps
            let key = try AES256.createKey(key: self.key, salt: salt)
            let aes = try AES256(key: key, iv: iv)
            let decrypted = try aes.decrypt(digest)
            returnValue = String(data: decrypted, encoding: .utf8) ?? "Decrypt Failed"
            return returnValue
        } catch {
            print("Failed Decrypt with error \(error)")
            return "Decrypt Error"
        }
    }

    func encryptQRISRequest(_ params : String)-> String{
        var returnValue = ""
        self.key = QRISEncryptorPayload.key.data(using: .utf8)!
        self.salt = QRISEncryptorPayload.salt.data(using: .utf8)!
        do {
            var digest = "".data(using: .utf8)!
            let req = params.data(using: .utf8)!
            digest = req
            let key = try AES256.createKey(key: self.key, salt: salt)
            let aes = try AES256(key: key, iv: iv)
            let encrypted = try aes.encrypt(digest)

            returnValue = encrypted.base64EncodedString()
            return returnValue
        } catch {
            print("Failed Decrypt with error \(error)")
            return "Encrypt Error"
        }
    }

}