import Foundation

struct Consumption: Codable {
    var userId: String
    var recycledArticles: [Int]
    
    init(id: String, recycledArticles: [Int]) {
        self.userId   = id
        self.recycledArticles = recycledArticles
    }
    
    init() {
        self.userId = UUID().uuidString
        self.recycledArticles = [10, 10, 3, 11, 7, 6, 5, 8, 10, 0, 3, 23]
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
