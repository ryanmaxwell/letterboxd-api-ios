//
//  LetterboxdAPIExampleTests.swift
//  LetterboxdAPIExampleTests
//
//  Created by Ryan Maxwell on 2/07/17.
//  Copyright © 2017 Letterboxd. All rights reserved.
//

import XCTest
import LetterboxdRequestSigning
@testable import LetterboxdAPIExample

class LetterboxdAPIExampleTests: XCTestCase {
    
    let key = "REPLACE_WITH_API_KEY"
    let secret = "REPLACE_WITH_API_SECRET"
    
    let username = "REPLACE_WITH_USERNAME_OR_EMAIL"
    let password = "REPLACE_WITH_PASSWORD"
    
    let baseURL = "https://api.letterboxd.com/api/v0"
    
    /// Unauthenticated call
    func testGetFilm() {
        
        let ex = expectation(description: "Task completed")
        
        let url = URL(string: "\(baseURL)/film/29JC")!
        
        let request = URLRequest.signedRequest(for: url, httpMethod: "GET", httpBody: nil, apiKey: key, apiSecret: secret)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print(json)
            } else if let error = error {
                print(error)
            }
            
            ex.fulfill()
        }
        
        task.resume()
        waitForExpectations(timeout: 10)
    }
    
    func testSignIn() {
        let ex = expectation(description: "Task completed")
        
        signIn(username: username, password: password) { token, error in
            if let token = token {
                print(token)
            } else if let error = error {
                switch error {
                case .responseParseError:
                    print("Response parse error")
                case .networkError(let networkError):
                    print("Network error: \(networkError.localizedDescription)")
                }
            }
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func testGetMe() {
        
        let ex = expectation(description: "Task completed")
        
        createSignedInSession { session, error in
            if let session = session {
                
                let url = URL(string: "\(self.baseURL)/me")!
                let request = URLRequest.signedRequest(for: url, httpMethod: "GET", httpBody: nil, apiKey: self.key, apiSecret: self.secret)
                
                let task = session.dataTask(with: request) { data, response, error in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print(json)
                    } else if let error = error {
                        print(error)
                    }
                    
                    ex.fulfill()
                }
                
                task.resume()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func testUpdateFilmRelationship() {
        let ex = expectation(description: "Task completed")
        
        createSignedInSession { session, error in
            if let session = session {
                
                let url = URL(string: "\(self.baseURL)/film/29JC/me")!
                
                let bodyObj: [String: Any] = [
                    "liked": false,
                    "watched": false
                ]
                
                let bodyData = try? JSONSerialization.data(withJSONObject: bodyObj, options: [])
                
                var request = URLRequest.signedRequest(for: url, httpMethod: "PATCH", httpBody: bodyData, apiKey: self.key, apiSecret: self.secret)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = session.dataTask(with: request) { data, response, error in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print(json)
                    } else if let error = error {
                        print(error)
                    }
                    
                    ex.fulfill()
                }
                
                task.resume()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func signIn(username: String, password: String, completion: @escaping ((_ token: APIToken?, _ error: SignInError?) -> Void)) {
        
        let params: [String: String] = [
            "grant_type": "password",
            "username": username,
            "password": password
        ]
        
        let bodyData = params.map { "\($0.key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"}.joined(separator: "&").data(using: .utf8)!
        
        let url = URL(string: "\(baseURL)/auth/token")!
        
        var request = URLRequest.signedRequest(for: url, httpMethod: "POST", httpBody: bodyData, apiKey: key, apiSecret: secret)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                
                if let resp = json as? [String: Any],
                    let accessToken = resp["access_token"] as? String,
                    let expiresIn = resp["expires_in"] as? Int,
                    let refreshToken = resp["refresh_token"] as? String,
                    let tokenType = resp["token_type"] as? String {
                    
                    let token = APIToken(accessToken: accessToken, expiresIn: expiresIn, refreshToken: refreshToken, tokenType: tokenType)
                    
                    completion(token, nil)
                } else {
                    completion(nil, .responseParseError)
                }
            } else if let error = error {
                completion(nil, .networkError(error: error))
            }
        }
        task.resume()
    }
    
    struct APIToken {
        let accessToken: String
        let expiresIn: Int
        let refreshToken: String
        let tokenType: String
    }
    
    enum SignInError: Error {
        case responseParseError
        case networkError(error: Error)
    }
    
    func createSignedInSession(completion: @escaping ((URLSession?, Error?) -> Void)) {
        
        signIn(username: username, password: password) { token, error in
            if let token = token {
                let config = URLSessionConfiguration.default
                config.httpAdditionalHeaders = [
                    "Authorization": "Bearer \(token.accessToken)"
                ]
                let session = URLSession(configuration: config)
                completion(session, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}


