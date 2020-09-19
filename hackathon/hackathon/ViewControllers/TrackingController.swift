import UIKit
import AAInfographics
import RealmSwift

class TrackingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // cell reuse id (cells that scroll out of view can be reused)
    let cellSpacingHeight: CGFloat = 10
    let rowHeight: CGFloat = 180
    var feedItems = [Article()]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // List View Setup
        tableView.delegate = self
        tableView.dataSource = self
        
        updateArticles()
    }
    
    // MARK: - Table View delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.feedItems.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Tracking"
        updateArticles()
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RecycleTableViewCell = tableView.dequeueReusableCell(withIdentifier: RecycleTableViewCell.identifier, for: indexPath) as! RecycleTableViewCell
        cell.configure(with: feedItems[indexPath.row])
        // add border and color
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print(UserDefaults.standard.string(forKey: "email"))
        print("You tapped cell number \(indexPath.section).")
    }
    
    func updateArticles() {
        guard let user = app.currentUser() else {
            fatalError("User must be logged.")
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: "test"))
        let articles = realm.objects(Article.self).filter("status = 'sent'")
        var filteredArticles = [String: Int]()
        
        for article in articles {
            if !filteredArticles.keys.contains(article.date!) {
                print("HERE: \(article.date)")
                filteredArticles[article.date!] = 0
            }
            filteredArticles[article.date!] = Int(filteredArticles[article.date!]!) + Int(article.count!)!
        }
        
        var finalArticles = [Article]()

        for (key, value) in filteredArticles {
            finalArticles.append(Article(date: key, count: String(value)))
        }
        
        self.feedItems = Array(finalArticles)
        

        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
    }
    
}

