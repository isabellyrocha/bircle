import Foundation

struct Wallet: Codable {
    let beerKey = "beer"
    let waterKey = "water"
    let colaKey = "cola"
    
    // the numbers are based on the cents calculated for pfands in Germany
    let beerValue = 8
    let waterValue = 25
    let colaValue = 15
    
    var consumption: Consumption
    var values: [String: Int] = [:]
    var pfand: String
    
    init(consumption: Consumption, country: String) {
        self.consumption   = consumption
        
        if (country == "DE"){
            self.pfand = "cents"
        } else {
            self.pfand = "coins"
        }
    }
    
    mutating func evaluate() {
        for count in self.consumption.recycledArticles {
            self.values[beerKey] = count * beerValue
        }
        
        for count in self.consumption.recycledArticles {
            self.values[waterKey] = count * waterValue
        }
        
        for count in self.consumption.recycledArticles {
            self.values[colaKey] = count * colaValue
        }
    }
}
