//
//  NetworkController.swift
//  Gigapet
//
//  Created by Alex on 5/21/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class NetworkController {
    
    private let baseURL = URL(string: "https://giga-back-end.herokuapp.com/api")!
    var bearer: Bearer?
    var foods: [Food] = []
    var children: [Child] = []

    
    func mySignUp(with user: User, completion: @escaping (Error?) -> Void){
        //get url/end points
        let url = baseURL.appendingPathComponent("users/register")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let je = JSONEncoder()
            request.httpBody =  try je.encode(user)
        } catch  {
            print("Error encoding: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //run data task
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //200 is a success
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                print("Error in signup functon: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    
    func logIn(with user: User, completion: @escaping (Error?) -> Void){
        //get url
        let url = baseURL.appendingPathComponent("users/login")
        
        //create urlRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
      // let postString = ["userName": userName!, "userPassword": userPassword!] as [String: String]
        
        let je = JSONEncoder()
        do {
            let jsonData = try je.encode(user)
            request.httpBody = jsonData
        } catch  {
            print("Error encoding user logging in: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //now that we have the request set up we can run urlsesson
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //we have a problem if it doesn't == 200
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                print("Error making loggin network task: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            //we do want the data because the api states that it will send us our token
            guard let data = data else {
                print("error in the data secion of the login data task: \(NSError())")
                completion(NSError())
                return
            }
            //decode data into our bearer
            let jd = JSONDecoder()
            do {
                //the data we get back is the bearer so we are going to put that in itself and decode itself
                self.bearer = try jd.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding the data into our bearer: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }

    func addFood(foodName: String, foodType: Category, calories: Int, date: String, childId: Int, completion: @escaping (Error?) -> Void){
        let newFood = Food(foodName: foodName, foodType: foodType, calories: calories, date: date, parentId: AppPresets.parentId!, childId: childId)
        
        //get the url
        let url = baseURL.appendingPathComponent("app/addfood")
        
        //create the request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        //unwarp the bearer because we need to add the value to the header
        guard let bearer = bearer else {
            completion(NSError())
            return }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        print("Token: \(bearer.token)")
        
        //we are posting so we need to encode the httpbody
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            // Uncomment after fixing - FIX
            let jsondata = try encoder.encode(newFood)
            request.httpBody =  jsondata
        } catch  {
            print("Error adding food: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //call urlsession after request
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                print("Response: \(response)")
                return
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(error)
                return
            }
            self.foods.append(newFood)
            completion(nil)
            }.resume()
    }

    
    func addChild(name: String, calorieGoal: Int, completion: @escaping (Error?) -> Void){
        let newChild = Child(parentId: AppPresets.parentId!, name: name, calorieGoal: calorieGoal)
        
        //get the url
        let url = baseURL.appendingPathComponent("app/addchild")
        
        //create the request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        //unwarp the bearer because we need to add the value to the header
        guard let bearer = bearer else {
            completion(NSError())
            return }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        print("Token: \(bearer.token)")
        
        //we are posting so we need to encode the httpbody
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsondata = try encoder.encode(newChild)
            request.httpBody =  jsondata
        } catch  {
            print("Error adding food: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //call urlsession after request
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                print("Response: \(response)")
                return
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(error)
                return
            }
            self.children.append(newChild)
            completion(nil)
            }.resume()
    }

}
