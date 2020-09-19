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
    var feedItems = [Article(), Article()]
    let cellReuseIdentifier = "cell"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var basketCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.allowsSelection = false
        
        tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        
        // Gesture Setup
        let swipeLeft = UISwipeGestureRecognizer()
        let swipeRight = UISwipeGestureRecognizer()
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        super.view.addGestureRecognizer(swipeLeft)
        super.view.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: #selector(swipe(sender:)))
        swipeRight.addTarget(self, action: #selector(swipe(sender:)))
        
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
        
        //guard let user = app.currentUser() else {
        //    fatalError("User must be logged.")
        //}
        
        //let realm = try! Realm(configuration: user.configuration(partitionValue: "test"))
        //let articles = realm.objects(Article.self)
        //self.feedItems = Array(realm.objects(Article.self))
        //for article in articles {
        //    print(article.name)
        //}
        
        updateArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Basket"
        updateArticles()
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
    
    func updateArticles() {
        guard let user = app.currentUser() else {
            fatalError("User must be logged.")
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: "test"))
        let articles = realm.objects(Article.self).filter("status = 'unsent'")
        self.feedItems = Array(articles)
        var count = 0
        for article in articles {
            count = count + Int(article.count!)!
        }
        DispatchQueue.main.async{
            self.basketCount.text =  String(count)
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
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
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        let article = feedItems[indexPath.section]
        
        cell.textLabel?.text = article.name
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
        step.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        cell.addSubview(label)
        label.text = article.count!
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.heightAnchor.constraint(equalToConstant: 21).isActive = true
        label.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -124).isActive = true
        label.textColor = .black
        
        return cell
    }
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        let stepperValue = Int(stepper.value)
        //print(stepperValue) // prints value
        
        let indexPath = IndexPath(row: 0, section: stepperValue)
        print(indexPath.section)
        //if let cell = yourTableView.cellForRow(at: indexPath) as? CartListingItemTableViewCell {
        //    cell.label.text = String(stepperValue)
        //    yourValueArray[index] = stepperValue
        
        
        //}
        
    }
    @IBAction func reBottleAction(_ sender:UITapGestureRecognizer){
        let referAlert = UIAlertController(title: "Pick Up Notice", message: "Your driver is on their way to pick your re-cycle bag!", preferredStyle: UIAlertController.Style.alert)
        
        
        
        referAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        referAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
            self.updateArticles()
        }))
        
        self.present(referAlert, animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Pick Up Notice", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        // do other task
        guard let user = app.currentUser() else {
            fatalError("User must be logged.")
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: "test"))
        
        let articles = realm.objects(Article.self).filter("status = 'unsent'")
        for article in articles {
            try! realm.write {
                article.status = "sent"
                article.date = Date.getCurrentDate()
            }
        }
        
    }
    
    // method to run when table view cell is tapped
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // note that indexPath.section is used rather than indexPath.row
    //        print(UserDefaults.standard.string(forKey: "email"))
    //   print("You tapped cell number \(indexPath.section).")
    //}
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
