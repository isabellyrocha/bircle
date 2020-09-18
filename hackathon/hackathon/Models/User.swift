import Foundation

struct Consumption: Codable {
    var UserId: String
    var Waters: [Int]
    var Beers: [Int]
    var Colas: [Int]
    
    init(id: String, waters: [Int], beers: [Int], colas: [Int]) {
        self.UserId   = id
        self.Waters = waters
        self.Beers  = beers
        self.Colas = colas
    }
    
    init() {
        self.UserId = UUID().uuidString
        self.Waters = [10, 10, 3, 11, 7, 6, 5, 8, 10, 0, 3, 23]
        self.Beers  = [1, 0, 13, 1, 17, 16, 0, 3, 0, 0, 1, 20]
        self.Colas = [1, 1, 3, 10, 1, 1, 1, 1, 0, 0, 30, 11]
    }
}

enum LoginType: String {
  case normal = "Sign In normally"
  case facebook = "Facebook"
  case apple = "Apple"
  case google = "Google"
  
  var name: String {
    return self.rawValue
  }
}

struct User {
  var username: String?
  var password: String?
  var token: String?
  
  init(username: String?, password: String?, token: String? = nil) {
    self.username = username
    self.password = password
    self.token = token
  }
}
