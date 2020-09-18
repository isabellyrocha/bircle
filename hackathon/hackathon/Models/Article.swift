import Foundation
import RealmSwift

class Article: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var realm_id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var ean: String? = nil
    @objc dynamic var date: String? = nil

    
    convenience init(ean: String, name: String, date: String, realm_id: String) {
        self.init()
        self.ean = ean
        self.name = name
        self.date = date
        self.realm_id = realm_id
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
