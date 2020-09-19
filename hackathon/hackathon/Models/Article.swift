import Foundation
import RealmSwift

class Article: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var realm_id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var ean: String? = nil
    @objc dynamic var date: String? = nil
    @objc dynamic var categoryId: String = ""
    @objc dynamic var categoryName: String = ""
    @objc dynamic var count: String? = nil

    convenience init(ean: String, name: String, date: String, realm_id: String, categoryId: String, categoryName: String) {
        self.init()
        self.ean = ean
        self.name = name
        self.date = date
        self.realm_id = realm_id
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.count = "1"
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
