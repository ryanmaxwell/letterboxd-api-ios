//
//  LetterboxdRequestSigning.swift
//  LetterboxdAPIExample
//
//  Created by Ryan Maxwell on 12/06/17.
//  Copyright © 2017 Letterboxd. All rights reserved.
//

import Foundation

public struct LetterboxdRequestSigning {
    
    public static func signedURL(for url: URL, httpMethod: String, httpBody: Data?, apiKey: String, apiSecret: String) -> URL {
        
        let nonce = UUID().uuidString
        let timestamp = Date().timeIntervalSince1970
        
        var urlString = url.absoluteString
        
        if urlString.contains("?") {
            urlString += "&"
        } else {
            urlString += "?"
        }
        
        urlString += "apikey=\(apiKey)&nonce=\(nonce)&timestamp=\(Int(timestamp))"
        
        var plainTextData = httpMethod.data(using: .utf8)!
        plainTextData.append(0)
        plainTextData.append(urlString.data(using: .utf8)!)
        plainTextData.append(0)
        if let httpBody = httpBody {
            plainTextData.append(httpBody)
        }
        
        let signature = HMAC.sign(plainTextData, withKey: apiSecret, using: .SHA256)
        
        urlString += "&signature=\(signature)"
        
        return URL(string: urlString)!
    }
}

public extension URLRequest {
    
    public static func signedRequest(for url: URL, httpMethod: String, httpBody: Data?, apiKey: String, apiSecret: String) -> URLRequest {
        
        let signedURL = LetterboxdRequestSigning.signedURL(for: url, httpMethod: httpMethod, httpBody: httpBody, apiKey: apiKey, apiSecret: apiSecret)
        
        var request = URLRequest(url: signedURL)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        return request
    }
}

extension NSMutableURLRequest {
    
    @objc(signedRequestForURL:HTTPMethod:HTTPBody:APIKey:APISecret:)
    class func signedRequest(for url: URL, httpMethod: String, httpBody: Data?, apiKey: String, apiSecret: String) -> NSMutableURLRequest {
        
        let signedURL = LetterboxdRequestSigning.signedURL(for: url, httpMethod: httpMethod, httpBody: httpBody, apiKey: apiKey, apiSecret: apiSecret)
        
        let request = NSMutableURLRequest(url: signedURL)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        return request
    }
}
