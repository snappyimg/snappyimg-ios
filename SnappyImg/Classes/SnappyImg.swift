//
//  SnappyImg.swift
//
//  Created by Martin Vytrhlík.
//  Copyright © 2019 mangoweb s.r.o. All rights reserved.
//

import Foundation
import CryptoSwift


open class SnappyImg {
    
    
    //  options are created with some default values:
    //    shouldEnlarge = true
    //    width = 750
    //    height = 750
    //    resizeType = .fit
    //    gravity = .smart
    
    open class Options {
        
        public enum ResizeType: String {
            case fit, fill, crop
        }
        
        public enum Gravity: String {
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
        
        public init() {
            
        }
        
        convenience public init(width: Int, height: Int, resizeType: ResizeType, gravity: Gravity, shouldEnlarge: Bool) {
            self.init()
            self.width = width
            self.height = height
            self.resizeType = resizeType
            self.gravity = gravity
            self.shouldEnlarge = shouldEnlarge
        }
    }
    
    public enum ExtensionType: String {
        case jpg, png, webp
    }
    
    public enum StageType: String {
        case demo
        case serve
    }
    
    private let stage: StageType
    private var baseUrlString: String {
        return "https://\(stage.rawValue).snappyimg.com"
    }
    private let appToken: String
    private let appSecret: String
    
    //  Change this to change default options or use func encode(urlString: String, resizeType: Options.ResizeType, width: Int, height: Int, gravity: Options.Gravity, shouldEnlarge: Bool, extensionType: ExtensionType) -> String? to set options for one request only
    var baseOptions: Options = Options()
    
    public init(stage: StageType, appToken: String, appSecret: String, options: Options? = nil) {
        self.stage = stage
        self.appToken = appToken
        self.appSecret = appSecret
        if let options = options {
            self.baseOptions = options
        }
    }
    
    open func encode(urlString: String, resizeType: Options.ResizeType, width: Int, height: Int, gravity: Options.Gravity, shouldEnlarge: Bool, extensionType: ExtensionType) -> String? {
        let o = Options()
        o.resizeType = resizeType
        o.width = width
        o.height = height
        o.gravity = gravity
        o.shouldEnlarge = shouldEnlarge
        
        return encode(urlString: urlString, extensionType: extensionType, options: o)
    }
    
    open func encode(url: URL, extensionType: ExtensionType, options: Options? = nil) -> URL? {
        guard let encoded = encode(urlString: url.absoluteString, extensionType: extensionType, options: options) else {
            return nil
        }
        return URL(string: encoded)
    }
    
    open func encode(urlString: String, extensionType: ExtensionType, options: Options? = nil) -> String? {
        
        let base64ImageUrl = getHashedURLString(urlString: urlString)
        let toSign = "\((options ?? baseOptions).toPathString)/\(base64ImageUrl).\(extensionType.rawValue)"
        
        guard let secretHex = appSecret.snappyHexadecimal() else { return nil }
        
        let hmac: HMAC = HMAC(key: secretHex.bytes, variant: .sha256)
        do {
            let bytes = try hmac.authenticate(toSign.bytes)
            let signature = Data(bytes: bytes).snappyCustomBase64
            return baseUrlString + "/" + appToken + "/" + signature + "/" + toSign
        } catch {
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    private func getHashedURLString(urlString: String) -> String {
        return urlString.data(using: String.Encoding.utf8)!.snappyCustomBase64
    }
}

extension String {
    
    // https://stackoverflow.com/a/26502285/326257
    func snappyHexadecimal() -> Data? {
        var data = Data(capacity: count / 2)
        
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

extension Data {
    var snappyCustomBase64: String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=+$", with: "", options: .regularExpression)
    }
}



