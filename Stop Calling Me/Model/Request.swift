//
//  Request.swift
//  Stop Calling Me
//
//  Created by Bastian Oliver Schwickert on 24/12/2019.
//  Copyright © 2019 Bastian Oliver Schwickert. All rights reserved.
//

import Foundation

class Request{

    enum ScammerError:Error {
        case noDataAvailable
        case canNotProcessData
    }
    
    func getScammers(completion: @escaping(Result<[ScammerDetail], ScammerError>) -> Void) {
        let url = URL(string: "https://stopcallingme.ca/api/spam")!
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let scammerResponse = try decoder.decode(Scammers.self, from: jsonData)
                let scammerDetails = scammerResponse.rows
                completion(.success(scammerDetails))
            }catch{
                completion(.failure(.canNotProcessData))
            }
        }
        task.resume()
    }
    
    func post(urlString: String, parameters: [String : Any]){
        let url = URL(string: urlString)!
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject:
                parameters,   options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    
        let task = session.dataTask(with: request as URLRequest, completionHandler: {   data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options:     .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

}
