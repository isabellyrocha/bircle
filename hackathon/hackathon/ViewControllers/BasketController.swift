import Foundation
import UIKit
import AAInfographics
import RealmSwift

let app = App(id: "hackzurich-uzcbl",
configuration: AppConfiguration(baseURL: "https://realm.mongodb.com",
                                transport: nil,
                                localAppName: nil,
                                localAppVersion: nil))

class BasketController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // cell reuse id (cells that scroll out of view can be reused)
    let cellSpacingHeight: CGFloat = 10
    let rowHeight: CGFloat = 50
    let feedItems = [Product(), Product()]
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var basketCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        
        // Gesture Setup
        let swipeLeft = UISwipeGestureRecognizer()
        let swipeRight = UISwipeGestureRecognizer()
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        super.view.addGestureRecognizer(swipeLeft)
        super.view.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: #selector(swipe(sender:)))
        swipeRight.addTarget(self, action: #selector(swipe(sender:)))
    
        
        // Register the table view cell class and its reuse id
        //let nib = UINib.init(nibName: "MyCustomCell", bundle: nil)
        //self.tblUsers.register(nib, forCellReuseIdentifier: "MyCustomCell")
        self.tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: BasketTableViewCell.identifier)
        
        // Database Setup
        let username = "test@gmail.com"
        let password = "123456"
        
        app.login(credentials: Credentials(username: username, password: password)) { (user, error) in
            DispatchQueue.main.sync {
                guard error == nil else {
                    print("Login failed: \(error!)")
                    return
                }
            }
        }

        guard let user = app.currentUser() else {
            fatalError("User must be logged.")
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: ""))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Basket"
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer){
        switch sender.direction {
        case .left:
            let consumptionController = ConsumptionController()
            self.navigationController!.pushViewController(consumptionController, animated: true)
        case .right:
            let barcodeController = BarcodeController()
            barcodeController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewControllerFromLeft(controller: barcodeController)
        default:
            break
        }
    }
    
    // MARK: - Table View delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.feedItems.count
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
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as! UITableViewCell
        cell.textLabel?.text = feedItems[indexPath.row].name
        cell.textLabel?.textColor = .black
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.backgroundColor = .white
        
        let step = UIStepper()
        let label = UILabel()
        
        cell.addSubview(step)
        step.translatesAutoresizingMaskIntoConstraints = false
        step.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        step.widthAnchor.constraint(equalToConstant: 94).isActive = true
        step.heightAnchor.constraint(equalToConstant: 29).isActive = true
        step.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -30).isActive = true

        cell.addSubview(label)
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.heightAnchor.constraint(equalToConstant: 21).isActive = true
        label.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -124).isActive = true
        label.textColor = .black
        
        return cell
    }
    
    func labelValueChanged(sender:UIStepper!, indexPath: IndexPath, label: UILabel) {
        label.text = feedItems[indexPath.row].name
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print(UserDefaults.standard.string(forKey: "email"))
        print("You tapped cell number \(indexPath.section).")
    }

}

extension UINavigationController {
    func pushViewControllerFromLeft(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToLeft() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
