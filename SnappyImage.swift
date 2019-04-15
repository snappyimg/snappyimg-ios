//
//  SnappyImage.swift
//
//  Created by Martin Vytrhlík.
//  Copyright © 2019 mangoweb s.r.o. All rights reserved.
//

import Foundation



class SnappyImage {
    
    
    //options are created with some default values
    class Options {
        
        enum ResizeType: String {
            case fit, fill, crop
        }
        
        enum Gravity: String {
            case north = "no", south = "so", east = "ea", west = "we", center = "ce", smart = "sm"
        }
        
        var shouldEnlarge: Bool = true
        
        var width: Int = 750
        
        var height: Int = 750
        
        var resizeType: ResizeType = .fit
        
        var gravity: Gravity = .smart
        
        var toPathString: String {
            return "\(resizeType.rawValue)/\(width)/\(height)/\(gravity.rawValue)/\(shouldEnlarge ? 1 : 0)"
        }
    }
    
    enum ExtensionType: String {
        case jpg, png, webp
    }
    
    private let baseUrlString: String
    private let key: String
    private let salt: String
    
    var baseOptions: Options = Options()
    
    init(baseUrlString: String, key: String, salt: String, options: Options? = nil) {
        self.baseUrlString = baseUrlString
        self.key = key
        self.salt = salt
        if let options = options {
            self.baseOptions = options
        }
    }
    
    func encode(urlString: String, resizeType: Options.ResizeType, width: Int, height: Int, gravity: Options.Gravity, shouldEnlarge: Bool, extensionType: ExtensionType) -> String? {
        let o = Options()
        o.resizeType = resizeType
        o.width = width
        o.height = height
        o.gravity = gravity
        o.shouldEnlarge = shouldEnlarge
        
        return encode(urlString: urlString, extensionType: extensionType, options: o)
    }
    
    func encode(url: URL, extensionType: ExtensionType, options: Options? = nil) -> URL? {
        guard let encoded = encode(urlString: url.absoluteString, extensionType: extensionType, options: options) else {
             return nil
        }
        return URL(string: encoded)
    }
    
    func encode(urlString: String, extensionType: ExtensionType, options: Options? = nil) -> String? {
        
        let path = "/\((options ?? baseOptions).toPathString)/\(getHashedURLString(urlString: urlString)).\(extensionType.rawValue)"
        
        guard let saltHex = salt.snappyHexadecimal() else { return nil }
        guard let keyHex = key.snappyHexadecimal() else { return nil }
        
        let toSign = saltHex + path.utf8
        let signature = toSign.snappyHmac256(key: keyHex)
        return baseUrlString + "/" + signature + path
    }
    
    private func getHashedURLString(urlString: String) -> String {
        return SnappyCustomBase64(input: urlString.data(using: String.Encoding.utf8)!)
    }
}

extension Data {
    
    func snappyHmac256(key: Data) -> String {
        
        let cKey = (key as NSData).bytes
        let cData = (self as NSData).bytes
        var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cKey, key.count, cData, self.count, &result)
        let hmacData: NSData = NSData(bytes: result, length: (Int(CC_SHA256_DIGEST_LENGTH)))
        return SnappyCustomBase64(input: hmacData as Data)
    }
}

extension String {
    
    // https://stackoverflow.com/a/26502285/326257
    func snappyHexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        guard let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive) else {
            return nil
        }
        
        regex.enumerateMatches(in: self, range: NSRange(location: 0, length: utf16.count)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
}

func SnappyCustomBase64(input: Data) -> String {
    return input.base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=+$", with: "", options: .regularExpression)
}
