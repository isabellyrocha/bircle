import Foundation

struct Product: Codable {
    var ean: String
    var name: String
    var categoryId: String
    var categoryName: String
    
    init() {
        self.name = "test"
        self.ean  = "test"
        self.categoryId = "test"
        self.categoryName = "test"
    }
}
