//
//  Consumption.swift
//  hackathon
//
//  Created by Niloofar Gheibi on 8/31/20.
//  Copyright © 2020 Niloofar Gheibi. All rights reserved.
//

import Foundation

let USER_BASE_URL = "localhost:9093"

func GetConsumptionByUserId(userId: String, completionHandler: @escaping (Consumption?) -> Void) {
    let query = "/users/" + userId + "/consumption"
    let url = URL(string: USER_BASE_URL + query)!

    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
            print("Error with fetching user consumption: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
        }

        if let data = data,
            let model = try? JSONDecoder().decode(Consumption.self, from: data) {
            completionHandler(model)
        }
    })
    task.resume()
}
