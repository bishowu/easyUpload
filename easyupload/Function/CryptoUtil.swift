//
//  CryptoUtil.swift
//  XnFun
//
//  Created by Grant on 2018/11/21.
//  Copyright © 2018 ENIS. All rights reserved.
//

import Foundation
import CommonCrypto

class CryptoUtil {
    
    static func sha512Hex(string: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        if let data = string.data(using: .utf8) {
            let dataNs = data as NSData
            let dataLength = CC_LONG(data.count)
            CC_SHA512(dataNs.bytes, dataLength, &digest)
        }
        //return digest.map { String(format: "%02hhx", $0) }.joined()
        var digestHex = ""
        for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
    
    static func md5File(url: URL) -> String? {
        let bufferSize = 1024 * 1024
        
        do {
            // Open file for reading:
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }
            
            // Calculate once
            var digest: [UInt8] = Array(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            
            // Create and initialize MD5 context:
            var total = 0
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)
            
            // Read up to `bufferSize` bytes, until EOF is reached, and update MD5 context:
            while autoreleasepool(invoking: {
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    total += data.count
                    data.withUnsafeBytes {
                        _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
                    }
                    return true // Continue
                } else {
                    return false // End of file
                }
            }) { }
            
            // Compute the MD5 digest:
            _ = CC_MD5_Final(&digest, &context)
            
            return digest.map { String(format: "%02x", $0) }.joined()
        } catch {
            print("Error: Cannot open file:", error.localizedDescription)
            return nil
        }
    }
}
