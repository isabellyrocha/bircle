//
//  Ean.swift
//  hackathon
//
//  Created by Niloofar Gheibi on 8/29/20.
//  Copyright © 2020 Niloofar Gheibi. All rights reserved.
//
import Foundation

let EAN_API_KEY = "17b59ae07e623a422907dd947fd251"
let EAN_BASE_URL = "https://api.ean-search.org/api/"

func GetProductByEAN(ean: String, completionHandler: @escaping ([Product]) -> Void) {
  let query = "?op=barcode-lookup&format=json"
  let token = "&token=" + EAN_API_KEY
  let param = "&ean=" + ean
  let url = URL(string: EAN_BASE_URL + query + token + param)!

  let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
    if let error = error {
      print("Error with fetching films: \(error)")
      return
    }

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      print("Error with the response, unexpected status code: \(response)")
      return
    }

    if let data = data,
      let model = try? JSONDecoder().decode([Product].self, from: data) {
      completionHandler(model ?? [])
    }
  })
  task.resume()
}
