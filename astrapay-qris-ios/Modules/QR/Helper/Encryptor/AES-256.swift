//
//  AES-256.swift
//  astrapay
//
//  Created by Guntur Budi on 17/10/20.
//  Copyright © 2020 Tirta Rivaldi. All rights reserved.
//

import Foundation
import CommonCrypto

struct AES256 {
    
    private var key: Data
    private var iv: Data
    
    public init(key: Data, iv: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw Error.badKeyLength
        }
        guard iv.count == kCCBlockSizeAES128 else {
            throw Error.badInputVectorLength
        }
        self.key = key
        self.iv = iv
    }
    
    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }
    
    //TODO: Perlu direfactor titipan dari mas guntur
    
    func encrypt(_ digest: Data) throws -> Data {
        return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }
    
    func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }
    
    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = Int(0)
        var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        input.withUnsafeBytes { rawBufferPointer in
               let encryptedBytes = rawBufferPointer.baseAddress!
               iv.withUnsafeBytes { ivRawBytes in
                   let ivBytes = ivRawBytes.baseAddress!
                   key.withUnsafeBytes { keyRawBytes in
                       let keyBytes = keyRawBytes.baseAddress!
                       status = CCCrypt(operation,
                                CCAlgorithm(kCCAlgorithmAES),            // algorithm
                                CCOptions(kCCOptionPKCS7Padding),           // options
                                keyBytes,                                   // key
                                key.count,                                  // keylength
                                ivBytes,                                    // iv
                                encryptedBytes,                             // dataIn
                                input.count,                                // dataInLength
                                &outBytes,                                  // dataOut
                                outBytes.count,                             // dataOutAvailable
                                &outLength)                                 // dataOutMoved
                   }
               }
           }
           
           guard status == kCCSuccess else {
               throw Error.cryptoFailed(status: status)
           }
                   
           return Data(bytes: &outBytes, count: outLength)
    }
    
    static func createKey(key: Data, salt: Data) throws -> Data {
        let length = kCCKeySizeAES256
        var status = Int32(0)
        var derivedBytes = [UInt8](repeating: 0, count: length)
        key.withUnsafeBytes { rawBufferPointer in
                let passwordRawBytes = rawBufferPointer.baseAddress!
                let passwordBytes = passwordRawBytes.assumingMemoryBound(to: Int8.self)
                
                salt.withUnsafeBytes { rawBufferPointer in
                    let saltRawBytes = rawBufferPointer.baseAddress!
                    let saltBytes = saltRawBytes.assumingMemoryBound(to: UInt8.self)
                    status = CCKeyDerivationPBKDF(
                        CCPBKDFAlgorithm(kCCPBKDF2),                // algorithm
                        passwordBytes,                              // password
                        key.count,                                  // passwordLen
                        saltBytes,                                  // salt
                        salt.count,                                 // saltLen
                        UInt32(kCCPRFHmacAlgSHA1),                // prf
                        1024,                                      // rounds
                        &derivedBytes,                              // derivedKey
                        length)
    
                }
            }
            

            guard status == 0 else {
                throw Error.keyGeneration(status: Int(status))
            }
            return Data(bytes: &derivedBytes, count: length)
    }
    
    static func randomIv() -> Data {
        return randomData(length: kCCBlockSizeAES128)
    }
    
    static func randomSalt() -> Data {
        return randomData(length: 8)
    }
    
    static func randomData(length: Int) -> Data {
        var data = Data(count: length)
        var status = data.withUnsafeMutableBytes { mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, length, mutableBytes)
        }
        
        assert(status == Int32(0))
        return data
    }
}
