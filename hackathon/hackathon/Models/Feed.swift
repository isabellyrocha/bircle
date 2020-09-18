import Foundation

struct FeedItem: Codable {
    var ScanDate: String
    var Water: Int
    var Beer: Int
    var Cola: Int
    var Recycled: Bool
    
    init(date: String, water: Int, beer: Int, cola: Int, recycled: Bool) {
        self.ScanDate   = date
        self.Water = water
        self.Beer  = beer
        self.Cola = cola
        self.Recycled = recycled
    }
    
    init() {
        self.ScanDate = Date.getCurrentDate()
        self.Water = Int.random(in: 7..<10)
        self.Beer  = Int.random(in: 3..<5)
        self.Cola = Int.random(in: 0..<3)
        self.Recycled = false
    }
}
